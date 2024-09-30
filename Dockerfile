FROM amazonlinux:2

# Install dependencies
RUN yum install -y epel-release && \
    yum install -y \
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
    flex

# Download and install LilyPond
RUN wget https://lilypond.org/download/binaries/linux/lilypond-2.24.2-1.linux-x86_64.sh && \
    chmod +x lilypond-2.24.2-1.linux-x86_64.sh && \
    ./lilypond-2.24.2-1.linux-x86_64.sh --prefix=/opt/lilypond --disable-documentation

# Clean up
RUN rm lilypond-2.24.2-1.linux-x86_64.sh

# Set up directory structure for Lambda Layer
RUN mkdir -p /opt/lambda/layer/bin && \
    cp -r /opt/lilypond/bin/* /opt/lambda/layer/bin/

WORKDIR /opt/lambda/layer
CMD ["cp", "-r", "bin", "/opt/"]
