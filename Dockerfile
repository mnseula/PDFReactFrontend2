FROM debian:stable-slim AS build-env

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl git unzip xz-utils ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    update-ca-certificates

RUN useradd -m flutter
USER flutter
WORKDIR /home/flutter/app

RUN git clone https://github.com/flutter/flutter.git -b stable /home/flutter/flutter
ENV PATH="/home/flutter/flutter/bin:${PATH}"

RUN flutter config --enable-web && flutter precache --web

COPY --chown=flutter . .

RUN if [ ! -d "web" ]; then \
      flutter create --platforms web .; \
    fi

RUN flutter pub get && flutter build web --release

FROM nginx:stable-alpine
COPY --from=build-env /home/flutter/app/build/web /usr/share/nginx/html
EXPOSE 9091
