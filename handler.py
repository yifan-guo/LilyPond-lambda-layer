import subprocess
import os
import boto3
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger()

def lambda_handler(event, context):
    logger.info("Lambda function started")

    s3 = boto3.client('s3')

    # Assuming you pass the bucket name and file names in the event
    bucket_name = event['bucket']
    input_file_key = event['input_file']
    output_file_key = event['output_file']
    
    logger.info("Downloading file from S3: bucket=%s, key=%s", bucket_name, input_file_key)

    # Download the .ly file from S3
    input_file_path = f'/tmp/{os.path.basename(input_file_key)}'
    
    try:
        s3.download_file(bucket_name, input_file_key, input_file_path)
        logger.info("File downloaded successfully: %s", input_file_path)
        
        # Generate PDF using LilyPond
        output_pdf_path = f'/tmp/{os.path.splitext(os.path.basename(input_file_key))[0]}.pdf'
        logger.info("Generating PDF using LilyPond: %s", input_file_path)

        # Execute the LilyPond command to generate PDF
        result = subprocess.run(['/opt/bin/lilypond', input_file_path], capture_output=True,  # Capture stdout and stderr
            text=True,            # Decode output to string
            check=False            # Raise CalledProcessError for non-zero exit codes
        )

        # Print the output
        logger.info("Output:\n%s", result.stdout)

        # Print any errors (if needed)
        if result.stderr:
            logger.error("Error:\n%s", result.stderr)
        # subprocess.run(['ls', '/opt/bin'], check=True)
        
        logger.info("PDF generated successfully: %s", output_pdf_path)
        
        # Upload the generated PDF back to S3
        s3.upload_file(output_pdf_path, bucket_name, output_file_key)
        logger.info("PDF uploaded successfully to S3: bucket=%s, key=%s", bucket_name, output_file_key)
        
        return {
            'statusCode': 200,
            'body': f'PDF generated successfully and uploaded to {output_file_key}'
        }
    except subprocess.CalledProcessError as e:
        logger.error("Error generating PDF: %s", e)
        return {
            'statusCode': 500,
            'body': f'Error generating PDF: {e}'
        }
    except Exception as e:
        logger.error("An unexpected error occurred: %s", e)
        return {
            'statusCode': 500,
            'body': f'An unexpected error occurred: {e}'
        }
