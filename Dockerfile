# Start from a C++ build image
FROM ubuntu:20.04

# Install required dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libboost-all-dev \
    cmake \
    libcurl4-openssl-dev \
    libjsoncpp-dev \
    libgtest-dev

# Copy the source code to the container
COPY . /app

# Set the working directory
WORKDIR /app

# Create and build the application
RUN make

# Expose port for HTTP server
EXPOSE 8080

# Run the server
CMD ["./httpServer"]
