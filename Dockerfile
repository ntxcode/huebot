FROM trenpixster/elixir

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app

RUN mix deps.get
RUN mix compile

RUN chmod +x start.sh

CMD ["./start.sh"]
