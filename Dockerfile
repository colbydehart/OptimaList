FROM elixir:1.4
RUN mix local.hex --force
WORKDIR /app
COPY mix.exs /app/
COPY mix.lock /app/
RUN mix deps.get
COPY . /app/
CMD ["mix", "phoenix.server"]
