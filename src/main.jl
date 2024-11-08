using Genie
using Genie.Router
using Genie.Renderer.Json
using VideoIO
using Images
using Logging
using AWSS3  # Ensure AWSS3.jl is installed and this import is included

# Configure logging
Logging.global_logger(SimpleLogger(stderr, Logging.Debug))

# Include local module files before using them
include("filehandler.jl")
include("distortion.jl")

# Use the modules after they have been included
using .FileHandler
using .Distortion

# Define the S3 bucket
const BUCKET_NAME = "abvdm-video-bucket"

# Define the route for the API root
route("/") do
    @info "Root route accessed"
    json(Dict("success" => true, "message" => "Welcome to the ABM Video Distortion API"))
end

# Define the route for processing videos
route("/process_video", method = POST) do
    @info "Video processing route accessed"
    try
        # Check if S3 key is provided
        payload = Genie.Requests.jsonpayload()
        if haskey(payload, "s3_key")
            s3_key = payload["s3_key"]
            video_path = abspath("output/temp_uploaded_video.mp4")
            @info "Downloading video from S3 key: $s3_key to local path: $video_path"

            # Download the file from S3
            s3_get_object(BUCKET_NAME, s3_key, video_path)
        else
            video_path = abspath(payload["video_path"])
        end

        output_path = abspath("output/distorted_clip1.mp4")
        output_frames_folder = abspath("output/distorted_frames/")
        fps = 30

        @info "Starting video processing for path: $video_path"

        # Ensure the output directory exists
        if !isdir(output_frames_folder)
            mkpath(output_frames_folder)
            @info "Created output frames directory: $output_frames_folder"
        end

        # Check if the video file exists
        if !isfile(video_path)
            @error "Video file not found at path: $video_path"
            return json(Dict("success" => false, "message" => "Video file not found at the provided path."))
        end

        # Step 1: Load video and extract frames
        @info "Loading video and extracting frames..."
        frames = FileHandler.video_to_frames(video_path, output_frames_folder, fps)
        @info "Total frames extracted: $(length(frames))"

        if isempty(frames)
            @error "No frames were extracted from the video."
            return json(Dict("success" => false, "message" => "Failed to extract frames from the video."))
        end

        # Step 2: Convert frames to RGB and HSB matrices (for distortion purposes)
        @info "Converting frames to RGB and HSB matrices..."
        rgb_matrices, hsb_matrices = FileHandler.frames_to_matrices(frames)
        @info "Converted frames to RGB and HSB matrices."

        # Step 3: Apply distortions to the video frames
        @info "Applying distortions to frames..."
        distorted_frames = [Distortion.apply_distortion_to_image(rgb, hsb) for (rgb, hsb) in zip(rgb_matrices, hsb_matrices)]
        @info "Distortions applied to frames."

        # Step 4: Save the distorted frames as a video
        @info "Saving distorted frames to video at $output_path..."
        FileHandler.frames_to_video(distorted_frames, output_path, fps)
        @info "Distorted video saved successfully at $output_path."

        # Return a successful JSON response with the path to the processed video
        return json(Dict("success" => true, "message" => "Video processed successfully", "output_path" => output_path))
    
    catch e
        @error "Error during video processing: $e"
        return json(Dict("success" => false, "error" => string(e)))
    end
end

# Start the Genie server on port 8080, bound to 0.0.0.0
@info "Starting Genie server on http://0.0.0.0:8080"
up(host = "0.0.0.0", port = 8080)