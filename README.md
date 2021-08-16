# Isilon Data Insights Connector

The isi_data_insights_d.py script controls a daemon process that can be used to query multiple OneFS clusters for statistics data via the Isilon OneFS Platform API (PAPI). The collector uses a pluggable module for processing the results of those queries. 

This project has include new features of the base project
- has merged [code](https://github.com/Isilon/isilon_data_insights_connector/pull/108) that add Prometheus metrics
- uses docker and docker-compose
- devides configuration and executing files



## Build a Docker image

```
docker build -t isi_data_insights ./app
```

## Configure before run

Copy existing [`example_isi_data_insights_d.cfg`](config/example_isi_data_insights_d.cfg) to a new file with name `isi_data_insights_d.cfg`.

Edit a section `isi_data_insights_d.clusters`. Add cluster nodes:
```
[isi_data_insights_d]
...
clusters:
  some_user:some_strong_password@some_ip_or_hostname:False
```
where `some_user`, `some_strong_password`, `some_ip_or_hostname` should be changed.

## Run with docker-compose

```
docker-compose up --build
```

## View collected metrics

Open in browser or through curl this URL - [http://localhost:8080/metrics](http://localhost:8080/metrics)

You will see like these Prometheus metrics output
```
# HELP python_gc_objects_collected_total Objects collected during gc
# TYPE python_gc_objects_collected_total counter
python_gc_objects_collected_total{generation="0"} 4777.0
python_gc_objects_collected_total{generation="1"} 280.0
python_gc_objects_collected_total{generation="2"} 0.0
# HELP python_gc_objects_uncollectable_total Uncollectable object found during GC
# TYPE python_gc_objects_uncollectable_total counter
python_gc_objects_uncollectable_total{generation="0"} 0.0
python_gc_objects_uncollectable_total{generation="1"} 0.0
python_gc_objects_uncollectable_total{generation="2"} 0.0
# HELP python_gc_collections_total Number of times this generation was collected
# TYPE python_gc_collections_total counter
python_gc_collections_total{generation="0"} 230.0
python_gc_collections_total{generation="1"} 20.0
python_gc_collections_total{generation="2"} 1.0
# HELP python_info Python platform information
# TYPE python_info gauge
python_info{implementation="CPython",major="3",minor="9",patchlevel="6",version="3.9.6"} 1.0
# HELP process_virtual_memory_bytes Virtual memory size in bytes.
# TYPE process_virtual_memory_bytes gauge
```



## Grafana Setup

* Import the Grafana dashboards.
  * grafana_cluster_list_dashboard.json
![Multi-cluster Summary Dashboard Screen Shot](https://raw.githubusercontent.com/Isilon/isilon_data_insights_connector/master/IsilonDataInsightsMultiClusterSummary.JPG)
  * grafana_cluster_capacity_utilization_dashboard.json
 ![Cluster Capacity Utilization Dashboard Screen Shot](https://raw.githubusercontent.com/Isilon/isilon_data_insights_connector/master/IsilonDataInsightsClusterCapacityUtilizationTable.JPG)
  * grafana_cluster_detail_dashboard.json
 ![Cluster Detail Dashboard Screen Shot](https://raw.githubusercontent.com/Isilon/isilon_data_insights_connector/master/IsilonDataInsightsClusterDetail.JPG)
  * grafana_cluster_protocol_dashboard.json
![Cluster Protocol Detail Dashboard Screen Shot](https://raw.githubusercontent.com/Isilon/isilon_data_insights_connector/master/IsilonDataInsightsClusterProtocolDetail.JPG)


## Customizing the Connector

The Connector is designed to allow for customization via a plugin architecture. The default plugin, influxd_plugin.py, is configured via the provided example configuration file. If you would like to process the stats data differently or send them to a different backend than the influxdb_plugin.py you can implement a custom stats processor. Here are the instructions for doing so:

* Create a file called my_plugin.py, or whatever you want to name it.
* In the my_plugin.py file define a process(cluster, stats) function that takes as input the name/ip-address of a cluster and a list of stats. The list of stats will contain instances of the isi_sdk_8_0/models/CurrentStatisticsStat class or isi_sdk_7_2/models/CurrenStatisticsStat class, but it makes no difference because the two classes are the same regardless of the version.
* Optionally define a start(argv) function that takes a list of input args as defined in the config file via the stats_processor_args parameter.
* Optionally define a stop() function.
* Put the my_plugin.py file somewhere in your PYTHONPATH (easiest is to put into the same directory as the other Python source code files).
* Update the isi_data_insights_d.cfg file with the name of your plugin (i.e. 'my_plugin')
* Restart the isi_data_insights_d.py daemon:

```sh
./isi_data_insights_d.py restart
```

## Extending and/or Contributing to the Connector

There are multiple ways for anyone using the Connector to interact with our dev team to request new features or discuss problems.

* Create a new issue on the [Issues](https://github.com/Isilon/isilon_data_insights_connector/issues) tab.
* Use the [discussion](https://community.emc.com/docs/DOC-48273) capability of the Isilon SDK Info Hub page.

Also, just like an other project on github.com we are entirely open to external code contributions:

* Fork the project, modify it, then initiate a pull request.
