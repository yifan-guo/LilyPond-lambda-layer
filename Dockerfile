FROM public.ecr.aws/lambda/python:3.11

# Install dependencies
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
    libnss-unknown

# Install LilyPond (Make sure you get the correct version)
RUN wget https://gitlab.com/lilypond/lilypond/-/releases/v2.23.9/downloads/lilypond-2.23.9-linux-x86_64.tar.gz && \
    tar -xzf lilypond-2.23.9-linux-x86_64.tar.gz && \
    mv lilypond-2.23.9 /opt/lilypond && \
    rm lilypond-2.23.9-linux-x86_64.tar.gz

# Set environment variables
ENV HOME="/home/nobody"
ENV FONTCONFIG_CACHE="/tmp/fontconfig"
ENV FONTCONFIG_PATH="/tmp/fontconfig"

# Create directories with proper permissions
RUN mkdir -p $HOME && \
    mkdir -p $FONTCONFIG_CACHE && \
    chmod 777 $HOME && \
    chmod 777 $FONTCONFIG_CACHE && \
    chmod 777 /tmp

# Install awslambdaric for Lambda Runtime Interface Client
RUN pip3 install awslambdaric --target /opt/python

# Set PYTHONPATH
ENV PYTHONPATH="/opt/python:${PYTHONPATH}"

# Copy the Lambda handler function
COPY app.py /var/task/app.py

# Set the working directory
WORKDIR /var/task

# Switch to the nobody user for running the application
USER nobody

# Command to start the Lambda runtime
CMD ["app.lambda_handler"]
