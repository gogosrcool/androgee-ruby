FROM ruby:2.5
RUN apt-get update && apt-get install -y fortune cowsay
WORKDIR /opt/
COPY . /opt/
RUN bundle install

CMD ["rake", "run"]
