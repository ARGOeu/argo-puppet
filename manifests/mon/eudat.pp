class argo::mon::eudat (
  $files_source = 'puppet:///private/eudat_files',
) {
  file { '/etc/nagios/plugins/':
    ensure  => directory,
    recurse => remote,
    source  => $files_source
  }
}
