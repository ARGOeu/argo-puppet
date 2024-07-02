# ARGO Puppet module

## Description

This repository contains a Puppet module used for installation and configuration of ARGO monitoring instances.

## Start using this module

Add this module and modules it depends on to your Puppetfile:

```
forge 'http://forge.puppetlabs.com'

# Forge | Puppet modules
mod 'puppet-cron', '2.0.0'
mod 'richardc-datacat', '0.6.2'
mod 'sensu-sensu', '5.8.0'

# GitHub Lutak Srce modules
mod 'umd',
  :git => 'https://github.com/lutak-srce/umd'
mod 'yum',
  :git => 'https://github.com/lutak-srce/yum'
mod 'gridcert',
  :git => 'https://github.com/lutak-srce/gridcert'

# ARGO module
mod 'argo',
  :git => 'https://github.com/ARGOeu/argo-puppet'
```

## Usage - configurations

The module can be used for configuration of monitoring box using Nagios and Sensu.

### Nagios

When configuring Nagios service, you may optionally override `nagios.cfg` configuration file, CGI configuration file (`cgi.cfg`), and httpd configuration `nagios.conf`. If not overridden, the configurations defined in files stored in `files/mon/nagios` directory are used.

This will ensure that the Nagios configuration is set up properly to work with ARGO monitoring service, and ensure that both `nagios.service` and `httpd.service` are up-and-running.

### NCG

When configuring the monitoring box which is to be running Nagios service, one must also configure the [NCG](https://github.com/ARGOeu/argo-ncg) tool.

The required parameters that need to be defined in the data file are:

* `nagioshost` - hostname of the monitoring box,
* `nagiosadmin` - contact email to be used for notifications,
* `webapi_url` - WEB API URL,
* `webapi_token` - token to be used to fetch data from WEB API,
* `poem_url` - URL of tenant's POEM instance (without URL scheme and trailing `/`),
* `poem_token` - token to be used to fetch data from POEM,
* `profiles` - comma separated list of metric profiles to be used for monitoring.

Example:

```yaml
argo::mon::ncg::nagioshost  : nagios-box.example.com
argo::mon::ncg::nagiosadmin : email@example.com
argo::mon::ncg::webapi_url  : https://api.devel.argo.grnet.gr
argo::mon::ncg::webapi_token: api_token
argo::mon::ncg::profiles    : PROFILE1, PROFILE2
argo::mon::ncg::poem_url    : test.poem.devel.argo.grnet.gr
argo::mon::ncg::poem_token  : poem_token
argo::mon::ncg::localdb     : true
```

For each monitoring box the configuration file for ncg `ncg.conf` should be provided. By default it is fetched from the private directory `puppet:///private/ncg/ncg.conf`. This can be overridden by setting `conf_source` parameter.

Example override:

```yaml
argo::mon::ncg::conf_source: 'puppet:///private/ncg/ncg_override.conf'
```

If you wish to add local configuration files for NCG, you should set parameter `localdb` to `true`, and optionally provide source of the directory. If the source is not provided, the default one `puppet:///private/ncg/ncg-localdb.d` is going to be used.

Examples:

```yaml
argo::mon::ncg::localdb: true
```

The version of `argo-ncg` package can be overridden by setting the version in the parameter `version`, otherwise, the latest one is going to be installed. By default, this module will also configure the cronjob running `/usr/sbin/ncg.reload.sh` script once every two hours. If you do not want to run the cronjob, you should set the `cronjob` parameter to false.

Examples:

```yaml
argo::mon::ncg::version: 0.4.13
argo::mon::ncg::cronjob: false
```

### Sensu

If you wish to configure the monitoring box to use Sensu **instead of** Nagios, you should set parameter `sensu` to true. If this parameter is not set, the monitoring box will be configured to be used with Nagios.

Example:

```yaml
argo::mon::sensu: true
```

In order to configuration to work, you must set either `backend` or `agent` parameter to `true` (depending on whether you are setting up the Sensu backend instance or one of the agents). For the instances being set up as Sensu agents, [argo-poem-tools](https://github.com/ARGOeu/argo-poem-tools) tool is going to be configured. For the instances being set up as Sensu backend, there will be [AMS publisher](https://github.com/ARGOeu/ams-publisher) and [argo-scg](https://github.com/ARGOeu/argo-scg) configured. Therefore, the necessary parameters should be provided as well.

Example:

```yaml
argo::mon::sensu         : true
argo::mon::sensu::backend: true
argo::mon::sensu::agent  : true
```

For Sensu backend configuration, you must also provide list of all handled tenants, in order to configure corresponding namespaces and handlers.

Example:

```yaml
argo::mon::sensu::tenants: ['default', 'TENANT1', 'TENANT2']
```

Keep in mind that in this case you also need to do the necessary setup for [Sensu puppet module](https://forge.puppet.com/modules/sensu/sensu/readme).

### argo-scg

When configuring Sensu backend, the parameters for configuration of argo-scg should be provided as well:

* `topology` - directory containing topology files in .json format,
* `sensu_url` - URL of the Sensu API,
* `sensu_token` - token to be used for Sensu API,
* `webapi_url` - URL of the ARGO Web-API,
* `agents_config` - the directory containing custom agents' configuration,
* `tenant_sections` - object containing per-tenant information required for `argo-scg` configuration described [here](https://github.com/ARGOeu/argo-scg/tree/devel#configuration).

Example:

```yaml
argo::mon::scg::topology       : 'puppet:///private/scg/topology'
argo::mon::scg::sensu_url      : 'https://sensu-backend.example.com:8080'
argo::mon::scg::sensu_token    : 'sensu-token'
argo::mon::scg::webapi_url     : 'https://api.devel.argo.grnet.gr'
argo::mon::scg::agents_config  : 'puppet:///private/scg/agents_config'
argo::mon::scg::tenant_sections:
  default:
    poem_url       : https://default.poem.devel.argo.grnet.gr
    poem_token     : poem_token
    webapi_token   : webapi_token_default_tenant
    metricprofiles : ARGO_MON_INTERNAL
    topology       : /etc/argo-scg/topology.d/self_topology.json
    secrets        : "/etc/sensu/secret_envs"
    publish        : 'false'
  TENANT1:
    poem_url       : https://tenant1.poem.devel.argo.grnet.gr
    poem_token     : poem_token_tenant1
    webapi_token   : webapi_token_tenant1
    metricprofiles : MON, ARGO_MON_INTERNAL
    publish        : 'true'
    secrets        : "/etc/sensu/secret_envs"
    publisher_queue: '/var/spool/ams-publisher/tenant1_metrics/'
```

### AMS Publisher

AMS Publisher is automatically configured for Nagios monitoring boxes, and for Sensu backend instances. It is necessary to define two parameters:

* `nagioshost` - hostname of the monitoring box (both for Sensu and Nagios)
* `publisher_queues_topics` - object containing information for ams publisher configuration file, as described [here](https://github.com/ARGOeu/ams-publisher#queue-topic-pair-section) and used in the `templates/mon/amspublisher/ams-publisher.conf.erb` template.

For the Sensu backend instances it is also necessary to set `runasuser` parameter to `sensu`.

Example:

```yaml
argo::mon::amspublisher::nagioshost             : 'sensu-backend.example.com
argo::mon::amspublisher::runuser                : 'sensu'
argo::mon::amspublisher::publisher_queues_topics:
  MetricsTENANT1:
    Directory : '/var/spool/ams-publisher/tenant1_metrics/'
    Rate      : '10'
    Host      : 'messaging-devel.argo.grnet.gr'
    Key       : 'token'
    Project   : 'TENANT1'
    Topic     : 'metric_data'
    Bulksize  : '10'
    MsgType   : 'metric_data'
    Avro      : 'True'
    AvroSchema: '/etc/ams-publisher/metric_data.avsc'
    Retry     : '200'
    Timeout   : '60'
    SleepRetry: '300'
```

### argo-poem-tools

Monitoring boxes configured to be running Nagios and Sensu agents will also have configured [argo-poem-tools](https://github.com/ARGOeu/argo-poem-tools) tool. Therefore, one must provide the necessary parameters:

* `poem_url` - FQDN of tenant's POEM instance (**without** URL schema)
* `poem_token` - token to be used with tenant's POEM instance
* `profiles` - comma separated list of metric profiles to be used for monitoring.

Example:

```yaml
argo::mon::poemtools::poem_url  : default.poem.devel.argo.grnet.gr
argo::mon::poemtools::poem_token: poem_token
argo::mon::poemtools::profiles  : PROFILE1, PROFILE2
```

### argo-sensu-tools

If you intend to use passive metrics on a Sensu agent, you should configure [argo-sensu-tools](https://github.com/ARGOeu/argo-sensu-tools). First, you need to include the flag to include passive metrics.

```yaml
argo::mon::sensu::include_passive: true
```

Setting `include_passive` parameter to `true` triggers installation and configuration of `argo-sensu-tools`. The configuration parameters are explained [here](https://github.com/ARGOeu/argo-sensu-tools#configuration) You also need to provide the necessary parameters for the configuration:

```yaml
argo::mon::sensutools::voname        : tenant
argo::mon::sensutools::sensu_url     : https://sensu.argo.grnet.gr:8080/
argo::mon::sensutools::sensu_token   : <sensu-token>
argo::mon::sensutools::namespace     : tenant_namespace
argo::mon::sensutools::tenant        : TENANT
argo::mon::sensutools::webapi_url    : https://api.argo.grnet.gr/api/v2/metric_profiles
argo::mon::sensutools::webapi_token  : <webapi-token>
argo::mon::sensutools::metricprofiles: ARGO-MON, ARGO-MON-CRITICAL
```

### Setting up certificates

If you need to provide certificates for the monitoring box (hostcert or robotcert), you need to set the corresponding parameters to `true` and provide certificate and private key.

Example:

```yaml
argo::mon::gridcert : true
argo::mon::robotcert: true

gridcert::hostcert: 'puppet:///private/gridcert/hostcert.pem'
gridcert::hostkey : 'puppet:///private/gridcert/hostkey.pem'

argo::mon::robotcert::key : 'puppet:///private/robotcert/robotkey.pem'
argo::mon::robotcert::cert: 'puppet:///private/robotcert/robotcert.pem'
```

### Custom setup for certain probes

#### HTCondorCE probes

HTCondorCE probes need to have `condor` package installed and proper environmental variables configured. The environmental variables are set in file `files/mon/condor/condor_config.local`. The installation of `condor` package and placement of the default configuration file is done simply by setting:

```yaml
argo::mon::condor: true
```

It is possible to override the configuration file, and it can be done by setting the path of the new source file in the yaml file:

```yaml
argo::mon::condor::local_config: puppet:///path/to/local_config/file
```

#### ARC-CE probes

For ARC-CE probes to work properly, besides the package providing the probes (`nordugrid-arc-nagios-plugins`), also packages `argo-probe-igtf` and `argo-probe-sensu` need to be additionally installed. There is also a configuration file that needs to be placed in proper directory (default file is `files/mon/egi/90-local.ini`). If The default file is sufficient, the `.yaml` file should simply contain:

```yaml
argo::mon::arc: true
```

and everything will be configured automatically. The configuration file can be overridden, by additionally adding:

```yaml
argo::mon::arc:local_ini: puppet:///path/to/local_ini/file
```

#### EGI

In case you wish to have both condor and ARC-CE probes set up, you can simply use:

```yaml
argo::mon::egi: true
```

That flag invokes both previously described set ups.
