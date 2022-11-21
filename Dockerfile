# ------ DockerFile for running paleogeography codes
# for DockerDesktop 2.2
FROM ubuntu:20.04

# RUN apt-get update \
# 	&& apt-get install software-properties-common
# RUN apt-get update
# RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable

# setup environment
RUN apt-get update \ 
    && 4 | apt-get install -y gmt

RUN apt-get update \
&& apt-get install -y \
	libgmt-dev  \
    python3-pip \
    libnetcdf-dev \
    ghostscript \
	libgdal-dev \
	libgeos-dev \
	proj-data \
	python3-gdal \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# install pygplates! First copy both versions
COPY pygplates_0.36.0_py38_ubuntu-20.04-amd64.deb /
COPY pygplates_0.36.0_py38_ubuntu-20.04-arm64.deb /

## Check the architecture, and install the correct pygplates. Not yet tested
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) \
	&& apt-get update \
    && apt install -y -f ./pygplates_0.36.0_py38_ubuntu-20.04-$arch.deb

# remove the deb files
RUN rm /pygplates_0.36.0_py38_ubuntu-20.04-*.deb

# set pythonpath 
ENV PYTHONPATH=$PYTHONPATH:/usr/lib

# install a couple python things as root
RUN pip3 install Cython

# ------
# add user
ENV NB_USER jovyan
ENV NB_HOME /home/$NB_USER
RUN useradd -m -s /bin/bash -N $NB_USER -g users \
&&  mkdir -p /$NB_HOME/workspace \
&&  chown -R $NB_USER:users $NB_HOME
VOLUME $NB_HOME/workspace

# switch user
USER $NB_USER
WORKDIR $NB_HOME

# ------
# install various python packages
# rasterio==1.2.10, because 1.3+ requires a newer version of GDAL
RUN pip3 install shapely --no-binary shapely
RUN pip3 install pygmt \
           jupyterlab \
		   pandas \
		   xarray \
		   numpy \
		   matplotlib \
		   scipy \
		   datetime \
		   rasterio==1.2.10 \
		   geopandas \
		   rioxarray \ 
		   cartopy \
		   PlateTectonicTools \
		   gplately
		   
# to avoid a numpy error
RUN pip3 install --upgrade numpy 

# This will copy things into the docker 
COPY . $NB_HOME
ENV PATH "/$NB_HOME/.local/bin:${PATH}"

# ------ start command
EXPOSE 8888
CMD ["jupyter-lab", "--no-browser", "--ip=0.0.0.0"]