# Video Distortion and Agent-Based Modeling Project

This project implements video frame extraction, distortion effects, and video reassembly using Julia. It also includes an agent-based modeling (ABM) component using `Agents.jl` to simulate complex systems on the extracted frames.

## Features

- **Video Frame Extraction**: Extracts frames from an input video file.
- **Frame Distortion**: Applies a custom distortion effect on each frame using both RGB and HSV color spaces.
- **Reassemble Video**: Reassembles distorted frames into a new video file.
- **Agent-Based Modeling (ABM)**: An ABM framework to simulate dynamic effects on video frames.

## Table of Contents

- [Project Structure](#project-structure)
- [Requirements](#requirements)
- [Setup Instructions](#setup-instructions)
- [How It Works](#how-it-works)
- [How to Run](#how-to-run)
- [Customizing the Distortion](#customizing-the-distortion)
- [Contributing](#contributing)
- [License](#license)

---

## Project Structure

The project is organized as follows:

```
├── ABM/
│   ├── src/
│   │   ├── abm_model.jl      # Agent-Based Modeling (ABM) code
│   │   ├── distortion.jl     # Distortion effects logic
│   │   ├── filehandler.jl    # Video I/O functions (frame extraction, video reassembly)
│   │   ├── utils.jl          # Utility functions for frame manipulation
│   └── notebooks/
│       ├── main_notebook.ipynb  # Main notebook for video distortion and ABM
├── input/
│   └── converted_clip1.mp4   # Sample input video file
├── output/
│   ├── frames/               # Extracted frames
│   ├── distorted_frames/     # Distorted frames
│   └── distorted_clip1.mp4   # Output video with distorted frames
├── Project.toml              # Project dependencies
├── Manifest.toml             # Dependency versions and environment settings
└── README.md                 # This README file
```

---

## Requirements

To run this project, you will need:

- **Julia v1.7 or higher**
- The following Julia packages:
  - `Images`
  - `VideoIO`
  - `Agents`
  - `Random`

The environment will be set up automatically using `Project.toml` and `Manifest.toml`.

---

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/abm-video-distortion.git
cd abm-video-distortion
```

### 1. Install Julia packages

Julia will handle dependencies via `Project.toml` and `Manifest.toml`. You can activate the environment and install dependencies by running the following commands in the Julia REPL:

```bash
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

This will install all required packages, such as Images, VideoIO, and Agents.

## How It Works

### Video Processing

1.	Frame Extraction: The FileHandler module extracts frames from the input video file using the video_to_frames function.
2.	Frame Distortion: A distortion effect is applied to each extracted frame via the Distortion module’s apply_distortion_to_image function. The distortion manipulates the pixel colors based on their HSV values.
3.	Reassemble Video: The distorted frames are reassembled into a new video file using the frames_to_video function in the FileHandler module.

### Agent-Based Modeling (ABM)

Although not the main focus in this initial phase, the project includes an abm_model.jl file to simulate agent-based modeling (ABM) over video frames. This ABM framework is designed for further expansion.

## How to Run

Running the Video Distortion

1.	Extract Frames and Apply Distortion

To extract frames from the input video, apply distortion, and reassemble the video, you can run the main_notebook.ipynb in the notebooks/ folder or the following script:

```bash
# Activate environment
using Pkg
Pkg.activate(".")

# Include necessary files
include("src/filehandler.jl")
include("src/distortion.jl")

# Set paths
video_path = "input/converted_clip1.mp4"
output_path = "output/distorted_clip1.mp4"
output_frames_folder = "output/distorted_frames/"
fps = 30  # Frames per second

# Extract frames, apply distortion, and save video
frames = FileHandler.video_to_frames(video_path, output_frames_folder, fps)
distorted_frames = [Distortion.apply_distortion_to_image(rgb, hsb) for (rgb, hsb) in FileHandler.frames_to_matrices(frames)]
FileHandler.frames_to_video(distorted_frames, output_path, fps)
```

## View Results

After running the code, the following will be generated:

- Extracted Frames: Located in output/frames/
- Distorted Frames: Located in output/distorted_frames/
- Distorted Video: Saved as output/distorted_clip1.mp4
