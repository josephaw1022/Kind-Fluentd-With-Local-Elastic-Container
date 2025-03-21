

# ElasticSearch, Kibana, Kind, and Fluentd



## Overview

There is a simple make file to build a local ElasticSearch, Kibana, and Fluentd stack using Kind (Kubernetes in Docker).


simply run 
```bash
make
```

to see the options available.


to create a local cluster with ElasticSearch, Kibana, and Fluentd, run:

```bash
make kind-create
```

to start up ElasticSearch and Kibana, run:

```bash
make elastic-kibana-local-start
```

to start up fluentd and some other resources to the cluster, run:

```bash
make resources-create
```

to delete the cluster, run:

```bash
make kind-delete
```



once in kibana and have the logs ingested, you can run queries along the line of something like this to see the logs:

```ESQL
FROM logs*
| WHERE kubernetes.namespace_name != "kube-system"
| KEEP kubernetes.container_image, message, kubernetes.namespace_name, @timestamp
```


