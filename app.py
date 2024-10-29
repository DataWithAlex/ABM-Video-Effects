import streamlit as st
import requests
import os

# Define paths and server URL
INPUT_VIDEO_PATH = "input/uploaded_video.mp4"
OUTPUT_VIDEO_PATH = "output/distorted_clip1.mp4"
JULIA_SERVER_URL = "http://3.142.218.184:8000/process_video"  # EC2 public IP and server endpoint

# Streamlit UI for file upload
st.title("Agent-Based Modeling Video Distortion")
st.write("Upload a video to apply ABM-based distortions using Julia.")

# Upload video file
uploaded_file = st.file_uploader("Choose a video file", type=["mp4"])

if uploaded_file is not None:
    # Save the uploaded video to the input directory
    with open(INPUT_VIDEO_PATH, "wb") as f:
        f.write(uploaded_file.getbuffer())
    st.success("Video uploaded successfully!")

    # Send the video file path to the Julia server
    st.write("Processing video with Julia server...")
    try:
        # Send a request to the Julia server
        response = requests.post(JULIA_SERVER_URL, json={"video_path": INPUT_VIDEO_PATH})
        response_data = response.json()

        if response_data.get("success"):
            st.success("Video processed successfully!")
            output_path = response_data.get("output_path")

            # Display the output video
            if os.path.exists(output_path):
                st.video(output_path)
            else:
                st.error("Processed video file not found.")
        else:
            st.error("Julia server returned an error:")
            st.error(response_data.get("message"))
    except Exception as e:
        st.error(f"An error occurred while contacting the Julia server: {e}")

# Clean up files after processing
if st.button("Clear"):
    if os.path.exists(INPUT_VIDEO_PATH):
        os.remove(INPUT_VIDEO_PATH)
    if os.path.exists(OUTPUT_VIDEO_PATH):
        os.remove(OUTPUT_VIDEO_PATH)
    st.success("Temporary files removed.")