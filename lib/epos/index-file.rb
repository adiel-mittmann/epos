require 'epos/encoded-file.rb'

module Epos
  class IndexFile

    def initialize(path)
      data = EncodedFile.read(path)
      lines = data.lines
      @index = {}
      lines.each do |line|
        i = line.index(";")
        key = line[0..i - 1]
        val = line[i + 1..-2].to_i
        if @index.has_key?(key)
          @index[key] << val
        else
          @index[key] = [val]
        end
      end
    end

    def look_up(key)
      return @index[key] || []
    end

    def keys
      return @index.keys
    end

    def has_key?(key)
      @index.has_key?(key)
    end

  end
end
