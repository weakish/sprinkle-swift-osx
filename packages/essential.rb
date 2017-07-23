require './config'
user_name = UserSettings[:user_name] || ENV['USER']

package :essential do
  requires :path
  # Mac OS X has curl, vim, rsync preinstalled.
  # saveosx ships gpg.
  requires :git
  requires :wget
  requires :locale
  requires :xcode
  requires :tsocks
  requires :attic
end


package :path do
  requires :bin_path
  requires :man_path
  requires :bash_rc
end
package :bin_path do
  # Used by pip and others.
  home_local_path = '$HOME/.local/bin'
  gem_path = "$(gem env gempath | egrep -o '/Users/[^:]+/[0-9.]+')/bin"
  pkgin_path = '/opt/pkg/bin:/opt/pkg/sbin'
  opt_paths = "#{home_local_path}:#{gem_path}:#{pkgin_path}"
  local_paths = '/usr/local/bin:/usr/local/sbin'
  system_paths = '/usr/bin:/bin:/usr/sbin:/sbin'
  common_paths = "#{local_paths}:#{system_paths}"
  paths = "#{opt_paths}:#{common_paths}"
  profile = '$HOME/.bash_profile'
  runner %Q(echo "export PATH=#{paths}" >> #{profile})
  verify do file_contains profile, '/opt/pkg/bin' end
end
package :man_path do
  home_local_man = '$HOME/.local/share/man'
  pkgin_man = '/opt/pkg/share/man'
  opt_man = "#{home_local_man}:#{pkgin_man}"
  local_man = '/usr/local/man:/usr/local/share/man'
  system_man = '/usr/share/man'
  common_man = "#{local_man}:#{system_man}"
  man = "#{opt_man}:#{common_man}"
  push_text "export MANPATH=#{man}", '$HOME/.bash_profile'
  verify do file_contains '$HOME/.bash_profile', '/opt/pkg/share/man' end
end
# source `~/.bash_profile`.
package :bash_rc do
  push_text 'source $HOME/.bash_profile', '$HOME/.bashrc'
  verify do file_contains '$HOME/.bashrc', 'bash_profile' end
end

package :git do
  # pkgin has newer version of git.
  pkgin 'git'
  # Mac OS X has `/usr/bin/git` pointing to xcode preinstalled.
  # Thus `has_executable` will return true even if xcode is not installed.
  verify do has_pkgin 'git' end
end

package :wget do
  pkgin 'wget'
  verify do has_executable 'wget' end
end

package :locale do
  lc_all = 'export LC_ALL=en_US.UTF-8'
  lang = 'export LANG=en_US.UTF-8'
  push_text "#{lc_all}; #{lang}", '$HOME/.bash_profile'
  verify do file_contains '$HOME/.bash_profile', 'LC_' end
end

package :xcode do
  # Non interactive.
  # Reference:
  # - http://billwangxw.blogspot.jp/2016/04/jenkins-install-xcode-over-ssh-on.html
  # - https://developer.apple.com/news/?id=09222015a
  requires :xcode_dmg
  requires :xcode_license
  requires :install_xcode
end
package :xcode_dmg do
  # `$HOME` does not work.
  target_dir = "/Users/#{user_name}/Downloads"
  transfer UserSettings[:xcode_dmg_path], target_dir
  verify do sh "ls #{target_dir}/Xcode*.dmg" end
end
package :xcode_license do
  # `$HOME` does not work.
  target_dir = "/Users/#{user_name}/Downloads"
  target = "#{target_dir}/xcode-license.tcl"
  transfer 'assets/xcode-license.tcl', target
  verify do has_file target end
end
package :install_xcode do
  download_dir = '$HOME/Downloads'
  dmg = "#{download_dir}/Xcode*.dmg"

  mount_dmg = "hdiutil attach #{dmg}"
  mounted = '/Volumes/Xcode/Xcode.app'

  validator = 'spctl --assess --verbose'
  report = "#{download_dir}/xcode_validating_report.txt"
  validate = "#{validator} #{mounted} > #{report}"
  accept = "cat #{report} | fgrep -q accepted"
  source = "cat #{report} | egrep -q '^source=(Apple( System)?|Mac App Store)'"
  check_app = "#{validate} && #{accept} && #{source}"

  copy_app = "cp #{mounted} /Applications"

  unmount_dmg = 'hdiutil detach /Volumes/Xcode'

  # Mac OS X has `except` preinstalled.
  expect_license = "/usr/bin/expect -f #{download_dir}/xcode-license.tcl"

  runner "#{mount_dmg} && #{check_app} && #{copy_app}; #{unmount_dmg}"

  verify do sh 'xcode-select -p | fgrep -q "/Applications/Xcode"' end
end


package :tsocks do
  pkgin 'tsocks'
  verify do has_executable 'tsocks' end
end

# MAYBE pkgsrc/sysutils/py-attic
package :attic do
  requires :python3  # >= 3.2
  requires :pip3
  requires :msgpack_python  # >= 0.1.10
  requires :openssl  # >= 1.0.0
  runner "ATTIC_OPENSSL_PREFIX=/opt/pkg pip install --user Attic"
  verify do has_executable 'attic' end
end

package :python3 do
  pkgin 'python35'
  verify do has_executable 'python3' end
end

package :pip3 do
  pkgin 'py35-pip'
  verify do has_executable 'pip' end
end

package :msgpack_python do
  pkgin 'py35-msgpack'
  verify do has_pkgin 'py35-msgpack' end
end

package :openssl do
  pkgin 'openssl'
  verify do has_executable 'openssl' end
end


