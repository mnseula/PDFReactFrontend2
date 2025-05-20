FROM debian:stable-slim AS build-env

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl git unzip xz-utils ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates

# Create flutter user
RUN useradd -ms /bin/bash flutter
USER flutter
WORKDIR /home/flutter

# Clone Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable
ENV PATH="/home/flutter/flutter/bin:${PATH}"

# Configure Flutter for web
RUN flutter config --enable-web
RUN flutter precache --web

# Copy project files
WORKDIR /home/flutter/app
COPY --chown=flutter:flutter . .

# Get dependencies and build
RUN flutter pub get
RUN flutter build web --release

# Production stage
FROM nginx:stable-alpine
COPY --from=build-env /home/flutter/app/build/web /usr/share/nginx/html
EXPOSE 9091
