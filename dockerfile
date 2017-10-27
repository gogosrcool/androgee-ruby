FROM ruby:2.4
RUN apt-get update && apt-get install -y fortune cowsay
ENV PATH $PATH:/usr/games
ENV RBBY _DISCORDTOKEN_
ENV RUST_IP _RUSTIP_
ENV RUST_PASSWORD _RUSTPASSWORD_
WORKDIR /opt/
ADD . /opt/
RUN bundle install
CMD ["ruby", "main.rb"]