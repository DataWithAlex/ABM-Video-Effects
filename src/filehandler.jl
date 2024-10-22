module FileHandler

using Images, VideoIO

export video_to_frames, frames_to_matrices, frames_to_video

function video_to_frames(video_path, output_folder, fps)
    println("Opening video file: ", video_path)
    
    # Open the video file using VideoIO
    reader = VideoIO.open(video_path)

    # Check if the reader is valid
    if reader === nothing
        println("Error: Could not open video file.")
        return []
    else
        println("Video opened successfully.")
    end

    # Use the correct method to access the first video stream
    stream = VideoIO.openvideo(video_path)

    # Print video properties
    println("Total frames in video: ", VideoIO.counttotalframes(stream))
    println("Video Resolution: ", VideoIO.width(stream), "x", VideoIO.height(stream))

    frames = []
    frame_count = 0

    # Read frames sequentially until the end of the video
    while !eof(stream)
        frame = VideoIO.read(stream)
        if frame === nothing
            println("Error: Could not read frame.")
            break
        end
        push!(frames, frame)
        frame_count += 1
    end

    println("Total frames extracted: ", frame_count)
    return frames
end

function frames_to_matrices(frames)
    # Convert the frames to RGB and HSV matrices
    rgb_matrices = [RGB.(frame) for frame in frames]
    hsb_matrices = [HSV.(rgb) for rgb in rgb_matrices]
    return rgb_matrices, hsb_matrices
end

# Updated function to handle video writing properly and converting frames to RGB{N0f8}
function frames_to_video(output_frames, output_path, fps)
    if length(output_frames) == 0
        println("Error: No frames to save.")
        return
    end

    # Convert frames from RGB{Float32} to RGB{N0f8} for video encoding
    output_frames_n0f8 = [RGB{N0f8}.(frame) for frame in output_frames]

    # Use the first frame to initialize the writer
    first_frame = output_frames_n0f8[1]
    encoder_options = (crf=23, preset="medium")
    VideoIO.open_video_out(output_path, first_frame; framerate=fps, encoder_options=encoder_options) do writer
        for frame in output_frames_n0f8
            VideoIO.write(writer, frame)
        end
        # Automatically closes the writer at the end of the block
    end

    println("Video saved successfully at: ", output_path)
end

end