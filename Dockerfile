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
    pango-devel \
    zip  # Install the zip utility

# Download and install LilyPond
RUN wget https://gitlab.com/lilypond/lilypond/-/releases/v2.24.4/downloads/lilypond-2.24.4-linux-x86_64.tar.gz && \
    tar -xzf lilypond-2.24.4-linux-x86_64.tar.gz && \
    mv lilypond-2.24.4 /opt/lilypond && \
    rm lilypond-2.24.4-linux-x86_64.tar.gz

# Set up directory structure for Lambda Layer
RUN mkdir -p /opt && \
    cp -r /opt/lilypond/* /opt/ && \
    rm -rf /opt/lilypond  # Cleanup

# Create a ZIP package of the layer
RUN cd /opt && zip -r /opt/lilypond_layer.zip .

# Set the final working directory
WORKDIR /opt

# Command to keep the container running (optional)
CMD ["ls", "-l"]
