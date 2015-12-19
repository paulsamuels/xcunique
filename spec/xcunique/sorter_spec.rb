require_relative '../spec_helper'

describe Xcunique::Sorter do
  
  describe "when sorting groups" do
    it "sorts alphabetically by their name" do
      project = {
        'objects' => {
          'PARENT' => { 'children' => [ 'groupB', 'groupA' ] },
          'groupA' => { 'name' => 'A'  },
          'groupB' => { 'name' => 'B'  } 
        }
      }
    
      result = Xcunique::Sorter.new(project).sort
    
      assert_equal [ 'groupA', 'groupB' ], result['objects']['PARENT']['children']
    end
  
    it "sorts alphabetically by their path" do
      project = {
        'objects' => {
          'PARENT' => { 'children' => [ 'groupB', 'groupA' ] },
          'groupA' => { 'path' => 'A'  },
          'groupB' => { 'path' => 'B'  } 
        }
      }
    
      result = Xcunique::Sorter.new(project).sort
    
      assert_equal [ 'groupA', 'groupB' ], result['objects']['PARENT']['children']
    end
    
    it "sorts alphabetically by their name then path" do
      project = {
        'objects' => {
          'PARENT' => { 'children' => [ 'groupB', 'groupA' ] },
          'groupA' => { 'name' => 'A', 'path' => 'B'  },
          'groupB' => { 'name' => 'B', 'path' => 'A'  } 
        }
      }
    
      result = Xcunique::Sorter.new(project).sort
    
      assert_equal [ 'groupA', 'groupB' ], result['objects']['PARENT']['children']
    end
  end

  describe "when sorting files" do
    it "sorts alphabetically by their name" do
      project = {
        'objects' => {
          'PARENT'     => { 'files' => [ 'buildFileB', 'buildFileA' ] },
          'buildFileA' => { 'isa' => 'PBXBuildFile', 'fileRef' => 'fileA' },
          'buildFileB' => { 'isa' => 'PBXBuildFile', 'fileRef' => 'fileB' },
          'fileA'      => { 'name' => 'a.swift'  },
          'fileB'      => { 'name' => 'b.swift'  }
        }
      }

      result = Xcunique::Sorter.new(project).sort

      assert_equal [ 'buildFileA', 'buildFileB' ], result['objects']['PARENT']['files']
    end
    
    it "sorts alphabetically by their path" do
      project = {
        'objects' => {
          'PARENT'     => { 'files' => [ 'buildFileB', 'buildFileA' ] },
          'buildFileA' => { 'isa' => 'PBXBuildFile', 'fileRef' => 'fileA' },
          'buildFileB' => { 'isa' => 'PBXBuildFile', 'fileRef' => 'fileB' },
          'fileA'      => { 'path' => 'a.swift'  },
          'fileB'      => { 'path' => 'b.swift'  }
        }
      }

      result = Xcunique::Sorter.new(project).sort

      assert_equal [ 'buildFileA', 'buildFileB' ], result['objects']['PARENT']['files']
    end
    
    it "sorts alphabetically by their name then path" do
      project = {
        'objects' => {
          'PARENT'     => { 'files' => [ 'buildFileB', 'buildFileA' ] },
          'buildFileA' => { 'isa' => 'PBXBuildFile', 'fileRef' => 'fileA' },
          'buildFileB' => { 'isa' => 'PBXBuildFile', 'fileRef' => 'fileB' },
          'fileA'      => { 'name' => 'a.swift', 'path' => 'b/a.swift'  },
          'fileB'      => { 'name' => 'b.swift', 'path' => 'a/b.swift'  }
        }
      }

      result = Xcunique::Sorter.new(project).sort

      assert_equal [ 'buildFileA', 'buildFileB' ], result['objects']['PARENT']['files']
    end
  end
  
  describe "when sorting groups and files" do
    it "sorts groups before files" do
      project = {
        'objects' => {
          'PARENT'     => { 'children' => [ 'buildFileA', 'groupA' ] },
          'buildFileA' => { 'isa' => 'PBXBuildFile', 'fileRef' => 'fileA' },
          'groupA'     => { 'isa' => 'PBXGroup', 'name' => 'a' },
          'fileA'      => { 'name' => 'a' },
        }
      }
      
      result = Xcunique::Sorter.new(project).sort

      assert_equal [ 'groupA', 'buildFileA' ], result['objects']['PARENT']['children']
    end
  end

end
