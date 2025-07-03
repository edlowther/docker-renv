# Use the base image you were using before
FROM rocker/rstudio:4.5.1 AS base

# RUN 'echo "$SSH_PRIVATE_KEY"'

# ADD --chown=rstudio . /home/rstudio/lassa_sentinel

# Set CRAN mirror to RSPM
# RUN echo "options(repos = c(CRAN = 'https://packagemanager.rstudio.com/all/latest'))" >> /usr/local/lib/R/etc/Rprofile.site

# Install necessary system dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    libprotobuf-dev protobuf-compiler libjq-dev libfontconfig1-dev \
    curl libharfbuzz-dev libfreetype6-dev libfribidi-dev libharfbuzz-dev \
    cmake libsodium-dev libglpk-dev libssl-dev libudunits2-dev libgdal-dev \
    git openssh-client build-essential zlib1g-dev libffi-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libgdbm-dev libnss3-dev liblzma-dev python3-pip python3.12-venv \
    gdal-bin libgdal-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# RUN apt-get update && apt-get upgrade -y && \
#     apt-get install -y \
#     git && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# Set up a directory for SSH
# RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Create a script to set up SSH key at runtime
# RUN echo '#!/bin/bash\n\
#     echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_ed25519\n\
#     chmod 600 /root/.ssh/id_ed25519\n\
#     ssh-keyscan github.com >> /root/.ssh/known_hosts\n\
#     eval "$(ssh-agent -s)"\n\
#     ssh-add /root/.ssh/id_ed25519\n\
#     exec "$@"' > /entrypoint.sh && chmod +x /entrypoint.sh

# Set the entrypoint to our new script
# ENTRYPOINT ["/entrypoint.sh"]

# Install the renv package manager
RUN R -e "install.packages('renv', repos='https://cloud.r-project.org/')"
WORKDIR /home/rstudio/project
COPY renv.lock renv.lock
ENV RENV_PATHS_LIBRARY=renv/library
# RUN R -e "renv::restore()"


# Install INLA from source for ARM architecture support
# RUN R -e "install.packages('INLA', repos=c(getOption('repos'), INLA='https://inla.r-inla-download.org/R/stable'), type='source')"

# Clone the private GitHub repo into the project directory
# RUN --mount=type=ssh git clone git@github.com:rorygibb/lassa_sentinel.git

# Set the project directory
# WORKDIR /home/rstudio/lassa_sentinel
# ENV RENV_PATHS_LIBRARY=renv/library

# Checkout to the specified branch
# RUN git checkout adding_rest-api

# Enable parallel downloads for renv
# RUN echo "options(renv.config.install.staged = FALSE)" >> /usr/local/lib/R/etc/Rprofile.site

# Restore the R environment using renv
# RUN R -e "renv::restore(clean = TRUE, prompt = FALSE)"
# RUN chown -R rstudio /home/rstudio/lassa_sentinel/renv/library/R-4.4/x86_64-pc-linux-gnu

# Install Python and set up virtual environment
RUN python3 -m venv /root/.virtualenvs/r-reticulate
RUN /root/.virtualenvs/r-reticulate/bin/pip install --upgrade pip setuptools wheel

# Install specific version of earthengine-api
RUN /root/.virtualenvs/r-reticulate/bin/pip install earthengine-api==0.1.370

# Ensure reticulate uses the correct Python environment
ENV RETICULATE_PYTHON=/root/.virtualenvs/r-reticulate/bin/python

# Ensure the earth engine uses the correct virtual environment
ENV EARTHENGINE_ENV=/root/.virtualenvs/r-reticulate

# Ensure the virtual environment is activated
ENV PATH="/root/.virtualenvs/r-reticulate/bin:$PATH"

# Expose the ports for both servers
# EXPOSE 8080

# Set the entrypoint to the start_servers.sh script
# CMD ["Rscript", "api.R"]
