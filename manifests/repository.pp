#
#
#
define profile_git::repository (
  Stdlib::Absolutepath $repository_root = '/srv/gitolite/repositories',
  Hash                 $rules           = {},
  String               $description     = 'Managed by Puppet',
  Hash                 $remotes         = {},
  Optional[String]     $source          = undef,
) {
  vcsrepo { "${repository_root}/${name}.git":
    ensure   => 'bare',
    provider => 'git',
    owner    => 'git',
    group    => $::apache::group,
    source   => $source,
  }

  gitolite::repo { $name:
    rules       => $rules,
    description => "${description}\n",
  }

  $_repository_config = {
    'url'  => $name,
    'path' => "${repository_root}/${name}.git",
    'desc' => $description,
  }
  concat::fragment { $name:
    target  => '/etc/cgitrc.gitolite',
    order   => '1',
    content => epp("${module_name}/cgit_repo_fragment.epp", $_repository_config)
  }
}
