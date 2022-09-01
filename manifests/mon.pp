class argo::mon (
  $gridcert      = false,
  $robotcert     = false,
  $moncert       = false,
  $voms_htpasswd = false,
  $egi           = false,
  $eudat	       = false,
  $internal      = false,
) {
  include yum::repo::argo

  package {'httpd':
    ensure => latest,
  }

  package {'mod_ssl':
    ensure => latest,
  }

  package { 'python3-argo-ams-library':
    ensure => latest,
  }

  package { 'python-argo-ams-library':
    ensure => latest,
  }

  include argo::mon::nagios

  package {'nagios-plugins-dummy':
    ensure =>  present,
  }

  include argo::mon::ncg
  include argo::mon::caupdate

  if !$internal {
    include argo::mon::amspublisher
    include argo::mon::poemtools

    package { 'argo-probe-poem-tools':
      ensure => latest,
    }
  }

  if ($moncert) {
    include argo::mon::moncert
  }
  if ($gridcert) {
    include argo::mon::hostcert
  }
  if ($robotcert) {
    include argo::mon::robotcert
  }
  if ($voms_htpasswd) {
    include argo::mon::voms_htpasswd
  }
  if ($egi) {
    include argo::mon::egi
  }
  if ($eudat) {
    include argo::mon::eudat
  }
  if ($internal) {
    include argo::mon::internal
  }
}
