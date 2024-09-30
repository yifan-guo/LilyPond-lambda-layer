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
    chmod +x lilypond-2.24.2-1.linux-x86_64.sh && \
    ./lilypond-2.24.2-1.linux-x86_64.sh --prefix=/opt/lilypond --disable-documentation

# Clean up
RUN rm lilypond-2.24.2-1.linux-x86_64.sh

# Set up directory structure for Lambda Layer
RUN mkdir -p /opt/lambda/layer/bin && \
    cp -r /opt/lilypond/bin/* /opt/lambda/layer/bin/

WORKDIR /opt/lambda/layer
CMD ["cp", "-r", "bin", "/opt/"]
