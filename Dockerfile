FROM rclone/rclone
WORKDIR /usr/local/app/

EXPOSE ${PORT}

# Clone a git repo to cwd
ARG REPO_URL
ENV REPO=$REPO_URL
RUN apk add --no-cache git
RUN git clone $REPO .

COPY rclone.conf /usr/local/app/

# Set up a separate user so the container doesn't run as root
RUN addgroup -S rcwds && adduser -S rcwds -G rcwds -D -H
USER rcwds

# Serve cwd over WebDAV with rclone
CMD [ \
    "serve", "webdav", \
    "--config", "rclone.conf", \
    "myremote:", \
    "--read-only", \
    "--user", "$USER", \
    "--pass", "$PASS", \
    "--addr", "0.0.0.0:${PORT}" \
]
