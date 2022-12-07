# puppet-mkdir

[![Build Status](https://travis-ci.com/rehanone/puppet-mkdir.svg?branch=master)](https://travis-ci.com/rehanone/puppet-mkdir)

This module is a clone of [flypenguin/mkdir](https://forge.puppet.com/modules/flypenguin/mkdir/).

Provides an `mkdir -p` implementation in pure puppet code, no functions.

## Sample Usage

# mkdir::p

```
mkdir::p { '/this/is/a/dir': }

mkdir::p { 'important dir':
  path => '/this/is/a/dir',
}

mkdir::p { '/this/is/a/dir':
  owner   => 'me',
  mode    => '0700',
}

mkdir::p { '/this/is/a/dir':
  declare_file => true,
}
# now auto-require works ...
file { '/this/is/a/dir/and_a_file':
  ensure  => 'present',
  content => 'I can be sure that this works now :)',
}

```
