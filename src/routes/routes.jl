# routes.jl
using Genie.Router
using Genie.Renderer.Json
using Genie.Requests
using Genie.Response
using Logging

include("src/filehandler.jl")
include("src/distortion.jl")
include("src/abm_model.jl")
include("src/utils.jl")

# Configure logging level
Logging.global_logger(SimpleLogger(stderr, Logging.Debug))

# Home route
route("/", method = "GET") do
    @info "Home route accessed"
    json(Dict("success" => true, "message" => "Welcome to the ABM Video Distortion API"))
end

# Process video route
route("/process_video", method = "POST") do
    @info "Processing video route accessed"
    try
        video_path = params(:video_path)
        output_path = "./output/distorted_clip1.mp4"
        output_frames_folder = "./output/distorted_frames/"
        fps = 30

        @info "Extracting frames from video"
        frames = FileHandler.video_to_frames(video_path, output_frames_folder, fps)
        
        if isempty(frames)
            @error "No frames extracted"
            return json(Dict("success" => false, "message" => "Failed to extract frames from video."))
        end

        @info "Applying distortion to frames"
        distorted_frames = [
            Distortion.apply_distortion_to_image(rgb, hsb)
            for (rgb, hsb) in zip(FileHandler.frames_to_matrices(frames)...)
        ]
        
        FileHandler.frames_to_video(distorted_frames, output_path, fps)
        @info "Video processing complete. Output saved at $output_path"
        json(Dict("success" => true, "message" => "Video processed successfully", "output_path" => output_path))
    catch e
        @error "Error in video processing: $e"
        json(Dict("success" => false, "error" => string(e)))
    end
end