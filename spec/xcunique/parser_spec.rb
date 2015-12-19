require_relative '../spec_helper'

describe Xcunique::Parser do
  
  before do
    @project = JSON.load(File.open(File.expand_path('../fixtures/TestProject.json', __dir__)))
    @parser  = Xcunique::Parser.new(@project)
  end
  
  let(:root_uuid)  { @project['rootObject']                      }
  let(:main_group) { @project['objects'][root_uuid]['mainGroup'] }
  
  it 'correctly parses files and groups' do
    
    @parser.parse object: main_group
    
    result = @parser.visited
    
    expectations = {
      
      # ├── Project
      "/PBXGroup" => 'DACE56891C24A14C00E6ABB0',
      
      # ├── TestProject
      #    ├── Products
      #    ├── TestProject
      #    ├── TestProjectTests
      #    ├── TestProjectUITests
      "/PBXGroup/PBXGroup(name: 'Products')"           => 'DACE56931C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(path: 'TestProject')"        => 'DACE56941C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(path: 'TestProjectTests')"   => 'DACE56A91C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(path: 'TestProjectUITests')" => 'DACE56B41C24A14D00E6ABB0',
      
      # ├── TestProject
      # │   ├── AppDelegate.swift
      # │   ├── Assets.xcassets
      # │   ├── Base.lproj
      # │   │   ├── LaunchScreen.storyboard
      # │   │   └── Main.storyboard
      # │   ├── Info.plist
      # │   └── ViewController.swift
      "/PBXGroup/PBXGroup(path: 'TestProject')/PBXFileReference(path: 'AppDelegate.swift')"                                                                                 => 'DACE56951C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(path: 'TestProject')/PBXFileReference(path: 'Assets.xcassets')"                                                                                   => 'DACE569C1C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(path: 'TestProject')/PBXVariantGroup(name: 'LaunchScreen.storyboard')"                                                                            => 'DACE569E1C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(path: 'TestProject')/PBXVariantGroup(name: 'LaunchScreen.storyboard')/PBXFileReference(name: 'Base', path: 'Base.lproj/LaunchScreen.storyboard')" => 'DACE569F1C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(path: 'TestProject')/PBXVariantGroup(name: 'Main.storyboard')"                                                                                    => 'DACE56991C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(path: 'TestProject')/PBXVariantGroup(name: 'Main.storyboard')/PBXFileReference(name: 'Base', path: 'Base.lproj/Main.storyboard')"                 => 'DACE569A1C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(path: 'TestProject')/PBXFileReference(path: 'Info.plist')"                                                                                        => 'DACE56A11C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(path: 'TestProject')/PBXFileReference(path: 'ViewController.swift')"                                                                              => 'DACE56971C24A14D00E6ABB0',
      
      # ├── TestProject
      #    ├── TestProjectTests
      #    │   ├── Info.plist
      #    │   └── TestProjectTests.swift
      "/PBXGroup/PBXGroup(path: 'TestProjectTests')/PBXFileReference(path: 'Info.plist')"             => 'DACE56AC1C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(path: 'TestProjectTests')/PBXFileReference(path: 'TestProjectTests.swift')" => 'DACE56AA1C24A14D00E6ABB0',
      
      # ├── TestProject
      #    └── TestProjectUITests
      #       ├── Info.plist
      #       └── TestProjectUITests.swift
      "/PBXGroup/PBXGroup(path: 'TestProjectUITests')/PBXFileReference(path: 'Info.plist')"               => 'DACE56B71C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(path: 'TestProjectUITests')/PBXFileReference(path: 'TestProjectUITests.swift')" => 'DACE56B51C24A14D00E6ABB0',
      
      # ├── TestProject
      #    └── Products
      #       ├── TestProject.app
      "/PBXGroup/PBXGroup(name: 'Products')/PBXFileReference(path: 'TestProject.app')"           => 'DACE56921C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(name: 'Products')/PBXFileReference(path: 'TestProjectTests.xctest')"   => 'DACE56A61C24A14D00E6ABB0',
      "/PBXGroup/PBXGroup(name: 'Products')/PBXFileReference(path: 'TestProjectUITests.xctest')" => 'DACE56B11C24A14D00E6ABB0',
    }
    
    expectations.each do |path, uuid|
      assert_equal path, result[uuid]
    end
    
    assert_equal [], result.keys - expectations.values
    
  end
  
  it 'correctly parses the remaining project objects' do
    
    @parser.parse(object: main_group)
    files_and_groups = @parser.visited.keys
    
    @parser.parse(object: root_uuid)
    result = @parser.visited.reject { |key, _| files_and_groups.include?(key) }
    
    expectations = {
      
      # ├── mainGroup
      "/PBXProject" => "DACE568A1C24A14C00E6ABB0",
      
      # ├── mainGroup
      #    └── ProjectConfigurations
      #       ├── Debug
      #       ├── Release
      "/PBXProject/XCConfigurationList"                                       => "DACE568D1C24A14C00E6ABB0",
      "/PBXProject/XCConfigurationList/XCBuildConfiguration(name: 'Debug')"   => "DACE56B81C24A14D00E6ABB0",
      "/PBXProject/XCConfigurationList/XCBuildConfiguration(name: 'Release')" => "DACE56B91C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProject
      #       └── Configurations
      #          ├── Debug
      #          ├── Release
      "/PBXProject/PBXNativeTarget(name: 'TestProject')"                                                           => "DACE56911C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProject')/XCConfigurationList"                                       => "DACE56BA1C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProject')/XCConfigurationList/XCBuildConfiguration(name: 'Debug')"   => "DACE56BB1C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProject')/XCConfigurationList/XCBuildConfiguration(name: 'Release')" => "DACE56BC1C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProject
      #       └── Build Sources
      #          ├── ViewController.swift
      #          ├── AppDelegate.swift
      "/PBXProject/PBXNativeTarget(name: 'TestProject')/PBXSourcesBuildPhase"                                            => "DACE568E1C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProject')/PBXSourcesBuildPhase/PBXBuildFile(path: 'ViewController.swift')" => "DACE56981C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProject')/PBXSourcesBuildPhase/PBXBuildFile(path: 'AppDelegate.swift')"    => "DACE56961C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProject
      #       └── Copy Frameworks
      "/PBXProject/PBXNativeTarget(name: 'TestProject')/PBXFrameworksBuildPhase" => "DACE568F1C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProject
      #       └── Copy Resources
      #          ├── LaunchScreen.storyboard
      #          ├── Assets.xcassets
      #          ├── Main.storyboard
      "/PBXProject/PBXNativeTarget(name: 'TestProject')/PBXResourcesBuildPhase"                                               => "DACE56901C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProject')/PBXResourcesBuildPhase/PBXBuildFile(name: 'LaunchScreen.storyboard')" => "DACE56A01C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProject')/PBXResourcesBuildPhase/PBXBuildFile(path: 'Assets.xcassets')"         => "DACE569D1C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProject')/PBXResourcesBuildPhase/PBXBuildFile(name: 'Main.storyboard')"         => "DACE569B1C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProjectTests
      #       └── Configurations
      #          ├── Debug
      #          ├── Release
      "/PBXProject/PBXNativeTarget(name: 'TestProjectTests')"                                                           => "DACE56A51C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProjectTests')/XCConfigurationList"                                       => "DACE56BD1C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProjectTests')/XCConfigurationList/XCBuildConfiguration(name: 'Debug')"   => "DACE56BE1C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProjectTests')/XCConfigurationList/XCBuildConfiguration(name: 'Release')" => "DACE56BF1C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProjectTests
      #       └── Build Sources
      #          ├── TestProjectTests.swift
      "/PBXProject/PBXNativeTarget(name: 'TestProjectTests')/PBXSourcesBuildPhase"                                              => "DACE56A21C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProjectTests')/PBXSourcesBuildPhase/PBXBuildFile(path: 'TestProjectTests.swift')" => "DACE56AB1C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProjectTests
      #       └── Copy Frameworks
      "/PBXProject/PBXNativeTarget(name: 'TestProjectTests')/PBXFrameworksBuildPhase" => "DACE56A31C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProjectTests
      #       └── Copy Resources
      "/PBXProject/PBXNativeTarget(name: 'TestProjectTests')/PBXResourcesBuildPhase" => "DACE56A41C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProjectTests
      #       └── Dependencies
      #          ├── TestProject
      "/PBXProject/PBXNativeTarget(name: 'TestProjectTests')/PBXTargetDependency"                       => "DACE56A81C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProjectTests')/PBXTargetDependency/PBXContainerItemProxy" => "DACE56A71C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProjectUITests
      #       └── Configurations
      #          ├── Debug
      #          ├── Release
      "/PBXProject/PBXNativeTarget(name: 'TestProjectUITests')"                                                           => "DACE56B01C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProjectUITests')/XCConfigurationList"                                       => "DACE56C01C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProjectUITests')/XCConfigurationList/XCBuildConfiguration(name: 'Debug')"   => "DACE56C11C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProjectUITests')/XCConfigurationList/XCBuildConfiguration(name: 'Release')" => "DACE56C21C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProjectUITests
      #       └── Build Sources
      #          ├── TestProjectUITests.swift
      "/PBXProject/PBXNativeTarget(name: 'TestProjectUITests')/PBXSourcesBuildPhase"                                                => "DACE56AD1C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProjectUITests')/PBXSourcesBuildPhase/PBXBuildFile(path: 'TestProjectUITests.swift')" => "DACE56B61C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProjectUITests
      #       └── Copy Frameworks
      "/PBXProject/PBXNativeTarget(name: 'TestProjectUITests')/PBXFrameworksBuildPhase" => "DACE56AE1C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProjectUITests
      #       └── Copy Resources
      "/PBXProject/PBXNativeTarget(name: 'TestProjectUITests')/PBXResourcesBuildPhase" => "DACE56AF1C24A14D00E6ABB0",
      
      # ├── mainGroup
      #    └── Target = TestProjectUITests
      #       └── Dependencies
      #          ├── TestProject
      "/PBXProject/PBXNativeTarget(name: 'TestProjectUITests')/PBXTargetDependency" => "DACE56B31C24A14D00E6ABB0",
      "/PBXProject/PBXNativeTarget(name: 'TestProjectUITests')/PBXTargetDependency/PBXContainerItemProxy" => "DACE56B21C24A14D00E6ABB0"
    }
    
    expectations.each do |path, uuid|
      assert_equal path, result[uuid]
    end
    
    assert_equal [], result.keys - expectations.values
    
  end
  
end
