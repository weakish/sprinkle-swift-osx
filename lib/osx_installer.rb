module Sprinkle
  module Installers
    # The osx_installer installer installs pkg packages on Mac OS X.
    #
    # == Example Usage
    #
    # Installing the magic_beans package.
    #
    #   package :magic_beans do
    #     osx_installer 'http://example.com/magic_beans.pkg'
    #   end
    #
    class OSXInstaller < PackageInstaller

      attr_accessor :package_url

      api do
        def osx_installer(url, &block)
          install OSXInstaller.new(self, url, &block)
        end
      end
      def initialize(parent, package_url, &block) #:nodoc:
        super parent, &block
        @package_url = package_url
      end

      protected

        def install_commands #:nodoc:
          pkg_url = @package_url
          pkg_name = pkg_url.split('/').last
          pkg_path = "$HOME/Downloads/#{pkg_name}"
          download_pkg = "curl -C - #{pkg_url} > #{pkg_path}"
          install_pkg = "sudo installer -pkg #{pkg_path} -target /"
        end
    end
  end
end
