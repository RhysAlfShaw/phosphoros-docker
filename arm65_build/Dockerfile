# Use ARM64 base image
FROM --platform=linux/arm64 continuumio/miniconda3

# Install QEMU and binfmt support for x86_64 emulation
RUN apt-get update && apt-get install -y --no-install-recommends \
    qemu-user-static \
    binfmt-support \
    && rm -rf /var/lib/apt/lists/*

# Copy the multiarch QEMU binary for more reliable emulation
COPY --from=multiarch/qemu-user-static:x86_64-aarch64 /usr/bin/qemu-x86_64-static /usr/bin/

# Set QEMU as the interpreter for x86_64 binaries
RUN echo ':x86_64:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-x86_64-static:' > /proc/sys/fs/binfmt_misc/register || true

# Set the working directory
WORKDIR /work

# Copy your environment.yml file
COPY environment.yml /work/

# Set up environment to use x86_64 packages
RUN conda config --set subdir linux-64

# Create a script to initialize conda and activate the environment
RUN echo '#!/bin/bash \n\
source /opt/conda/etc/profile.d/conda.sh \n\
conda activate phosphoros || conda env create -f /work/environment.yml \n\
exec "$@"' > /work/entrypoint.sh && \
    chmod +x /work/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/work/entrypoint.sh"]

# Default command
CMD ["/bin/bash"]