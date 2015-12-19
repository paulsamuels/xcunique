module Xcunique
  
  # Parser is responsible for traversing the project objects from the entry point provided
  # and building a Hash of visited notes which map old UUID to path of node.
  #
  # Nodes that have already been visited are skipped
  class Parser
    
    # @!attribute [r] visited
    #   @return [Hash] a mapping of old UUID to the of where the node is situated
    attr_reader :visited
    
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
    def parse object:, path: ""
      return if visited.has_key? object
     
      case object
      when Array
        object.each do |value|
          parse object: value, path: path
        end
      when Hash
        parse object: object.values, path: path
      when String
        current = objects[object]
        
        return if current.nil? || current[Keys::ISA].nil?
        
        path += '/' + current[Keys::ISA] + Helpers.resolve_attributes(object, objects)
        
        visited[object] = path
        
        parse object: current, path: path
      end
    end
    
    private
    
    attr_accessor :objects, :project
    
  end
end
