# Stage 1: Build the Flutter web app
FROM debian:stable-slim AS build-env

# Install required tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /usr/local/flutter
ENV PATH="$PATH:/usr/local/flutter/bin"

# Set up the app
WORKDIR /app
COPY . .

# Get Flutter dependencies
RUN flutter pub get

# Build the Flutter web app
RUN flutter build web --release --web-renderer html

# Stage 2: Set up the production environment
FROM nginx:stable-alpine

# Copy the built app from the previous stage
COPY --from=build-env /app/build/web /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 9191

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
