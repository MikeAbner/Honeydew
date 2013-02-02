class Group

COLORS = [
            "clear", 
            "yellow_pastel", "natural_pastel", "orange_pastel", "pink_pastel", "purple_pastel", "blue_pastel", "green_pastel", 
            "grey_monochrome", "light-grey_monochrome", "mid-grey_monochrome", "dark-grey_monochrome",
            "purple_dark", "red_dark", "gold_dark", "green_dark", "orange_dark", "pink_dark", "blue_dark",
            "red_bright", "yellow_bright", "green_bright", "orange_bright", "pink_bright", "purple_bright", "blue_bright"
          ]

  def self.color_for member
    case member
    when 'me'
      "orange_pastel"
    when 'them'
      "purple_bright"
    else
      "clear"
    end
  end
end