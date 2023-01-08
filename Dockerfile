FROM rust:latest as rust

RUN apt update && \
    apt install -y curl build-essential && \
    apt-get clean && \
    rm -fr /var/lib/apt/lists/* && \
    curl https://get.wasmer.io -sSfL | sh && \
    rustup update && \
    cargo install wasm-pack && \
    cargo new --lib /app

COPY ./src/rust/* /app/

WORKDIR /app

RUN wasm-pack build --target web


FROM nginx:latest

COPY ./src/www /usr/share/nginx/html
RUN mkdir /usr/share/nginx/html/wasm
COPY --from=rust /app/pkg/hello_wasm_bg.wasm /usr/share/nginx/html/wasm/
COPY --from=rust /app/pkg/hello_wasm.js /usr/share/nginx/html/wasm/
