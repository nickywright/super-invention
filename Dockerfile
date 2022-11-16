FROM ubuntu:22.10

# setup environment
RUN apt-get update \
&& apt-get install -y \
     gmt \
     libgmt-dev  \
     python3-pip \
     libnetcdf-dev \
     ghostscript \
	 build-essential


# add user
#EXPOSE 8888
ENV NB_USER jovyan
ENV NB_HOME /home/$NB_USER
RUN useradd -m -s /bin/bash -N $NB_USER -g users \
&&  mkdir -p /$NB_HOME/workspace \
&&  chown -R $NB_USER:users $NB_HOME
VOLUME $NB_HOME/workspace

# switch user
USER $NB_USER
WORKDIR $NB_HOME

RUN pip3 install pygmt \
           jupyterlab \
		   geopandas \
		   pandas \
		   rioxarray \
		   xarray \
		   numpy \ 
		   matplotlib \
		   shapely \
		   re \
		   scipy \
		   warnings \
		   rasterio \
		   datetime \
		   multiprocessing \
		   cartopy \
		   PlateTectonicTools

COPY . $NB_HOME
ENV PATH "/$NB_HOME/.local/bin:${PATH}"
CMD ["jupyter-lab", "--no-browser", "--ip=0.0.0.0"]