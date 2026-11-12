class argo::mon::scg (
  $topology        = '',
  $attributes      = '',
  $sensu_url       = '',
  $sensu_token     = '',
  $webapi_url      = '',
  $tenant_sections = {},
  $agents_config   = '',
  $cron_hour       = '*/2',
  $cron_minute     = '15',
) {

  package {'argo-scg':
    ensure => latest,
  }

  file { '/etc/argo-scg/scg.conf':
    ensure  => present,
    content => template('argo/mon/scg/scg.conf.erb'),
  }

  file { '/etc/argo-scg/topology.d':
    ensure  => directory,
    recurse => remote,
    source  => $topology,
  }

  if ($agents_config != '') {
    file { '/etc/argo-scg/agents.d':
      ensure  => directory,
      recurse => remote,
      source  => $agents_config,
    }
  }

  cron::job { 'scgReload':
      command     => 'flock -n -E 1 /tmp/scg-reload.lock scg-reload.py',
      user        => 'root',
      hour        => $cron_hour,
      minute      => $cron_minute,
      environment => [ 'PATH=/sbin:/bin:/usr/sbin:/usr/bin' ],
    }
}
