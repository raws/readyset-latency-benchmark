require 'benchmark'
require 'bundler/inline'

gemfile do
  ruby '3.1.2'
  source 'https://rubygems.org'
  gem 'pg', '~> 1.3.5'
end

unless %w(DIRECT_CONNECTION_STRING READYSET_CONNECTION_STRING).all? { |key| ENV.key?(key) }
  $stderr.puts 'error: must set DIRECT_CONNECTION_STRING and READYSET_CONNECTION_STRING'
  exit 1
end

DIRECT_CONNECTION_STRING = ENV.fetch('DIRECT_CONNECTION_STRING')
READYSET_CONNECTION_STRING = ENV.fetch('READYSET_CONNECTION_STRING')

direct_connection = PG.connect(DIRECT_CONNECTION_STRING)
readyset_connection = PG.connect(READYSET_CONNECTION_STRING)

direct_connection.exec(<<~SQL)
  DROP TABLE IF EXISTS books;
  CREATE TABLE books (
    id bigserial PRIMARY KEY,
    author text NOT NULL,
    title text NOT NULL,
    price_cents int NOT NULL CHECK (price_cents > 0)
  );

  INSERT INTO books (author, title, price_cents) VALUES ('Agatha Christie', 'And Then There Were None', 899);
  INSERT INTO books (author, title, price_cents) VALUES ('F. Scott Fitzgerald', 'The Great Gatsby', 1529);
  INSERT INTO books (author, title, price_cents) VALUES ('Charlotte Perkins Gilman', 'The Yellow Wall-Paper', 685);
SQL

SELECT_ALL_BOOKS = 'SELECT * FROM books ORDER BY author ASC, title ASC;'
BENCHMARK_OUTPUT_LABEL_WIDTH = 10

Benchmark.bm(BENCHMARK_OUTPUT_LABEL_WIDTH) do |benchmark|
  benchmark.report('direct:') { direct_connection.exec(SELECT_ALL_BOOKS) }
  benchmark.report('readyset:') { readyset_connection.exec(SELECT_ALL_BOOKS) }
end
