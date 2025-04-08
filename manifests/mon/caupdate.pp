class argo::mon::caupdate (
  $script_source = 'puppet:///modules/argo/mon/caupdate/update_ca_bundle',
  $dir_source    = 'puppet:///modules/argo/mon/caupdate/pki/',
) {

  include ::gridcert::crl

  package{ 'ca-certificates':
    ensure => latest,
  }

  file { '/usr/local/libexec/update_ca_bundle':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => $script_source,
  }

  file { '/usr/local/etc/pki':
    ensure  => directory,
    recurse => true,
    purge   => true,
    source  => $dir_source,
    notify  => Exec['/usr/local/libexec/update_ca_bundle'],
  }

  exec { '/usr/local/libexec/update_ca_bundle':
    path        => ['/usr/bin', '/usr/sbin', '/bin'],
    require     => File['/usr/local/libexec/update_ca_bundle'],
    subscribe   => [Package['ca-policy-egi-core'], File['/usr/local/etc/pki']],
    refreshonly => true,
  }
}
