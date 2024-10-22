using Distortion
using FileHandler
using ABMModel
using Utils

# Parameters
video_path = "input/input_video.mp4"
output_path = "output/output_video.mp4"
fps = 8

# Step 1: Convert video to frames
frames = FileHandler.video_to_frames(video_path, "input", fps)

# Step 2: Convert frames to matrices
rgb_matrices, hsb_matrices = FileHandler.frames_to_matrices(frames)

# Step 3: Create Agent-Based Model from the first frame
model = ABMModel.create_model(rgb_matrices[1])

# Step 4: Run the agent model (e.g., 10 steps)
ABMModel.run_model(model, 10)

# Step 5: Apply distortion to video
distorted_frames = [Distortion.apply_distortion_to_image(rgb, hsb) for (rgb, hsb) in zip(rgb_matrices, hsb_matrices)]

# Step 6: Save distorted video
FileHandler.frames_to_video(distorted_frames, output_path, fps)