module Sprinkle
  module Installers
    class PushText < Installer

      protected

      # Override `install_command`,
      # since the original implementation uses `grep -Pz`,
      # incompatible with `grep` shipped by Mac OS X.
      # We do not grep for existing of the string,
      # no matter  option `idempotent` is set or not,
      # since there should be a `file_contains` verifier anywhere.
      # We also remove `-e` from `echo`,
      # since `echo` shipped by Mac OS X does not accept it.

        def install_commands #:nodoc:
          command = ""
          command << "#{sudo_cmd}/bin/echo '#{@text}' |#{sudo_cmd}tee -a #{@path}"
          command
        end
    end
  end
end


