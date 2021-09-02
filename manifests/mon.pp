class argo::mon (
  $gridcert      = false,
  $robotcert     = false,
  $voms_htpasswd = false,
  $egi           = false,
  $internal      = false,
) {
  include yum::repo::argo

  package {'httpd':
    ensure => latest,
  }

  package {'mod_ssl':
    ensure => latest,
  }

  include argo::mon::nagios
  
  package {'nagios-plugins-dummy':
    ensure =>  present,
  }

  include argo::mon::ncg

  if !$internal {
    include argo::mon::amspublisher
    include argo::mon::poemtools
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
  if ($internal) {
    include argo::mon::internal
  }
}
