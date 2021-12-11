FROM ruby:3.0.3



WORKDIR /opt/todos/

COPY . .
# RUN gem install bundler:2.1.4

RUN bundle config --global frozen 1 && \
    bundle config set deployment 'true' && \
    bundle install
# Persistent volumes
EXPOSE 4567

CMD ["bundle", "exec", "ruby", "server.rb"]

