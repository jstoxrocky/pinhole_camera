FROM ruby:2.5
RUN apt-get update && apt-get install -qq -y build-essential nodejs
ENV INSTALL_PATH /pinhole
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY Gemfile* $INSTALL_PATH/
RUN bundle install
COPY . .
CMD ["bin/rails", "db:migrate", "RAILS_ENV=development"]
ENTRYPOINT ["rails", "server", "-b", "0.0.0.0", "-p", "5000"]