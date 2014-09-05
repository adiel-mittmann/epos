require 'epos/index-file.rb'
require 'epos/data-file.rb'

module Epos
  class IndexedDataFile

    def initialize(index_path, data_path)
      @index = IndexFile.new(index_path)
      @data  = DataFile.new(data_path)
    end

    def look_up(key)
      @index.look_up(key).map{|pos| @data.read_entry(pos)}
    end

    def keys
      @index.keys
    end

    def has_key?(key)
      @index.has_key?(key)
    end

  end
end
