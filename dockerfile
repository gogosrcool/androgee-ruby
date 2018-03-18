FROM ruby:2.4
RUN apt-get update && apt-get install -y fortune cowsay

ENV PATH $PATH:/usr/games

WORKDIR /opt/
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . /opt/

ENTRYPOINT ["rake"]
