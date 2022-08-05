FROM debian:latest

RUN apt update && apt install -y ffmpeg curl gnupg apt-transport-https

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Register the Microsoft Product feed
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list'

# Install PowerShell
RUN apt update && apt install -y powershell

COPY transcode.ps1 /transcoder/transcode.ps1

ENV PATH=/usr/bin:$PATH

ENTRYPOINT ["pwsh", "/transcoder/transcode.ps1"]



