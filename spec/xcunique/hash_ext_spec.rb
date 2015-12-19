require_relative '../spec_helper'

describe Hash do
  
  it 'performs a deep duplicate of simple types' do
    input = {
      "array"  => [ 1, 2, 3 ],
      "string" => 'value'
    }
    
    result = input.deep_dup
    
    assert_equal input, result
    refute_equal input.object_id, result.object_id
    refute_equal input['array'].object_id, result['array'].object_id
  end
  
  it 'substitutes objects that match in the substitutes hash' do
    input = {
      'aaaa'  => [ 1, 2, 3 ],
      'bbbb' => 'cccc',
      'dddd' => 'eeee'
    }
    
    expected = {
      'AAAA'  => [ 1, 2, 3 ],
      'BBBB' => 'CCCC',
      'dddd' => 'eeee'
    }
    
    result = input.deep_dup(substitutions: { 'aaaa' => 'AAAA', 'bbbb' => 'BBBB', 'cccc' => 'CCCC' })
    
    assert_equal expected, result
  end
  
end
