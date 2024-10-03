FROM amazonlinux:2

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
    fontconfig-devel \
    bison \
    flex \
    cairo-devel \
    pango-devel

# Download and install LilyPond
RUN wget https://gitlab.com/lilypond/lilypond/-/releases/v2.24.4/downloads/lilypond-2.24.4-linux-x86_64.tar.gz && \
    tar -xzf lilypond-2.24.4-linux-x86_64.tar.gz && \
    mv lilypond-2.24.4 /opt/lilypond && \
    rm lilypond-2.24.4-linux-x86_64.tar.gz

# Set up directory structure for Lambda Layer
RUN mkdir -p /opt/lambda/layer && \
    cp -r /opt/lilypond/* /opt/lambda/layer/

# Set the working directory
WORKDIR /opt/lambda/layer

# Command to keep the container running (optional)
CMD ["ls", "-l"]
