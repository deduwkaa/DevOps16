# Step 1: Use an official Ubuntu image to build the software
FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for building the software and configure timezone
RUN apt-get update && \
    apt-get install -y \
    git \
    build-essential \
    cmake \
    g++ \
    wget \
    libboost-all-dev \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Clone the repository from GitHub
RUN git clone -b branchHTTPserver https://github.com/deduwkaa/DevOps16.git /src

# Set working directory inside the cloned repository
WORKDIR /src

# Build the software (modify as needed based on your build process)
RUN make

# Step 2: Use a smaller Alpine image for the final image
FROM alpine:3.17

# Install dependencies for running the executable (e.g., libc, libstdc++, etc.)
RUN apk add --no-cache \
    libstdc++ \
    && rm -rf /var/cache/apk/*

# Step 3: Copy the built executable from the builder image
COPY --from=builder /src/build/my_program /usr/local/bin/my_program

# Set the default command to run the executable
CMD ["/usr/local/bin/my_program"]
