from alpine:latest

RUN apk add --no-cache ansible sshpass openssh-client

# Configure SSH client to skip host key checking for Docker containers
RUN mkdir -p /root/.ssh && \
    echo "Host *" > /root/.ssh/config && \
    echo "    StrictHostKeyChecking no" >> /root/.ssh/config && \
    echo "    UserKnownHostsFile /dev/null" >> /root/.ssh/config && \
    chmod 600 /root/.ssh/config

CMD ["tail","-f","/dev/null"]