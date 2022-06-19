# ReadySet Latency Benchmark

A quick benchmark to measure the latency that [ReadySet](https://readyset.io) adds compared to querying a PostgreSQL database directly.

## Usage

To run the benchmark, you'll need:

* Ruby 3.1.2
* PostgreSQL 14
* [ReadySet](https://github.com/readysettech/readyset)

First, create a PostgreSQL database and [connect ReadySet to it](https://github.com/readysettech/readyset#getting-started). Then, tell `readyset-latency-benchmark.rb` how to connect to your database and to ReadySet by setting the `DIRECT_CONNECTION_STRING` and `READYSET_CONNECTION_STRING` environment variables.

```shell
createdb readyset
DIRECT_CONNECTION_STRING=postgres://localhost:5432/readyset \
  READYSET_CONNECTION_STRING=postgres://localhost:5433/readyset \
  ruby readyset-latency-benchmark.rb

#                  user     system      total        real
# direct:      0.000015   0.000015   0.000030 (  0.001542)
# readyset:    0.000022   0.000040   0.000062 (  0.004862)
```

## License

MIT
