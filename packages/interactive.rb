package :interactive do
  requires :tmux
  requires :ncdu
  requires :htop
  requires :tig
  requires :diff
  requires :hub
  requires :swiftenv
end


package :tmux do
  pkgin 'tmux'
  verify do has_executable 'tmux' end
end


package :ncdu do
  pkgin 'ncdu'
  verify do has_executable 'ncdu' end
end


# MAYBE pkgsrc/sysutils/htop
package :htop do
  source 'http://hisham.hm/htop/releases/2.0.1/htop-2.0.1.tar.gz'
  verify do has_executable 'htop' end
end


package :tig do
  pkgin 'tig'
  verify do has_executable 'tig' end
end


package :hub do
  url = 'https://github.com/github/hub/releases/download/v2.2.3/hub-darwin-amd64-2.2.3.tgz'
  hub_tarball = url.split('/').last
  download = "cd $HOME/Downloads; wget -c #{url}"
  untar = "tar xzf #{hub_tarball}"
  hub_dir = hub_tarball[0...-4]
  install = "cd #{hub_dir} && sudo ./install"
  cd_back = "cd $HOME"
  runner "#{download} && #{untar} && #{install} && #{cd_back}"
  verify do has_executable 'hub' end
end


package :diff do
  requires :colordiff
  requires :cwdiff
  requires :xdelta
end

package :colordiff do
  pkgin 'colordiff'
  verify do has_executable 'colordiff' end
end

package :cwdiff do
  pkgin 'cwdiff'
  verify do has_executable 'cwdiff' end
end

package :xdelta do
  pkgin 'xdelta3'
  verify do has_executable 'xdelta3' end
end


package :swiftenv do
  clone = 'git clone https://github.com/kylef/swiftenv.git $HOME/.swiftenv'

  profile = '$HOME/.bash_profile'
  bash_root = %Q(echo 'export SWIFTENV_ROOT="$HOME/.swiftenv"' >> #{profile})
  bash_path = %Q(echo 'export PATH="$SWIFTENV_ROOT/bin:$PATH"' >> #{profile})
  bash_init = %Q(echo 'eval "$(swiftenv init -)"' >> #{profile})
  config_bash = "#{bash_root} && #{bash_path} && #{bash_init}"

  is_fish_installed = 'which fish'
  config = '$HOME/.config/fish/config.fish'
  fish_root = %Q(echo 'setenv SWIFTENV_ROOT "$HOME/.swiftenv"' >> #{config})
  fish_path = %Q(echo 'setenv PATH "$SWIFTENV_ROOT/bin" $PATH' >> #{config})
  interactive = 'status --is-interactive'
  init = '. (swiftenv init -|psub)'
  fish_init = %Q(echo '#{interactive}; and #{init}' >> #{config})
  config_fish = "#{fish_root} && #{fish_path} && #{fish_init}"

  # If fish is installed, enable `swiftenv` for fish,
  # otherwise enable it for bash.
  config_shell = "#{is_fish_installed} && (#{config_fish}) || (#{config_bash})"

  runner "#{clone} && #{config_shell}"

  verify do has_directory '$HOME/.swiftenv' end
end
