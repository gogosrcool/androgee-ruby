FROM ruby:2.2
ENV PATH $PATH:/usr/games
ENV RBBY 
WORKDIR /opt/
ADD . /opt/
RUN apt-get update && apt-get install -y fortune cowsay
RUN bundle install
CMD ["ruby", "main.rb"]