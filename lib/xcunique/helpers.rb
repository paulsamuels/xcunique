module Xcunique
  module Helpers
    
    # Returns the object at a keypath in the project
    #
    # @param key_path [Array<String>] the key path to navigate
    # @param root [Hash] the object to start the traversal from
    # @parem objects [Hash] the project's objects
    # @return [Object] the object retreived by traversing the key path
    def self.object_at_key_path key_path, root, objects=root[Keys::OBJECTS]
      Array(key_path).reduce(root) do |current, key|
        objects[current[key]]
      end
    end
    
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
      object = objects[objects[uuid][Keys::FILE_REF] || uuid]
      
      components = object.sort.select { |key, _| [ Keys::NAME, Keys::PATH ].include?(key) }.map { |key, value| "#{key}: '#{value}'" }.join(", ")
      components.length > 0 ? %Q{(#{components})} : ''
    end
    
  end
end
