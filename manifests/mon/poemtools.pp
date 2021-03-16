class argo::mon::poemtools (
  $poem_url = '',
  $poem_token = '',
  $profiles = '',
) {
  package {'argo-poem-tools':
    ensure => latest,
  }

  file { '/etc/argo-poem-tools/argo-poem-tools.conf':
    content => template('argo/mon/poemtools/argo-poem-tools.conf.erb'),
    require => Package['argo-poem-tools'],
  }
}

