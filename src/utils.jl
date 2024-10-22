module Utils

export convert_rgb_to_hsb

using Colors

function convert_rgb_to_hsb(rgb_image)
    hsb_image = HSV.(rgb_image)
    return hsb_image
end

end