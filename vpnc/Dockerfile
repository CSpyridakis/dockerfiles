FROM ubuntu:22.04

# Install applications
RUN apt-get update && apt-get install -y vpnc openssh-client openssh-server ufw

# Copy VPNC configuration
COPY *.conf /etc/vpnc/

# Copy scripts to the home dir
COPY ./scripts/* /home/scripts/
COPY ./ssh/* /home/ssh/

# Working directory
WORKDIR /home

ENTRYPOINT ["sh", "-c", "/home/scripts/startup.sh && /home/scripts/vpn_up && /home/scripts/vpnc_down"]