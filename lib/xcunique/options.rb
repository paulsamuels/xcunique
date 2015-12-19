require 'optparse'

module Xcunique
  
  # Options wraps the setup/running of an `OptionParser` and store the results
  class Options
    
    # Exception representing the lack of a dependency e.g. `xcproj`
    class MissingDependencyError < StandardError; end
    
    # Exception representing missing/invalid first argument which should be the project file
    class NoProjectProvidedError < StandardError; end
    
    # Exception representing an incorrect format has been selected
    class UnknownFormatError     < StandardError; end
    
    # @!attribute format
    #   @return [Symbol] The requested format must be ascii, json or xml - defaults to :ascii
    # @!attribute project_path
    #   @return [String] The path to the project.pbxproj - this will undergo file expansion
    # @!attribute verbose
    #   @return [Boolean] representing whether logging should be enabled - defaults to false
    attr_accessor :format, :project_path, :verbose
    
    # Parse array of options provided
    #
    # @return [Options] an Options object that is configured with the provided command line arguments
    def self.parse argv
      new.tap do |options|
        option_parser = options.send :option_parser
        
        option_parser.parse!(argv)
        
        raise NoProjectProvidedError.new(option_parser.banner) unless path = argv.first
        
        options.project_path = File.expand_path(path)
        
        raise NoProjectProvidedError.new(option_parser.banner) unless File.exist?(options.project_path)
      end
    end
    
    def initialize
      self.format = :ascii
    end
    
    private
    
    def option_parser
      @option_parser ||= begin
        OptionParser.new do |opts|
          opts.banner = "Usage: xcunique PROJECT.PBXPROJ [options]"
          
          opts.on('-f', '--format=<ascii|json|xml>', 'ascii|json|xml') do |format|
            self.format = format.chomp.to_sym
            raise UnknownFormatError.new(%Q{Unknown format "#{format}" - please choose ascii, json or xml}) unless %i{ascii json xml}.include?(self.format)
            raise MissingDependencyError.new("xcproj is required for converting to ascii") if self.format == :ascii && begin system("command -v xcproj 2&> /dev/null"); !$?.success? end
          end
          
          opts.on('-v', '--verbose') do |verbose|
            self.verbose = verbose
          end
          
        end
      end
    end
  
  end
end
