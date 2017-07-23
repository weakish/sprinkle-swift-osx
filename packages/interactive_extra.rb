require './config'
user_name = UserSettings[:user_name] || ENV['USER']

package :interactive_extra do
    requires :fish
    requires :fish_simple_prompt
    requires :highway
    requires :jq
end

package :fish do
  osx_installer 'https://fishshell.com/files/2.2.0/fish.pkg'
  verify do has_executable 'fish' end
end

package :fish_simple_prompt do
  # `$HOME` does not work.
  target_dir = "/Users/#{user_name}/.config/fish/functions"
  target = "#{target_dir}/fish_prompt.fish"
  transfer 'assets/fish_prompt.fish', target do
    pre :install, "mkdir -p #{target_dir}"
  end
  verify do file_contains target, 'echo -n "$error_exit; "' end
end

package :highway do
  pkgin 'highway'
  verify do has_executable 'highway' end
end

# JSON is ubiquitous these days.
# But Mac OS X already has python and ruby preinstalled.
# Both have json parser in their standard library.
# Thus I put `jq` in `interactive_extra`.
package :jq do
  pkgin 'jq'
  verify do has_executable 'jq' end
end
