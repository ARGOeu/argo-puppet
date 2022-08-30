class argo::mon::hostcert {

  include ::yum::repo::umd4
  include ::gridcert
  include ::gridcert::crl

  File {
    ensure  => present,
    owner   => 'sensu',
    group   => 'sensu',
    mode    => '0444',
  }

  file { '/etc/sensu/certs/hostcert.pem':
    source  => $::gridcert::hostcert,
  }
  file { '/etc/sensu/certs/hostkey.pem':
    mode    => '0400',
    source  => $::gridcert::hostkey,
  }
}
