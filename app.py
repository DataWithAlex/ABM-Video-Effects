import streamlit as st
import subprocess
import os

# Define paths
JULIA_SCRIPT_PATH = "src/main.jl"  # Update if the path differs
INPUT_VIDEO_PATH = "input/uploaded_video.mp4"
OUTPUT_VIDEO_PATH = "output/distorted_clip1.mp4"

# Streamlit UI for file upload
st.title("Agent-Based Modeling Video Distortion")
st.write("Upload a video to apply ABM-based distortions using Julia.")

uploaded_file = st.file_uploader("Choose a video file", type=["mp4"])

if uploaded_file is not None:
    # Save the uploaded video to the input directory
    with open(INPUT_VIDEO_PATH, "wb") as f:
        f.write(uploaded_file.getbuffer())
    st.success("Video uploaded successfully!")

    # Run the Julia script to process the video
    st.write("Processing video with Julia...")
    try:
        # Run the Julia script using subprocess
        result = subprocess.run(
            ["julia", JULIA_SCRIPT_PATH],
            capture_output=True,
            text=True
        )
        if result.returncode == 0:
            st.success("Video processed successfully!")
            # Display the output video
            st.video(OUTPUT_VIDEO_PATH)
        else:
            st.error("Julia script failed with error:")
            st.error(result.stderr)
    except Exception as e:
        st.error(f"An error occurred while processing the video: {e}")

# Clean up after processing
if st.button("Clear"):
    if os.path.exists(INPUT_VIDEO_PATH):
        os.remove(INPUT_VIDEO_PATH)
    if os.path.exists(OUTPUT_VIDEO_PATH):
        os.remove(OUTPUT_VIDEO_PATH)
    st.success("Temporary files removed.")