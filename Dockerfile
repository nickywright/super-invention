FROM ubuntu:22.10

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