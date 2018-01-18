FROM ruby:2.4
RUN apt-get update && apt-get install -y fortune cowsay

ARG egeeio_server
ARG rust_ip
ARG rust_port
ARG rust_password
ARG minecraft_ip
ARG minecraft_port
ARG minecraft_password

ENV PATH $PATH:/usr/games
ENV EGEEIO_SERVER=${egeeio_server}}
ENV RUST_IP=${rust_ip}
ENV RUST_PORT=${rust_port}
ENV RUST_PASSWORD=${rust_password}
ENV MINECRAFT_IP=${minecraft_ip}
ENV MINECRAFT_PORT=${minecraft_port}
ENV MINECRAFT_PASSWORD=${minecraft_password}

WORKDIR /opt/
COPY . /opt/
RUN bundle install
RUN chmod +x run.sh

CMD ["/opt/run.sh"]
