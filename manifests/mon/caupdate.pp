class argo::mon::caupdate (
  $source = 'puppet:///modules/argo/mon/caupdate/update_ca_bundle',
) {
  package{ 'ca-certificates':
    ensure => latest,
    notify => Exec['/usr/local/libexec/update_ca_bundle'],
  }

  file { '/usr/local/libexec/update_ca_bundle':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => $source,
  }

  exec { '/usr/local/libexec/update_ca_bundle':
    refreshonly => true,
  }
}
