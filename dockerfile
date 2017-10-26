FROM ruby:2.4
ENV PATH $PATH:/usr/games
ENV RBBY #TODO SED this
WORKDIR /opt/
ADD . /opt/
RUN apt-get update && apt-get install -y fortune cowsay
RUN bundle install
CMD ["ruby", "main.rb"]