class argo::mon::ncg (
  $nagioshost     = '',
  $nagiosadmin    = '',
  $webapi_url     = '',
  $webapi_token   = '',
  $poem_url       = '',
  $poem_token     = '',
  $profiles       = '',
  $conf_source    = 'puppet:///private/ncg/ncg.conf',
  $gocdb          = false,
  $gocdb_url      = 'https://gocdb.egi.eu/gocdbpi',
  $localdb        = false,
  $localdb_source = 'puppet:///private/ncg/ncg-localdb.d/',
  $version        = latest,
  $cronjob        = true,
) {
  File {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  package { 'argo-nagios-tools':
  }

  package { 'argo-ncg':
    ensure => $version,
  }

  file { '/etc/argo-ncg/ncg-vars.conf':
    content => template('argo/mon/ncg/ncg-vars.conf.erb'),
    require => Package['argo-ncg'],
  }

  file { '/etc/argo-ncg/ncg.conf':
    source  => $conf_source,
    require => Package['argo-ncg'],
  }

  if ( $localdb ) {
    file { '/etc/argo-ncg/ncg-localdb.d':
      ensure  => directory,
      recurse => remote,
      source  => $localdb_source,
    }
  }

  if ($cronjob) {
    cron::job { 'ncgReload':
      command     => '( /usr/sbin/ncg.reload.sh ) > /var/log/ncg.log 2>&1',
      user        => 'root',
      hour        => '*/2',
      minute      => '15',
      environment => [ 'PATH=/sbin:/bin:/usr/sbin:/usr/bin' ],
    }
  }
}
