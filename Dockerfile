# Use the base JupyterHub container image
FROM gesiscss/binder-r2d-g5b5b759-ajibal-2dcoding-38529b:2657d5e087daee122e333a09554bb2beaabc134f

# Install additional Python packages
RUN python3 -m pip install --no-cache-dir \
    notebook==6.4.4 \
    jupyterlab==3.0.16

# Set up a non-root user
ARG NB_USER=fox
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

# Switch to root to perform administrative tasks
USER root

# Create the non-root user
RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Switch back to the non-root user
USER ${NB_USER}

# Copy the contents of your repository to the home directory
COPY . ${HOME}

# Change ownership of the home directory
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# Specify the default command to run JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.default_url=/lab/"]
