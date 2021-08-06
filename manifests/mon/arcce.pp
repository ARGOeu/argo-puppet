class argo::mon::arcce (
  $local_ini='puppet:///private/arcce/90-local.ini',
) {
  file { '/etc/arc/nagios/90-local.ini':
    source  => $local_ini,
  }
}
