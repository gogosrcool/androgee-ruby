FROM ruby:2.4
RUN apt-get update && apt-get install -y fortune cowsay
WORKDIR /opt/
ADD . /opt/
RUN bundle install

ENV PATH $PATH:/usr/games
ENV RBBY _DISCORDTOKEN_
ENV RUST_IP _RUSTIP_
ENV RUST_PASSWORD _RUSTPASSWORD_
ENV EGEEIO_SERVER 183740337976508416
CMD ["ruby", "main.rb"]
