using Genie.Router
using Genie.Renderer.Json
using FileHandler
using Distortion
using ABMModel
using Utils

include("../filehandler.jl")
include("../distortion.jl")
include("../abm_model.jl")
include("../utils.jl")

route("/", method = "GET") do
    json(success = true, message = "Welcome to the ABM Video Distortion API")
end

route("/process_video", method = "POST") do
    # Extract the uploaded video path from the request
    video_path = getpayload()["video_path"]
    output_path = "output/distorted_clip1.mp4"
    output_frames_folder = "output/distorted_frames/"
    fps = 30

    # Process video using the functions from the included modules
    frames = FileHandler.video_to_frames(video_path, output_frames_folder, fps)

    if !isempty(frames)
        rgb_matrices, hsb_matrices = FileHandler.frames_to_matrices(frames)
        distorted_frames = [Distortion.apply_distortion_to_image(rgb, hsb) for (rgb, hsb) in zip(rgb_matrices, hsb_matrices)]
        FileHandler.frames_to_video(distorted_frames, output_path, fps)
        return json(success = true, message = "Video processed successfully", output_path = output_path)
    else
        return json(success = false, message = "Failed to process video.")
    end
end