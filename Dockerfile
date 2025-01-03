FROM ruby:3.0.1-buster

WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_8.x | sh - \
  && apt-get update -y && apt-get install -y npm

RUN npm install --global yarn

COPY Gemfile* ./
RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

RUN rails webpacker:install

CMD ["rails", "db:setup"]
