FROM bitwalker/alpine-elixir

WORKDIR /app

COPY mix.exs .
COPY mix.lock .

CMD mix deps.get && mix machine start