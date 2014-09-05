module Epos
  class EncodedFile

    def initialize(path)
      @io = File.open(path, "rb")
    end

    def read(length = nil)
      self.decipher(@io.read(length)).encode("utf-8", "iso-8859-1")
    end

    def seek(pos)
      @io.seek(pos)
    end

    def close
      @io.close
    end

    def eof?
      @io.eof?
    end

    def self.read(path, length = nil)
      file = EncodedFile.new(path)
      data = file.read(length)
      file.close
      return data
    end

    protected

    def decipher(data)
      data.bytes.map{|b| b = (b + 0x0b) % 255; b == 11 ? 10 : b}.pack("C*")
    end

  end
end
