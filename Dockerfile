# Use multi-stage build to avoid root issues
FROM debian:stable-slim AS build-env

# Install dependencies (non-root)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl git unzip xz-utils && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m flutter
USER flutter
WORKDIR /home/flutter/app

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable /home/flutter/flutter
ENV PATH="/home/flutter/flutter/bin:${PATH}"

# Copy project files (preserve permissions)
COPY --chown=flutter . .

# Build
RUN flutter pub get && \
    flutter build web --release --web-renderer html

# Production stage
FROM nginx:stable-alpine
COPY --from=build-env /home/flutter/app/build/web /usr/share/nginx/html
EXPOSE 9191
