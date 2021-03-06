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
        pods = parse_Podfile(path)
        transform(path, pods)
      end

      def podfile_path
        podfile_path = Dir.pwd+'/Podfile'
        if File.exist?(podfile_path)
          return podfile_path
        else
          help! 'Make sure a Podfile at current directory!'
          return
        end
      end

      def parse_Podfile(podfile_path)
        active_pods = Array.new
        inactive_pods = Array.new
        File.open(podfile_path, 'r') do |f|
          active_pod_reg = /^[\t ]*pod *('\w+')[\n\r,]/
          inactive_pod_reg = /^[\t ]*#[\t ]*pod *('\w+')[\n\r,]/
          f.each_line do |line|
            if inactive_pod_reg.match(line)
              inactive_pods.push($1)
            elsif active_pod_reg.match(line)
            active_pods.push($1)
            end
          end
        end

        return active_pods & inactive_pods
      end

      def transform(podfile_path, pods)
        if pods.length == 0
          help! 'Podfile no valid pod to transform!'
          return
        end
        content = File.read(podfile_path)
        for pod in pods
          content = content.sub(/^[\t ]*pod +#{pod}/, "#####pod #{pod}")
          content = content.sub(/^[\t ]*#[\t ]*pod +#{pod}/, "pod #{pod}")
          content = content.sub(/^#####pod +#{pod}/, "#pod #{pod}")
        end

        File.open(podfile_path, 'w') do |f|
          f.puts(content)
        end
      end
    end
  end
end
