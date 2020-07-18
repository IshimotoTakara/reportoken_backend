FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /reportoken_backend
WORKDIR /reportoken_backend
COPY Gemfile /reportoken_backend/Gemfile
COPY Gemfile.lock /reportoken_backend/Gemfile.lock
RUN bundle install
COPY . /reportoken_backend

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]