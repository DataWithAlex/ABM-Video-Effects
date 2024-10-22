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