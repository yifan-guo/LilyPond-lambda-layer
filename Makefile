# Variables
AWS_REGION=us-east-2
ECR_URI=105411766712.dkr.ecr.$(AWS_REGION).amazonaws.com/lilypond/pdf-generator-lambda:latest
IMAGE_NAME=pdf-generator-lambda

# Authenticate Docker to ECR
.PHONY: login
login:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(ECR_URI)

# Build the Docker image for x86_64
.PHONY: build
build:
	docker build --provenance=false --no-cache --platform linux/arm64/v8 -t $(IMAGE_NAME):latest .

# Tag the Docker image
.PHONY: tag
tag: build
	docker tag $(IMAGE_NAME):latest $(ECR_URI)

# Push the Docker image to ECR
.PHONY: push
push: tag
	docker push $(ECR_URI)

# Clean up dangling Docker images
.PHONY: clean
clean:
	docker rmi -f $$(docker images -f "dangling=true" -q)

# Full workflow
.PHONY: all
all: login push inspect

.PHONY: inspect
inspect: 
	docker inspect $(IMAGE_NAME):latest | grep Architecture

.PHONY: run
run:
	docker run -p 9000:8080 $(IMAGE_NAME):latest