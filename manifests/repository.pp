#
#
#
define profile_git::repository (
  Stdlib::Absolutepath $repository_root = '/srv/gitolite/repositories',
  Array[String]        $groups          = [],
  Hash                 $rules           = {},
  String               $description     = $title,
  Hash                 $remotes         = {},
  Hash                 $options         = {},
) {
  $_full_path = extlib::path_join(concat([$repository_root], $groups, "${name}.git"))
  
  file { $_full_path:
    ensure   => 'directory',
    owner    => 'git',
    group    => $::apache::group,
  }

  gitolite::repo { $name:
    rules         => $rules,
    description   => $description,
    comments      => concat($groups, $description),
    remotes       => $remotes,
    groups        => $groups,
    remote_option => '-v',
    options       => $options,
  }
}
