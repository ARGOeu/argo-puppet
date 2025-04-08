class argo::mon (
  $gridcert      = false,
  $robotcert     = false,
  $voms_htpasswd = false,
  $egi           = false,
  $eudat         = false,
  $condor        = false,
  $arc           = false,
  $disable_ipv6  = false,
) {
  include yum::repo::argo
  include ::yum::repo::igtf
  include argo::mon::copr

  if ($disable_ipv6) {
    include argo::mon::disable_ipv6
  }

  include argo::mon::sensu
  include argo::mon::caupdate

  if ($gridcert) {
    include argo::mon::hostcert
  }
  if ($robotcert) {
    include argo::mon::robotcert
  }
  if ($egi) {
    include argo::mon::condor
    include argo::mon::arc
    include argo::mon::gfal
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
