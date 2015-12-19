require 'tmpdir'

module Xcunique
  module CLI
    def self.run argv
      options = Options.parse(argv)
      
      puts %Q{Parsing "#{options.project_path}"} if options.verbose
      result = Sorter.new(Uniquifier.new(options.project_path).uniquify).sort
      
      case options.format
      when :json
        puts JSON.pretty_generate(result)
      when :xml, :ascii
        Dir.mktmpdir do |dir|
          json_path = dir + '/project.json'
          puts %Q{Writing uniqued JSON to "#{json_path}"} if options.verbose
          File.open(json_path, 'w') do |file|
            file.puts result.to_json
          end
          
          json2plist = File.expand_path('../json2plist/json2plist', __dir__)
          
          puts %Q{Running "#{json2plist} #{json_path} #{options.project_path}"} if options.verbose
          system File.expand_path('../json2plist/json2plist', __dir__), json_path, options.project_path
        end
      end
      
      if options.format == :ascii
        Dir.chdir File.dirname(options.project_path) do
          puts %Q{Running "xcproj touch" in "#{File.dirname(options.project_path)}"} if options.verbose
          system 'xcproj', 'touch'
        end
      end
      
    rescue Options::NoProjectProvidedError, Options::UnknownFormatError, Options::MissingDependencyError => error
      puts error.message
    end
  end
end
