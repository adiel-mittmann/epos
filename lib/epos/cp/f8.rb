# -*- coding: utf-8 -*-
module Epos
  class CodePage
    # Characters in this page produce a line above some of the characters that
    # precede them.  Their purpose is to indicate the pitch in Japanese words.
    # Lowercase letters indicate that the pitch remains the same, uppercase that
    # it drops.  The closer a letter is to the beginning of the alphabet, the
    # shorter the line that it produces.
    #
    # The length of the line does not match well letter boundaries.  It's
    # difficult to establish how many letters should be affected.
    F8_MAP = {
      "c" => "",
      "d" => "",
      "e" => "",
      "f" => "",
      "h" => "",
      "j" => "",

      "A" => "˺",
      "C" => "˺",
      "D" => "˺",
      "E" => "˺",
      "F" => "˺",
      "G" => "˺",
      "H" => "˺",
    }
  end
end
