# For capistrano 2.x.
# Assumes you uses the same user name,
# and has configured `osx` to point to your Mac OS X machine
# in`~/.ssh/config`.
# Also configure `NOPASSWD` for `sudo`.
role :osx, 'osx'
