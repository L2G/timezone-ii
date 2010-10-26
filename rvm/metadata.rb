maintainer "James Harton, Sociable Limited."
maintainer_email "james@sociable.co.nz"
license "Apache 2.0"
description "Installs and configures RVM, optionally keeping it updated."
version "0.0.1"
recipe "rvm"

# If it's Debian derived we need apt.
depends "apt" if [ 'debian', 'ubuntu' ].member? node[:platform]
