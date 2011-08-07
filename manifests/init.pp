class authconfig($algo='sha512') {

  package{'authconfig': ensure => installed }

  exec{'ensure_shadowed_passwd':
    command => 'pwconv',
    creates => '/etc/shadow',
  }
  exec{'ensure_shadowed_group':
    command => 'grpconv',
    creates => '/etc/gshadow',
  }

  exec{"ensure_${authconfig::algo}_authtconfig":
    command => "authconfig --passalgo=${authconfig::algo} --update",
    unless => "authconfig --test | grep -q 'password hashing algorithm is ${authconfig::algo}'",
    require => [ Package['authconfig'], Exec['ensure_shadowed_passwd','ensure_shadowed_group'] ],
  }
}
