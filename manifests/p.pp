#
# = Define: mkdir::p
#
# A useful mkdir::p resource.

#
#
# == Author(s)
#
# * Axel Bock <mr.axel.bock@gmail.com>
#
define mkdir::p (
  Stdlib::Absolutepath               $path         = $title,
  Enum[absent, present]              $ensure       = present,
  Optional[Stdlib::Filemode]         $mode         = undef,
  Optional[Variant[Integer, String]] $owner        = undef,
  Optional[Variant[Integer, String]] $group        = undef,
  Boolean                            $declare_file = false,
) {
  $use_title = "mkdir_p_${title}"

  anchor { "${use_title}__begin": }
  -> exec { $use_title:
    command => "mkdir -p '${path}'",
    unless  => "test -d '${path}'",
    path    => '/bin:/usr/bin',
    before  => Anchor["${use_title}__end"],
  }

  if !$declare_file {
    if $mode {
      $threedigitmode = inline_template('<%= @mode[1..-1] if @mode[0] == "0" %>')
      exec { "${use_title}_chmod__${mode}":
        command => "chmod ${mode} '${path}'",
        unless  => "test $(stat -c %a '${path}') = ${mode} -o $(stat -c %a '${path}') = ${threedigitmode}",
        path    => '/bin:/usr/bin',
        require => Exec[$use_title],
        before  => Anchor["${use_title}__end"],
      }
    }

    if $owner {
      exec { "${use_title}_chown__${owner}":
        command => "chown ${owner} '${path}'",
        unless  => "test $(stat -c %U '${path}') = ${owner} -o $(stat -c %u '${path}') = ${owner}",
        path    => '/bin:/usr/bin',
        require => Exec[$use_title],
        before  => Anchor["${use_title}__end"],
      }
    }

    if $group {
      exec { "${use_title}_chgrp__${group}":
        command => "chgrp ${group} '${path}'",
        unless  => "test $(stat -c %G '${path}') = ${group} -o $(stat -c %g '${path}') = ${group}",
        path    => '/bin:/usr/bin',
        require => Exec[$use_title],
        before  => Anchor["${use_title}__end"],
      }
    }
  } else {
    file { $path:
      ensure  => directory,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      require => Exec[$use_title],
      before  => Anchor["${use_title}__end"],
    }
  }
  anchor { "${use_title}__end": }
}
