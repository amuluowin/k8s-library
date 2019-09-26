FROM timberiodev/vector-builder-x86_64-unknown-linux-musl AS builder

RUN apt-get install -y git && git clone https://github.com/amuluowin/vector && cd vector

WORKDIR /vector

# We must do this so we can force the rustc version provided by
# the container.
RUN mv rust-toolchain rust-toolchain.bak
RUN cargo build --release --target x86_64-unknown-linux-musl

RUN mkdir -p /release/bin
RUN mkdir -p /release/etc/vector
RUN cp -a target/x86_64-unknown-linux-musl/release/vector /release/bin/
RUN cp -a config/. /release/etc/vector/

FROM alpine

#RUN apk --no-cache add libgcc libstdc++

COPY --from=builder /release/bin/* /usr/local/bin/
COPY --from=builder /release/etc/vector /etc

ENTRYPOINT ["/usr/local/bin/vector"]
