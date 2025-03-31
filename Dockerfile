# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies including Boost and build tools
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    g++ \
    wget \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy your source code and Makefile into the container
COPY . /app

# Build the project using the Makefile
RUN make

# Expose the port that your HTTP server is listening on
EXPOSE 8080

# Run the server executable (replace with your actual executable name if different)
CMD ["./my_program"]
