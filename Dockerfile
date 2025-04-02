# Use the Miniconda3 base image from ContinuumIO
FROM continuumio/miniconda3

# Set the working directory in the container
WORKDIR /work

# Copy your project files into the container (if needed)
COPY environment.yml /work

# Install my conda environmentdock
RUN conda env create -f environment.yml
