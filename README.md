# authenticate docker to ecr
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 105411766712.dkr.ecr.us-east-2.amazonaws.com

# build image
docker build pdf-generator-lambda:latest .

# tag image
docker tag pdf-generator-lambda:latest 105411766712.dkr.ecr.us-east-2.amazonaws.com/lilypond/pdf-generator-lambda:latest

# push repository
docker push 105411766712.dkr.ecr.us-east-2.amazonaws.com/lilypond/pdf-generator-lambda:latest

# Run command inside of image
```
/opt/lilypond/bin/lilypond /tmp/output/output.ly
```