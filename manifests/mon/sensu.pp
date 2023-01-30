class argo::mon::sensu (
  $agent   = false,
  $backend = false,
  $tenants = [],
) {
  include ::yum::repo::umd4

  if ($agent) {
    include sensu::agent
    include argo::mon::poemtools
  }

  if ($backend) {
    include sensu::backend

    include argo::mon::publisher
    include argo::mon::scg

    $tenants.each | String $tenant | {
      sensu_namespace { $tenant:
        ensure => present,
      }

      sensu_bonsai_asset { "sensu/sensu-slack-handler in ${tenant}":
        ensure  => present,
        version => '1.5.0',
        rename  => 'sensu-slack-handler',
      }
    }
  }
}
