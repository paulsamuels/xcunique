module Xcunique
  module Keys
    CHILDREN     = 'children'
    FILE_REF     = 'fileRef'
    FILES        = 'files'
    ISA          = 'isa'
    MAIN_GROUP   = 'mainGroup'
    NAME         = 'name'
    OBJECTS      = 'objects'
    PATH         = 'path'
    PBXGroup     = 'PBXGroup'
    PBXProject   = 'PBXProject'
    ROOT_OBJECT  = 'rootObject'
  end
end

require "xcunique/cli"
require 'xcunique/hash_ext'
require 'xcunique/helpers'
require "xcunique/options"
require "xcunique/parser"
require "xcunique/sorter"
require "xcunique/uniquifier"
require "xcunique/version"
