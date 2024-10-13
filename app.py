import os
import subprocess
import boto3

def lambda_handler(event, context):
    s3 = boto3.client('s3')

    # Assuming the input and output keys are passed in the event
    bucket_name = event['bucket']
    input_file_key = event['input_file']
    output_file_key = event['output_file']

    # Download the .ly file from S3
    input_file_path = f'/tmp/{os.path.basename(input_file_key)}'
    s3.download_file(bucket_name, input_file_key, input_file_path)

    # Generate PDF using LilyPond
    command = ['/opt/lilypond/bin/lilypond', input_file_path]
    print(f"Running command: {command}")
    result = subprocess.run(command, capture_output=True, text=True)

    if result.returncode != 0:
        raise Exception(f"LilyPond error: {result.stderr}")

    # Upload the generated PDF back to S3
    output_pdf_path = f'/tmp/{os.path.splitext(os.path.basename(input_file_key))[0]}.pdf'
    s3.upload_file(output_pdf_path, bucket_name, output_file_key)

    return {
        'statusCode': 200,
        'body': f'PDF generated and uploaded to {output_file_key}'
    }
