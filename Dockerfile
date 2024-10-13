FROM public.ecr.aws/lambda/python:3.11

# Install dependencies directly
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
    pango-devel

# Install LilyPond (Make sure you get the correct version)
RUN wget https://gitlab.com/lilypond/lilypond/-/releases/v2.24.4/downloads/lilypond-2.24.4-linux-x86_64.tar.gz && \
    tar -xzf lilypond-2.24.4-linux-x86_64.tar.gz && \
    mv lilypond-2.24.4 /opt/lilypond && \
    rm lilypond-2.24.4-linux-x86_64.tar.gz

# Install awslambdaric for Lambda Runtime Interface Client
RUN pip3 install awslambdaric --target /opt/python

# Set PYTHONPATH
ENV PYTHONPATH="/opt/python:${PYTHONPATH}"

# Copy the Lambda handler function
COPY app.py /var/task/app.py

# Set the working directory
WORKDIR /var/task

# Command to start the Lambda runtime
CMD ["python3", "-m", "awslambdaric", "app.lambda_handler"]
