module Pod
  class Command
    # This is an example of a cocoapods plugin adding a top-level subcommand
    # to the 'pod' command.
    #
    # You can also create subcommands of existing or new commands. Say you
    # wanted to add a subcommand to `list` to show newly deprecated pods,
    # (e.g. `pod list deprecated`), there are a few things that would need
    # to change.
    #
    # - move this file to `lib/pod/command/list/deprecated.rb` and update
    #   the class to exist in the the Pod::Command::List namespace
    # - change this class to extend from `List` instead of `Command`. This
    #   tells the plugin system that it is a subcommand of `list`.
    # - edit `lib/cocoapods_plugins.rb` to require this file
    #
    # @todo Create a PR to add your plugin to CocoaPods/cocoapods.org
    #       in the `plugins.json` file, once your plugin is released.
    #
    class Transform < Command
      self.summary = 'Transform Podfile between source Code and Framework.'
      self.command = 'transform'
      self.description = <<-DESC
        With this command, users can transform Podfile between source Code and Framework,
        very useful for Debug, code searching, code replacing and so on.
      DESC

      def validate!
        super
      end

      def run
        path = podfile_path
        if !path
          help! 'Make sure a Podfile at current directory!'
        end
        pods = parse_Podfile(path)
        print("#{pods}")
        transform(path, pods)
      end

      def podfile_path
        podfile_path = Dir.pwd+'/Podfile'
        if File.exist?(podfile_path)
          return podfile_path
        else
          return
        end
      end

      def parse_Podfile(podfile_path)
        active_pods = Array.new
        inactive_pods = Array.new
        File.open(podfile_path, 'r') do |f|
          active_pod_reg = /^[\t ]*Pod *('.*')[\n\r,]$/
          inactive_pod_reg = /^[#\t ]*Pod *('.*')[\n\r,]$/
          f.each_line do |line|
            if active_pod_reg.match(line)
              active_pods.push($1)
            elsif inactive_pod_reg.match(line)
              inactive_pods.push($1)
            end
          end
        end
        print("#{active_pods}")
        return active_pods & inactive_pods
      end

      def transform(podfile_path, pods)
        content = File.read(podfile_path)
        for pod in pods
          content = content.gsub(/^[\t\f]*Pod/, '#Pod')
          content = content.gsub(/^[#\t\f]*Pod/, 'Pod')
        end

        File.open(podfile_path, 'w') do |f|
          f.puts(content)
        end
      end
    end
  end
end
