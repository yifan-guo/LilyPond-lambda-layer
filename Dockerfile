# Start with the Amazon Linux 2 base image for Lambda
FROM public.ecr.aws/lambda/provided:al2

# Install necessary dependencies, including Guile and Python
RUN yum install -y \
    gcc-c++ \
    git \
    make \
    automake \
    autoconf \
    wget \
    texinfo \
    libtool \
    libX11-devel \
    libXext-devel \
    freetype-devel \
    bison \
    flex \
    cairo-devel \
    pango-devel \
    guile \
    python3 \
    python3-pip \
    zip \
    && yum clean all

# Download and install LilyPond
RUN wget https://gitlab.com/lilypond/lilypond/-/releases/v2.24.4/downloads/lilypond-2.24.4-linux-x86_64.tar.gz \
    && tar -xzf lilypond-2.24.4-linux-x86_64.tar.gz \
    && mv lilypond-2.24.4 /opt/lilypond \
    && rm lilypond-2.24.4-linux-x86_64.tar.gz

# Set up directory structure for Lambda Layer
RUN mkdir -p /opt/lambda/layer/bin && \
    cp -r /opt/lilypond/bin/* /opt/lambda/layer/bin/

# Install awslambdaric for Lambda Runtime Interface Client
RUN pip3 install awslambdaric --target /opt/python

# Set environment variables
ENV PYTHONPATH="/opt/python:${PYTHONPATH}"
ENV PATH="/opt/lambda/layer/bin:${PATH}"

# Copy the Lambda handler function
COPY app.py /var/task/app.py

# Set the working directory
WORKDIR /var/task

# Command to start the Lambda runtime
CMD ["python3", "-m", "awslambdaric", "app.lambda_handler"]
