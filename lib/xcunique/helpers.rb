module Xcunique
  module Helpers
    
    # Returns the `name` and `path` components of a node
    #
    # If the object contains a `fileRef` key then this is traversed to get
    # the `name`/`path` attributes from the reference file.
    #
    # @param uuid [String] the UUID of the object to resolve the attributes for
    # @param objects [Hash] the objects collection in the project
    # @return [String] the resolved attributes or an empty string
    #
    # @example Valid names are of the form
    #   ''
    #   (name: 'Some Name')
    #   (path: 'Some Path')
    #   (name: 'Some Name', path: 'Some Path')
    def self.resolve_attributes uuid, objects
      components = map_name_and_path(uuid, objects) { |key, value| "#{key}: '#{value}'" }.join(", ")
      components.length > 0 ? %Q{(#{components})} : ''
    end
    
    # Returns the file/group name
    # 
    # Performs the same lookup as `resolve_attributes` but returns a simplified string
    # that generally represents the actual folder/file name in the file explorer
    def self.canonical_name uuid, objects
      map_name_and_path(uuid, objects) { |_, value| value.split('/').last }.first || ''
    end
    
    private
    
    def self.map_name_and_path uuid, objects, &block
      object = objects[objects[uuid][Keys::FILE_REF] || uuid]
      
      object.sort.select { |key, _| [ Keys::NAME, Keys::PATH ].include?(key) }.map(&block)
    end
  end
end
