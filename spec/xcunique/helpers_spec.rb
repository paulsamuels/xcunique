require_relative '../spec_helper'

describe Xcunique::Helpers do

  describe 'Helpers.resolve_attributes' do

    it "returns an empty string if no name, path or fileRef are found" do
      objects = {
        'aaaa' => {}
      }

      assert_equal '', Xcunique::Helpers.resolve_attributes('aaaa', objects)
    end

    it 'returns the name if found on the object' do
      objects = {
        'aaaa' => {
          'name' => 'Test'
        }
      }

      assert_equal "(name: 'Test')", Xcunique::Helpers.resolve_attributes('aaaa', objects)
    end

    it 'returns the path if found on the object' do
      objects = {
        'aaaa' => {
          'path' => 'Test'
        }
      }

      assert_equal "(path: 'Test')", Xcunique::Helpers.resolve_attributes('aaaa', objects)
    end

    it 'returns the name and path if found on the object' do
      objects = {
        'aaaa' => {
          'name' => 'Test',
          'path' => 'Test'
        }
      }

      assert_equal "(name: 'Test', path: 'Test')", Xcunique::Helpers.resolve_attributes('aaaa', objects)
    end

    it 'resolves the fileRef if there is one' do
      objects = {
        'aaaa' => {
          'fileRef' => 'bbbb'
        },
        'bbbb' => {
          'name' => 'Test',
          'path' => 'Test'
        }
      }

      assert_equal "(name: 'Test', path: 'Test')", Xcunique::Helpers.resolve_attributes('aaaa', objects)
    end

  end

  describe 'Helpers.canonical_name' do

    it 'defaults to using the name' do
      objects = {
        'aaaa' => {
          'name' => 'Test',
          'path' => 'Path'
        }
      }

      assert_equal "Test", Xcunique::Helpers.canonical_name('aaaa', objects)
    end

    it 'falls back to path if no name is present' do
      objects = {
        'aaaa' => {
          'path' => 'Path'
        }
      }

      assert_equal "Path", Xcunique::Helpers.canonical_name('aaaa', objects)
    end

    it 'uses the last path component' do
      objects = {
        'aaaa' => {
          'path' => 'Path/Component'
        }
      }

      assert_equal "Component", Xcunique::Helpers.canonical_name('aaaa', objects)
    end

  end

end
