require 'json'
require 'digest/md5'

module Xcunique
  
  # Uniquifier coordinates the overall process of parsing and substituting the new deterministic keys
  class Uniquifier
    
    # @param project_path [String] the path of the project.pbxproj file
    def initialize project_path
      @project = JSON.parse(`plutil -convert json -o - #{project_path}`)
    end
    
    # Coordinates the overall process of parsing and substituting the new deterministic keys
    #
    # Files/Groups are parsed first with their path being rooted at the `mainGroup`
    # this prevents the path to a file potentially being changed by other project settings
    #
    # @return [Hash] a unqiued project object
    def uniquify
      root_uuid  = project[Keys::ROOT_OBJECT]
      main_group = Xcunique::Helpers.object_at_key_path [ Keys::ROOT_OBJECT, Keys::MAIN_GROUP ], project
      
      parser = Parser.new(project)
      parser.parse object: main_group
      parser.parse object: root_uuid, path_builder: Xcunique::Parser::VERBOSE_PATH_BUILDER
    
      project.deep_dup substitutions: Hash[parser.visited.map { |uuid, path| [ uuid, Digest::MD5.hexdigest(path) ] }]
    end
  
    private
  
    attr_reader :project
  
  end
end
