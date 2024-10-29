module Distortion

using Images, Random, Logging

export distort_pixel, apply_distortion_to_image

# Configure logging with Debug level for detailed logging when needed
Logging.global_logger(SimpleLogger(stderr, Logging.Debug))

"""
    distort_pixel(rgb_pixel::RGB, hsb_pixel::HSV)

Applies a distortion to a given pixel based on its HSB value.
Returns a new RGB color with altered brightness and color channel.
"""
function distort_pixel(rgb_pixel::RGB, hsb_pixel::HSV)
    place_pixel = rand() < (1.2 * hsb_pixel.v - 0.2)
    if place_pixel
        indices = [rgb_pixel.r, rgb_pixel.g, rgb_pixel.b]
        max_index = argmax(indices)

        # Only log a debug message for channel modification if conditionally needed
        # @debug "Distorting pixel by setting max channel to full brightness at index: $max_index with HSB: $hsb_pixel"

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

"""
    apply_distortion_to_image(rgb_image, hsb_image)

Applies the distortion across an entire image by iterating through each pixel.
Returns a new image with distortions applied to the RGB channels.
"""
function apply_distortion_to_image(rgb_image, hsb_image)
    height, width = size(rgb_image)
    distorted_image = RGB.(zeros(Float32, height, width), zeros(Float32, height, width), zeros(Float32, height, width))

    @info "Applying distortion to image with dimensions: $(height)x$(width)"

    for y in 1:height
        for x in 1:width
            distorted_image[y, x] = distort_pixel(rgb_image[y, x], hsb_image[y, x])
        end

        # Log progress every 10 rows to avoid excessive output
        if y % 1080 == 0
            @debug "Processed row $y of $height"
        end
    end

    @info "Completed distortion on image."
    return distorted_image
end

end