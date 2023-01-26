class argo::mon (
  $gridcert      = false,
  $robotcert     = false,
  $moncert       = false,
  $voms_htpasswd = false,
  $egi           = false,
  $eudat	       = false,
) {
  include yum::repo::argo

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
}
