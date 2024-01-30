FROM alpine:latest

RUN apk add --no-cache \
    ffmpeg \
    curl \
    gnupg \
    ca-certificates \
    less \
    ncurses-terminfo-base \
    krb5-libs \
    libgcc \
    libintl \
    libstdc++ \
    tzdata \
    userspace-rcu \
    zlib \
    icu-libs 

#RUN sudo apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
#    lttng-ust

RUN apk add lttng-ust-dev

# Download the powershell '.tar.gz' archive
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.4.1/powershell-7.4.1-linux-x64.tar.gz -o /tmp/powershell.tar.gz

# Create the target folder where powershell will be placed
RUN mkdir -p /opt/microsoft/powershell/7

# Expand powershell to the target folder
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7

# Set execute permissions
RUN chmod +x /opt/microsoft/powershell/7/pwsh

# Create the symbolic link that points to pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

COPY transcode.ps1 /transcoder/transcode.ps1

ENV PATH=/usr/bin:$PATH

ENTRYPOINT ["pwsh", "/transcoder/transcode.ps1"]



