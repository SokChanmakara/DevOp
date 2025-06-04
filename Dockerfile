from alpine:latest

RUN apk add --no-cache ansible sshpass

CMD ["tail","-f","/dev/null"]