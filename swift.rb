require './lib/osx_installer'
require './lib/pkgin'
require './lib/push_text'
require './lib/sh'

require './packages/saveosx'
require './packages/essential'
require './packages/interactive'
# require './packages/interactive_extra'

policy :swift, :roles => :osx do
  # We use pkgsrc.
  requires :saveosx  # Keep it first.
  requires :essential
  requires :interactive
  # requires :interactive_extra
end

deployment do
  delivery :capistrano do
    recipes 'deploy'
  end

  source do
    prefix '/usr/local'
    archives '/usr/local/src'
    builds '/tmp/build'
  end

  binary do
    prefix '/opt'
    archives '/usr/local/src'
  end
end


