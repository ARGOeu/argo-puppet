class argo::mon::eudat (
  $files_source = 'puppet:///private/eudat_files',
) {
  package {'nagios':
    ensure  => present,
    require => Package['httpd'],
  }

  file { '/etc/nagios/plugins/':
    ensure  => directory,
    recurse => remote,
    source  => $files_source
  }
}
