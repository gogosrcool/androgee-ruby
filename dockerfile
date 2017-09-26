FROM ruby:2.2
ENV RBBY __discord_token__
WORKDIR /opt/
ADD . /opt/
RUN bundle install
CMD ["ruby", "main.rb"]