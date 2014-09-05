require 'epos/encoded-file.rb'

module Epos

  class DataFile

    def initialize(path)
      @file = EncodedFile.new(path)
    end

    def read_entry(pos)
      @file.seek(pos + 1)
      s = "*"
      while !@file.eof?
        t = @file.read(1024)
        break if t == nil || t == ""
        s << t
        i = s.index("\n*")
        if i
          s = s[0..i]
          break
        end
      end
      return s
    end

  end
end
