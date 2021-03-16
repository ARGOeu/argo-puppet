class argo::mon::nagios (
  $conf_source = 'puppet:///modules/argo/mon/nagios/nagios.cfg',
  $cgi_source = 'puppet:///modules/argo/mon/nagios/cgi.cfg'
) {
  package {'nagios':
    ensure  => present,
    require => Package['httpd'],
  }

  file { '/etc/nagios/nagios.cfg':
    ensure  => present,
    owner   => nagios,
    group   => nagios,
    mode    => '0644',
    source  => $conf_source,
    require => Package['nagios'],
  }

  file { '/etc/nagios/cgi.cfg':
    ensure  => present,
    owner   => nagios,
    group   => nagios,
    mode    => '0644',
    source  => $cgi_source,
    require => Package['nagios'],
  }
}
