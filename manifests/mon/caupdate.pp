class argo::mon::caupdate (
  $source = 'puppet:///modules/argo/mon/caupdate/update_ca_bundle',
) {

  include ::gridcert
  include ::gridcert::crl

  package{ 'ca-certificates':
    ensure => latest,
  }

  file { '/usr/local/libexec/update_ca_bundle':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0755',
    source => $source,
  }

  exec { '/usr/local/libexec/update_ca_bundle':
    subscribe   => Package['ca-policy-egi-core'],
    refreshonly => true,
  }
}
