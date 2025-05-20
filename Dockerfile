FROM debian:stable-slim AS build-env

# 1. Install dependencies with certificate support
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl git unzip xz-utils ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates

# 2. Create non-root user
RUN useradd -m flutter
USER flutter
WORKDIR /home/flutter/app

# 3. Install Flutter (specific stable version)
RUN git clone https://github.com/flutter/flutter.git -b stable /home/flutter/flutter
ENV PATH="/home/flutter/flutter/bin:${PATH}"

# 4. Verify Flutter installation
RUN flutter --version

# 5. Copy project files
COPY --chown=flutter . .

# 6. Build (removed --web-renderer flag)
RUN flutter pub get && \
    flutter build web --release

# Production stage
FROM nginx:stable-alpine
COPY --from=build-env /home/flutter/app/build/web /usr/share/nginx/html
EXPOSE 9191
