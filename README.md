# Monitoring project

Simple monitoring environment for Docker eco-system.

### Tooling:

* [Prometheus](https://github.com/prometheus/prometheus) - TSDB-based for storage and collect metrics (using **v2.15.2**)
* [cAdvisor](https://github.com/google/cadvisor) - scraping metrics from Dockerd (using **v0.31.0**)
* [Node-Exporter](https://github.com/prometheus/node_exporter) - scraping metrics from Host machine (using **latest binary**)
* [PostgreSQL-Exporter](https://github.com/wrouesnel/postgres_exporter) - scraping metrics/stats from PostgreSQL (using **v0.8.0**)
* [Mongodb-Exporter](https://hub.docker.com/r/eses/mongodb_exporter) - scraping metrics/stats from MongoDB (using **latest**)
* [Grafana](https://github.com/grafana/grafana) - main visualizator for Prometheus (using **6.6.0**)
* [Alertmanager](https://github.com/prometheus/alertmanager) - routing alerts from prometheus to receiver (**Rocket.Chat** with webhook)
