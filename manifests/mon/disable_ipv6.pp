class argo::mon::disable_ipv6 () {
  sysctl { 'net.ipv6.conf.all.disable_ipv6' :
    value   => '1',
    comment => 'Disable IPv6',
  }

  sysctl { 'net.ipv6.conf.default.disable_ipv6' :
    value   => '1',
    comment => 'Disable IPv6',
  }
}
