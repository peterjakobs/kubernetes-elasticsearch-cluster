FROM        quay.io/prometheus/busybox:latest
MAINTAINER  The Prometheus Authors <prometheus-developers@googlegroups.com>

# Build from https://github.com/justwatchcom/elasticsearch_exporter
ADD elasticsearch_exporter  /bin/elasticsearch_exporter

EXPOSE      9108
ENTRYPOINT  [ "/bin/elasticsearch_exporter" ]

