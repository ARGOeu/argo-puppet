# ARGO Puppet module

## Description

This repository contains a Puppet module used for installation and configuration of ARGO monitoring instances.

## Start using this module

Add this module and modules it depends on to your Puppetfile:

```
forge 'http://forge.puppetlabs.com'

# Forge | Puppet modules
mod 'puppet-cron', '5.0.0'
mod 'puppet-systemd', '8.1.0'
mod 'puppetlabs-stdlib', '9.7.0'
mod 'richardc-datacat', '0.6.2'
mod 'sensu-sensu', '5.11.1'

#GitHub Lutak Srce modules
mod 'umd',
  :git => 'https://github.com/lutak-srce/umd',
  :ref => 'master'
mod 'yum',
  :git => 'https://github.com/lutak-srce/yum',
  :ref => 'master'
mod 'gridcert',
  :git => 'https://github.com/lutak-srce/gridcert',
  :ref => 'master'
mod 'sysctl',
  :git => 'https://github.com/lutak-srce/sysctl',
  :ref => 'master'

# ARGO modules
mod 'argo',
  :git => 'https://github.com/argo/argo-puppet',
  :ref => 'master'
```

## Usage - configurations

The module can be used for configuration of monitoring boxes running Sensu.

In order to configuration to work, you must set either `backend` or `agent` parameter to `true` (depending on whether you are setting up the Sensu backend instance or one of the agents). For the instances being set up as Sensu agents, [argo-poem-tools](https://github.com/ARGOeu/argo-poem-tools) tool is going to be configured. For the instances being set up as Sensu backend, there will be [AMS publisher](https://github.com/ARGOeu/ams-publisher) and [argo-scg](https://github.com/ARGOeu/argo-scg) configured. Therefore, the necessary parameters should be provided as well.

Example:

```yaml
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

AMS Publisher is automatically configured for Sensu backend instances. It is necessary to define two parameters:

* `nagioshost` - hostname of the monitoring box (do not get confused by `nagios` - the name was left for simplicity)
* `publisher_queues_topics` - object containing information for ams publisher configuration file, as described [here](https://github.com/ARGOeu/ams-publisher#queue-topic-pair-section) and used in the `templates/mon/amspublisher/ams-publisher.conf.erb` template.

Example:

```yaml
argo::mon::amspublisher::nagioshost             : 'sensu-backend.example.com
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

Monitoring boxes configured to be Sensu agents will also have configured [argo-poem-tools](https://github.com/ARGOeu/argo-poem-tools) tool. Therefore, one must provide the necessary parameters:

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

### Disabling IPv6

In case the IPv6 needs to be disabled on the server, it is necessary only to set parameter:

```yaml
argo::mon::disable_ipv6: true
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

It is possible to choose the version of condor you wish to have installed, in which case the proper `.repo` file is going to be created. It is set up in the yaml file like this:

```yaml
argo::mon::condor::version: '23.0'
```

If the version is not set explicitly, it is set to version `'10.x'` by default.

It is also possible to disable the `htcondor.repo` by setting parameter `enable` to 0. By default it is enabled. Example of how to disable the repo:

```yaml
argo::mon::condor::enable: 0
```

#### ARC-CE probes

For ARC-CE probes to work properly, besides the package providing the probes (`nordugrid-arc-nagios-plugins`), also packages `nordugrid-arc-nagios-plugins-egi`, `argo-probe-igtf` and `argo-probe-sensu` need to be additionally installed. There is also a configuration file that needs to be placed in proper directory (default file is `files/mon/egi/90-local.ini`). If The default file is sufficient, the `.yaml` file should simply contain:

```yaml
argo::mon::arc: true
```

and everything will be configured automatically. The configuration file can be overridden, by additionally adding:

```yaml
argo::mon::arc:local_ini: puppet:///path/to/local_ini/file
```

#### gfal setting for nagios-plugins-storage

It is possible to override the `/etc/gfal2.d/http_plugin.conf` setting by setting up your own configuration file. Otherwise, the module will default to file `files/mon/gfal/http_plugin.conf`.

#### EGI

In case you wish to have both gfal setting, condor, and ARC-CE probes set up, you can simply use:

```yaml
argo::mon::egi: true
```

That flag invokes both previously described set ups.
