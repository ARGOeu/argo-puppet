class argo::mon::hostcert {

  include ::yum::repo::umd4
  include ::gridcert
  include ::gridcert::crl

  File {
    ensure  => present,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0444',
    require => [ Package['nagios'], Package['argo-ncg'] ],
  }

  file { '/etc/nagios/globus/hostcert.pem':
    source  => $::gridcert::hostcert,
  }
  file { '/etc/nagios/globus/hostkey.pem':
    mode    => '0400',
    source  => $::gridcert::hostkey,
  }
}
