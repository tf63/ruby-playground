FROM ruby:3.1.5-alpine3.19 AS base

WORKDIR /app

RUN apk add --update --no-cache \
    tzdata \
    nodejs \
    yarn \
    build-base

# Setup User -----------------------------------------------------
ARG USER_UID
ARG USER_NAME=user

RUN adduser -D -u $USER_UID $USER_NAME

USER $USER_NAME
# ----------------------------------------------------------------
FROM base AS dependencies

COPY Gemfile Gemfile.lock ./
RUN bundle config set without "development test" && \
    bundle install --jobs=3 --retry=3

COPY package.json yarn.lock ./
RUN yarn
# ----------------------------------------------------------------
FROM dependencies AS development

COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/
COPY --from=dependencies ./node_modules/ node_modules/

CMD ["/bin/sh"]

# ----------------------------------------------------------------
FROM dependencies AS production

COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/
COPY --from=dependencies ./node_modules/ node_modules/

COPY --chown=$USER_NAME:$GROUP_NAME . ./

CMD ["bundle", "exec", "rackup"]
