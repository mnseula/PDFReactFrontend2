FROM debian:stable-slim AS build-env

# Install required dependencies
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

# Create Flutter project
WORKDIR /home/flutter/app
RUN flutter create pdf_viewer

# Copy your project files
WORKDIR /home/flutter/app/pdf_viewer
COPY --chown=flutter:flutter . .

# Clear flutter cache
RUN flutter clean

# Get dependencies and build
RUN flutter pub get

# Enable web platform and build
RUN flutter build web --release

# Production stage
FROM nginx:stable-alpine
COPY --from=build-env /home/flutter/app/pdf_viewer/build/web /usr/share/nginx/html
EXPOSE 80
