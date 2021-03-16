class argo::mon::ncg (
  $nagioshost = '',
  $nagiosadmin = '',
  $webapi_url = '',
  $webapi_token = '',
  $poem_url = '',
  $poem_token = '',
  $profiles = '',
  $conf_source = 'puppet:///private/ncg/ncg.conf',
  $localdb = false,
  $localdb_source = 'puppet:///private/ncg/ncg-localdb.d/',
  $version = latest,
) {
  File {
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  package { 'argo-ncg':
    ensure => $version,
  }

  file { '/etc/argo-ncg/ncg-vars.conf':
    content => template('templates/ncg/ncg-vars.conf.erb'),
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
}
