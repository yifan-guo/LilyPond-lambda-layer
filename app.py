import os
import subprocess
import boto3

def lambda_handler(event, context):
    s3 = boto3.client('s3')

    # Set the fontconfig cache directory
    os.environ['FONTCONFIG_CACHE'] = '/tmp/fontconfig'
    # Log the current environment variables
    print(f"FONTCONFIG_CACHE: {os.environ['FONTCONFIG_CACHE']}")

    # Create the fontconfig cache directory at runtime
    fontconfig_cache_dir = "/tmp/fontconfig"
    os.makedirs(fontconfig_cache_dir, exist_ok=True)
    os.chmod(fontconfig_cache_dir, 0o777)

    # Run fc-cache to initialize fontconfig cache
    result = subprocess.run(['fc-cache', '-f', '-v'], check=True)
    print("fc-cache output: {}".format(result.stdout))

    # Check the contents of /tmp
    result = subprocess.run(['ls', '-lah', '/tmp/'], capture_output=True, text=True)
    print("permissions of /tmp: {}".format(result.stdout))

    # Ensure the fontconfig cache directory exists and is writable
    result = subprocess.run(['ls', '-la', fontconfig_cache_dir], capture_output=True, text=True)
    print(f"Fontconfig cache directory: {result.stdout}")
    
    # Verify contents are writeable
    result = subprocess.run(['ls', '-la', '/usr/share/fonts'], capture_output=True, text=True)
    print("permissions of /usr/share/fonts: {}".format(result.stdout))

    # verify fonts are available
    result = subprocess.run(['fc-list'], capture_output=True, text=True)
    print("available fonts: {}".format(result.stdout))

    # Download the .ly file from S3
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
