FROM alpine:edge
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
  && apk --no-cache add alpine-sdk coreutils sudo \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/ash -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && mkdir /packages \
  && chown builder:abuild /packages \
  && mkdir -p /var/cache/apk \
  && ln -s /var/cache/apk /etc/apk/cache
COPY /abuilder /bin/
COPY --chown=builder:root ./cjorge@ubiwhere.com-62862ce3.rsa /home/builder/ssh.rsa
RUN chmod 0444 /home/builder/ssh.rsa

ENV RSA_PRIVATE_KEY_NAME ssh.rsa
ENV PACKAGER_PRIVKEY /home/builder/${RSA_PRIVATE_KEY_NAME}
ENV REPODEST /packages
ENV PACKAGER "C.Jorge <cjorge@ubiwhere.com>" 
USER builder

ENTRYPOINT ["abuilder", "-r"]
WORKDIR /home/builder/package
VOLUME ["/home/builder/package"]
