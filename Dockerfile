# Use the official Julia image as the base
FROM julia:1.11

# Set environment variables for Genie to bind to all interfaces (0.0.0.0) rather than just localhost
ENV HOST=0.0.0.0
ENV PORT=8080

# Set the working directory in the container
WORKDIR /app

# Copy the project files into the container
COPY . /app

# Install any required Julia packages
RUN julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'

# Expose the port that Genie uses
EXPOSE 8080

# Run the Julia application, starting the Genie server
CMD ["julia", "--project=.", "-e", "include(\"src/main.jl\")"]