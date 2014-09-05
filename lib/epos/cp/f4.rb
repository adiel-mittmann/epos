# -*- coding: utf-8 -*-
module Epos
  # "y" is used in two entries: "evonim-" and "mormir(o)-".  In both cases, it
  # is shown as a "y" with something weird below.  In the first entry, it is
  # used to represent the *short* "y" in "euonymus"; in the second, the *long*
  # "y" in "mormyr".  So...
  class CodePage
    F4_MAP = {
      "H" => "ʰ",
      "N" => "ⁿ",
      "T" => "ᵗ",
      "S" => "ˢ",
      "J" => "ʲ",
      "ï" => "ï",
      "D" => "ᵈ",
      "y" => "y",
    }
  end
end
