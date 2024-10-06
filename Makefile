# Variables
IMAGE_NAME = lilypond-layer
OUTPUT_DIR = $(shell pwd)

# Default target
all: build

# Build the Docker image
build:
	docker build --platform linux/amd64 -t $(IMAGE_NAME) .

# Run interactive shell and mount .ly file
run-interactive:
	docker run -v $(OUTPUT_DIR):/output --platform linux/amd64 -it $(IMAGE_NAME) /bin/bash

# Generate Lambda layer .zip file
generate-layer:
	docker run --rm -v $(OUTPUT_DIR):/output --platform linux/amd64 $(IMAGE_NAME) cp /opt/lilypond_layer.zip /output/

# Clean up any existing container (not necessary for this workflow but kept for reference)
clean:
	docker rm -f $(CONTAINER_NAME) || true

# Remove the Docker image
clean-image:
	docker rmi $(IMAGE_NAME) || true

.PHONY: all build run-interactive generate-layer clean clean-image
