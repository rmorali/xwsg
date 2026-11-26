FROM ruby:3.4.9-slim

# Instala dependências de sistema essenciais para compilação, SQLite3, Git e Node/JS
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    libsqlite3-dev \
    libyaml-dev \
    pkg-config \
    nodejs \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /rails

# Atualiza o Bundler e copia os arquivos de dependências primeiro (aproveita o cache do Docker)
COPY Gemfile Gemfile.lock* ./
RUN gem install bundler && bundle install

# Copia o restante do código da aplicação
COPY . .

# Garante que o diretório do banco SQLite exista
RUN mkdir -p storage db tmp/pids

EXPOSE 3000

# Remove PIDs antigos do Puma caso o container tenha sido encerrado bruscamente e inicia o servidor
CMD ["bash", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0"]

