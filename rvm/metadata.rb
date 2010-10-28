maintainer "James Harton, Sociable Limited."
maintainer_email "james@sociable.co.nz"
license "MIT"
description "Installs and configures RVM, optionally keeping it updated."
version "0.0.2"

# The rvm recipe only installs rvm
# and doesn't do anything else.
recipe "rvm"
# the rvm:install recipe installs
# a ruby implementation based on
# node attributes.
recipe "rvm::install"

# these are just quick helpers
# for common implementations for
# people who can't/won't set
# node attributes for themselves.
recipe "rvm::ruby_192"
recipe "rvm::ruby_187"
recipe "rvm::ree"

# If it's Debian derived we need apt.
depends "apt" if [ 'debian', 'ubuntu' ].member? node[:platform]
