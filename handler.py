import subprocess
import os
import boto3
import shutil

# Set up logging

def lambda_handler(event, context):
    print("Lambda function started")

    s3 = boto3.client('s3')
    bucket_name = event['bucket']
    input_file_key = event['input_file']
    output_file_key = event['output_file']
    
    print("Downloading file from S3: bucket=%s, key=%s", bucket_name, input_file_key)

    input_file_path = f'/tmp/{os.path.basename(input_file_key)}'
    output_pdf_path = f'/tmp/{os.path.splitext(os.path.basename(input_file_key))[0]}.pdf'

    fontconfig_cache_dir = '/tmp/fontconfig'
    os.environ['FONTCONFIG_CACHE'] = fontconfig_cache_dir
    os.environ['FONTCONFIG_PATH'] = fontconfig_cache_dir

    # Clear old cache
    shutil.rmtree(fontconfig_cache_dir, ignore_errors=True)
    os.makedirs(fontconfig_cache_dir, exist_ok=True)
    print("Fontconfig cache directory set to: %s", fontconfig_cache_dir)

    try:
        s3.download_file(bucket_name, input_file_key, input_file_path)
        print("File downloaded successfully: %s", input_file_path)

        # Generate PDF using LilyPond
        print("Generating PDF using LilyPond: %s", input_file_path)

        command = ['/opt/bin/lilypond', input_file_path]
        print("Running command: %s", ' '.join(command))

        # Check Fontconfig settings
        fc_list_result = subprocess.run(['fc-list'], capture_output=True, text=True)
        print("Fontconfig list:\n%s", fc_list_result.stdout)

        result = subprocess.run(command, capture_output=True, text=True)

        # Log the output
        print("Output:\n%s", result.stdout)

        if result.returncode != 0:
            print("LilyPond command failed with return code %s", result.returncode)
            print("Error:\n%s", result.stderr)
            return {
                'statusCode': 500,
                'body': f'Error generating PDF: {result.stderr}'
            }

        print("PDF generated successfully: %s", output_pdf_path)

        # Upload the generated PDF back to S3
        s3.upload_file(output_pdf_path, bucket_name, output_file_key)
        print("PDF uploaded successfully to S3: bucket=%s, key=%s", bucket_name, output_file_key)

        return {
            'statusCode': 200,
            'body': f'PDF generated successfully and uploaded to {output_file_key}'
        }
    except subprocess.CalledProcessError as e:
        print("Error generating PDF: %s", e)
        return {
            'statusCode': 500,
            'body': f'Error generating PDF: {e}'
        }
    except Exception as e:
        print("An unexpected error occurred: %s", e)
        return {
            'statusCode': 500,
            'body': f'An unexpected error occurred: {e}'
        }
