module Xcunique
  
  # Sorter traverses the objects in the project and sorts keys that are listed
  # in the `SORTABLE_ITEMS` array
  class Sorter
    # The keys within the project that should be supported
    SORTABLE_ITEMS = [ Keys::CHILDREN, Keys::FILES ]
    
    # Keys that could be sorted in future
    UNSUPPORTED_SORTABLE_ITEMS = %w(buildConfigurations  targets)
    
    # Returns a new instance of Sorter
    #
    # @param project [Hash] the project to sort
    def initialize project
      @project = project.deep_dup
      @objects = @project[Keys::OBJECTS]
    end
    
    # Traverses the objects in the project clone and sorts in place
    # objects that are held under the `SORTABLE_ITEMS` keys
    #
    # @return [Hash] a sorted project
    def sort
      objects.values.each do |object|
        SORTABLE_ITEMS.select { |key| object.has_key?(key) }.each do |key|
          object[key].sort_by!(&method(:comparator))
        end
      end
      project
    end
    
    private
    
    attr_accessor :objects, :project
    
    # The comparator used during the sort
    #
    # The comparator resolves the attributes for the node and appends a
    # known prefix to objects where `isa = PBXGroup` to ensure that groups
    # are sorted above files
    #
    # @param uuid [String] the uuid of the object to examine
    # @!visibility public
    def comparator uuid
      prefix = objects[uuid][Keys::ISA] == Keys::PBXGroup ? '  ' : ''
      prefix + Helpers.canonical_name(uuid, objects) 
    end
    
  end
end
