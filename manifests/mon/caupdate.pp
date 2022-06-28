class argo::mon::caupdate (
  $source = 'puppet:///modules/argo/mon/caupdate/update_ca_bundle',
) {
  package{ 'ca-certificates':
    ensure => latest,
    notify => Exec['/bin/update_ca_bundle'],
  }

  file { '/bin/update_ca_bundle':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => $source,
  }

  exec { '/bin/update_ca_bundle':
  }
}
