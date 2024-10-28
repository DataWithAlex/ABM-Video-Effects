using Genie
using Genie.Router
using Genie.Renderer.Json
using VideoIO
using Images

# Include local module files before using them
include("filehandler.jl")
include("distortion.jl")

# Use the modules after they have been included
using .FileHandler
using .Distortion

# Define the route for processing videos
route("/") do
    json(Dict("success" => true, "message" => "Welcome to the ABM Video Distortion API"))
end

route("/process_video", method = POST) do
    try
        # Get the video path from the request payload and resolve its absolute path
        video_path = abspath(Genie.Requests.jsonpayload()["video_path"])
        output_path = abspath("output/distorted_clip1.mp4")
        output_frames_folder = abspath("output/distorted_frames/")
        fps = 30

        println("Starting video processing for: ", video_path)

        # Ensure the output directory exists
        if !isdir(output_frames_folder)
            mkpath(output_frames_folder)
            println("Created output frames directory: ", output_frames_folder)
        end

        # Check if the video file exists
        if !isfile(video_path)
            println("Error: Video file not found at path: ", video_path)
            return json(Dict("success" => false, "message" => "Video file not found at the provided path."))
        end

        # Load video and extract frames
        frames = FileHandler.video_to_frames(video_path, output_frames_folder, fps)
        println("Total frames extracted: ", length(frames))

        if isempty(frames)
            println("No frames were extracted from the video.")
            return json(Dict("success" => false, "message" => "Failed to extract frames from the video."))
        end

        # Convert frames to RGB and HSB matrices (for distortion purposes)
        rgb_matrices, hsb_matrices = FileHandler.frames_to_matrices(frames)
        println("Converted frames to RGB and HSB matrices.")

        # Apply distortions to the video frames (modify as needed)
        distorted_frames = [Distortion.apply_distortion_to_image(rgb, hsb) for (rgb, hsb) in zip(rgb_matrices, hsb_matrices)]
        println("Applied distortions to frames.")

        # Save the distorted frames as a video
        FileHandler.frames_to_video(distorted_frames, output_path, fps)
        println("Saved distorted video to: ", output_path)

        # Return a successful JSON response with the path to the processed video
        return json(Dict("success" => true, "message" => "Video processed successfully", "output_path" => output_path))
    catch e
        println("Error during video processing: ", e)
        return json(Dict("success" => false, "error" => string(e)))
    end
end

# Start the Genie server on port 8000, bound to 0.0.0.0
up(host = "0.0.0.0", port = 8000)