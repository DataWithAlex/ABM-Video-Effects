module Distortion

using Images, Random

export distort_pixel, apply_distortion_to_image

function distort_pixel(rgb_pixel::RGB, hsb_pixel::HSV)
    place_pixel = rand() < (1.2 * hsb_pixel.v - 0.2)
    if place_pixel
        indices = [rgb_pixel.r, rgb_pixel.g, rgb_pixel.b]
        max_index = argmax(indices)

        # Set the max channel to full brightness (1.0) and others to 0.0
        if max_index == 1
            return RGB(1.0, 0.0, 0.0)  # Red
        elseif max_index == 2
            return RGB(0.0, 1.0, 0.0)  # Green
        else
            return RGB(0.0, 0.0, 1.0)  # Blue
        end
    else
        return RGB(0.0, 0.0, 0.0)  # Set the pixel to black
    end
end

function apply_distortion_to_image(rgb_image, hsb_image)
    height, width = size(rgb_image)[1], size(rgb_image)[2]
    distorted_image = RGB.(zeros(Float32, height, width), zeros(Float32, height, width), zeros(Float32, height, width))

    for y in 1:height, x in 1:width
        distorted_image[y, x] = distort_pixel(rgb_image[y, x], hsb_image[y, x])
    end

    return distorted_image
end

end