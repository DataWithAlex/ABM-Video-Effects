module FileHandler

using Images, VideoIO, Logging

export video_to_frames, frames_to_matrices, frames_to_video

# Configure logging
Logging.global_logger(SimpleLogger(stderr, Logging.Debug))

"""
    video_to_frames(video_path, output_folder, fps)

Converts a video into individual frames, stored in an array.
"""
function video_to_frames(video_path, output_folder, fps)
    @info "Attempting to open video file: $(video_path)"

    # Open the video file using VideoIO
    reader = VideoIO.open(video_path)

    # Check if the reader is valid
    if reader === nothing
        @error "Could not open video file."
        return []
    else
        @info "Video opened successfully."
    end

    # Access the first video stream
    stream = VideoIO.openvideo(video_path)

    # Print video properties
    total_frames = VideoIO.counttotalframes(stream)
    width = VideoIO.width(stream)
    height = VideoIO.height(stream)
    @info "Total frames in video: $(total_frames)"
    @info "Video resolution: $(width)x$(height)"

    frames = []

    # Read frames sequentially until the end of the video
    frame_counter = 0
    while !eof(stream)
        frame = VideoIO.read(stream)
        if frame === nothing
            @error "Could not read frame."
            break
        end
        push!(frames, frame)
        frame_counter += 1

        # Log every 10 frames to show progress
        if frame_counter % 10 == 0
            @debug "Extracted frame $(frame_counter)"
        end
    end

    @info "Total frames extracted: $(frame_counter)"
    return frames
end

"""
    frames_to_matrices(frames)

Converts each frame into RGB and HSB matrices for further processing.
"""
function frames_to_matrices(frames)
    @info "Converting frames to RGB and HSB matrices"
    rgb_matrices = [RGB.(frame) for frame in frames]
    hsb_matrices = [HSV.(rgb) for rgb in rgb_matrices]
    @info "Converted $(length(frames)) frames to RGB and HSB matrices"
    return rgb_matrices, hsb_matrices
end

"""
    frames_to_video(output_frames, output_path, fps)

Compiles a sequence of frames into a video saved at the specified output path.
"""
function frames_to_video(output_frames, output_path, fps)
    if isempty(output_frames)
        @error "No frames to save."
        return
    end

    @info "Starting video compilation with $(length(output_frames)) frames"
    output_frames_n0f8 = [RGB{N0f8}.(frame) for frame in output_frames]

    # Use the first frame to initialize the writer
    first_frame = output_frames_n0f8[1]
    encoder_options = (crf=23, preset="medium")

    VideoIO.open_video_out(output_path, first_frame; framerate=fps, encoder_options=encoder_options) do writer
        for (i, frame) in enumerate(output_frames_n0f8)
            VideoIO.write(writer, frame)
            # Log every 10 frames written to the video
            if i % 10 == 0
                @debug "Wrote frame $(i) to video"
            end
        end
    end

    @info "Video saved successfully at: $(output_path)"
end

end