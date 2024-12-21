FROM ruby:3.3.6-slim-bookworm AS base

WORKDIR /app

# 非インタラクティブモードにする (入力待ちでブロックしなくなる)
ARG DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/lib/apt,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    tzdata \
    build-essential \
    git

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - &&\
    apt-get update && \
    apt-get install -y \
    nodejs

# Setup User
ARG USER_UID=10001
ARG USER_GID=10001
ARG USER_NAME=user
ARG GROUP_NAME=user

RUN groupadd -g $USER_GID $GROUP_NAME && \
    useradd -m -u $USER_UID -g $USER_GID -s /bin/bash $USER_NAME

RUN chown $USER_UID:$USER_GID /app

USER $USER_NAME

# ----------------------------------------------------------------
FROM base AS dependencies

COPY --chown=$USER_NAME:$GROUP_NAME Gemfile Gemfile.lock ./
RUN bundle config set without "development test" && \
    bundle install --jobs=3 --retry=3

# ----------------------------------------------------------------
# develepment environement
# ----------------------------------------------------------------
FROM dependencies AS development

# COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/

RUN bundle install --jobs=3 --retry=3

COPY --chown=$USER_NAME:$GROUP_NAME package.json package-lock.json ./
RUN npm install

CMD ["/bin/bash"]

# ----------------------------------------------------------------
# production environement
# ----------------------------------------------------------------
FROM dependencies AS production

# COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/

COPY --chown=$USER_NAME:$GROUP_NAME . ./
RUN npm install --omit=dev

CMD ["bundle", "exec", "rackup"]
