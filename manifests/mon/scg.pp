class argo::mon::scg (
  $topology = '',
  $attributes = '',
  $sensu_url = '',
  $sensu_token = '',
  $webapi_url = '',
  $tenant_sections = {},
) {
  package { 'argo-scg':
    ensure => latest,
  }

  file { '/etc/argo-scg/scg.conf':
    ensure  => present,
    content => template('argo/mon/scg/scg.conf.erb'),
    require => Package['argo-scg'],
  }

  file { '/etc/argo-scg/topology.d':
    ensure  => directory,
    recurse => remote,
    source  => $topology,
    require => Package['argo-scg'],
  }

  file { '/etc/argo-scg/attributes.d':
    ensure  => directory,
    recurse => remote,
    source  => $attributes,
    require => Package['argo-scg'],
  }

  cron::job { 'scgReload':
    command     => '/bin/scg-reload.py',
    user        => 'root',
    hour        => '*/2',
    minute      => '15',
    environment => [ 'PATH=/sbin:/bin:/usr/sbin:/usr/bin' ],
  }
}
