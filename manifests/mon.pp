class argo::mon (
  $gridcert      = false,
  $robotcert     = false,
  $moncert       = false,
  $voms_htpasswd = false,
  $egi           = false,
  $eudat         = false,
  $sensu         = false,
  $condor        = false,
  $arc           = false,
) {
  include yum::repo::argo

  if ($egi) {
    include ::yum::repo::umd4
  } else {
    include ::yum::repo::igtf
  }

  if ($sensu) {
    include argo::mon::sensu
  } else {
    include argo::mon::nagios

    package {'nagios-plugins-dummy':
      ensure =>  present,
    }

    include argo::mon::ncg
    include argo::mon::amspublisher
  }

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
    include argo::mon::condor
    include argo::mon::arc
  }
  if ($eudat) {
    include argo::mon::eudat
  }
  if ($condor) {
    include argo::mon::condor
  }
  if ($arc) {
    include argo::mon::arc
  }
}
