$pages_repo = "https://github.com/iamthechad/iamthechad.github.io.git"

$ruby_version = "ruby-2.2.0"

class gh-repo {
  package { 'git-core':
    ensure => present
  }

  vcsrepo { "/opt/ghpages":
    ensure   => latest,
    owner    => vagrant,
    group    => vagrant,
    provider => git,
    require  => [ Package[ 'git-core' ] ],
    source   => $pages_repo,
    revision => 'master',
  }
}

class ghpages {
  package { "curl": ensure => present }
  ->
  class { 'rvm': }
  ->
  rvm::system_user { vagrant: ; }
  ->
  rvm_system_ruby {
    $ruby_version:
      ensure      => 'present',
      default_use => true,
  }
  ->
  rvm_gem { "${ruby_version}/github-pages":  }
}

class { 'nodejs':
  version => 'stable',
  make_install => false,
}
->
class { 'ghpages': }
->
class { 'gh-repo': }
->
exec{ 'jekyll serve --detach':
  cwd => "/opt/ghpages",
  environment => "GEM_HOME=/usr/local/rvm/gems/${ruby_version}",
  path => "/usr/local/rvm/rubies/${ruby_version}/bin:/usr/local/rvm/gems/${ruby_version}/bin:/usr/local/node/node-default/bin:/usr/bin:/bin",
  unless => "ps aux | grep jekyll 2>/dev/null",
  require => Vcsrepo[ "/opt/ghpages" ],
}
