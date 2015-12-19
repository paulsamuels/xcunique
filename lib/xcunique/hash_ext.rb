class Hash
  
  # Performs a deep clone of the object with optional substitutions
  #
  # @param substitutions [Hash] optional mapping of substitutions. 
  #   If provided during copying any matching substitutions.key in the original will be replaced with the substitutions.value in the clone
  # @param object [Object] the object to duplicate. This is a recursive call and will continue until resolving to a [String] or [Numeric]
  # @return [Hash] the deeply copyed object with any substitutions performed
  #
  # @example
  #   { 'needle' => 'test' }.deep_dup(substitutions: { 'needle' => 'dog' }) #=> { 'dog' => 'test' }
  def deep_dup substitutions: {}, object: self
    recurse = -> object { deep_dup substitutions: substitutions, object: object }
    
    case object
    when Hash
      Hash[object.map(&recurse)]
    when Array
      object.map(&recurse)
    when String, Numeric
      substitutions[object] || object
    end
  end
  
end
