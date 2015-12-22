module Xcunique
  
  # Parser is responsible for traversing the project objects from the entry point provided
  # and building a Hash of visited notes which map old UUID to path of node.
  #
  # Nodes that have already been visited are skipped
  class Parser
    
    # @!attribute [r] objects
    #   @return [Hash] the project's objects Hash
    # @!attribute [r] visited
    #   @return [Hash] a mapping of old UUID to the of where the node is situated
    attr_reader :objects, :visited
    
    # @param project [Hash] the project to parse
    def initialize project
      @project = project
      @objects = @project[Keys::OBJECTS]
      @visited = {}
    end
    
    # Recursively traverse `object` building the `visited` Hash by keeping track of the current path
    #
    # Objects that have already been visited are skipped to avoid cycles or modifying existing values
    #
    # @param object [Hash, Array, String] the current object to traverse
    # @param path [String] the current path to this node
    def parse object:, path: nil, path_builder: FILE_PATH_BUILDER
      return if visited.has_key? object
      
      case object
      when Array
        object.each do |value|
          parse object: value, path: path, path_builder: path_builder
        end
      when Hash
        parse object: object.values, path: path, path_builder: path_builder
      when String
        current = objects[object]
        
        return if current.nil? || current['isa'].nil?
        
        parse object: current, path: path_builder[current_path: path, uuid: object, instance: self], path_builder: path_builder
      end
    end
    
    FILE_PATH_BUILDER = -> current_path:, uuid:, instance: {
      (current_path || []).dup.tap do |result|
      
        node = instance.objects[uuid]
        component_name = node[Keys::PATH] || node[Keys::NAME]
        
        if component_name
          result << component_name
        end
      
        relative_path = result.join('/')
      
        instance.visited[uuid] = relative_path.length > 0 ? relative_path : Keys::PBXProject
      
      end
    }
    
    VERBOSE_PATH_BUILDER = -> current_path:, uuid:, instance: {
      (current_path || '').dup.tap do |result|
      
        node = instance.objects[uuid]
        result << '/' + node[Keys::ISA] + Helpers.resolve_attributes(uuid, instance.objects)
        instance.visited[uuid] = result
        
      end
    }
    
    private
    
    attr_accessor :project
    
  end
end
