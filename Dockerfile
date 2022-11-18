FROM ubuntu:22.04


# setup environment
RUN apt-get update \
&& apt-get install -y \
     gmt \
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
COPY pygplates_0.36.0_py310_ubuntu-22.04-arm64.deb /
COPY pygplates_0.36.0_py310_ubuntu-22.04-amd64.deb /

## Check the architecture, and install the correct pygplates. Not yet
RUN arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) \
	&& apt-get update \
    && apt install -y -f ./pygplates_0.36.0_py310_ubuntu-22.04-$arch.deb

RUN rm /pygplates_0.36.0_py310_ubuntu-22.04-*.deb

# set pythonpath 
ENV PYTHONPATH=$PYTHONPATH:/usr/lib
# install Cython
RUN pip3 install Cython	 

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

RUN pip3 install shapely --no-binary shapely
RUN pip3 install pygmt \
           jupyterlab \
		   pandas \
		   xarray \
		   numpy \
		   matplotlib \
		   scipy \
		   datetime \
		   rasterio \
		   geopandas \
		   rioxarray \
		   cartopy \
		   PlateTectonicTools

# This will copy things into the docker 
COPY . $NB_HOME
ENV PATH "/$NB_HOME/.local/bin:${PATH}"

EXPOSE 8888
CMD ["jupyter-lab", "--no-browser", "--ip=0.0.0.0"]