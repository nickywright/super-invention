# Docker
Dockerfile(s) for running various pygplates/geosciency codes

Work in progress.

- [Dockerfile-20.04](https://github.com/nickywright/super-invention/blob/main/Dockerfile-20.04): **For DockerDesktop 2.2**. Includes pygplates, other python packages, and GMT 6.4.
- [Dockerfile-22.04](https://github.com/nickywright/super-invention/blob/main/Dockerfile-22.04): includes pygplates and GMT
- [Dockerfile-22.10](https://github.com/nickywright/super-invention/blob/main/Dockerfile-22.10): does **not** include pygplates

## How-to
You can download the 20.04 image from: https://hub.docker.com/repository/docker/nickywright/geo-docker
e.g. 
`docker pull nickywright/geo-docker`

## Build instructions
For the Dockerfiles, you need to have [GMT](https://github.com/GenericMappingTools/gmt/releases/tag/6.4.0) and [pygplates](https://www.earthbyte.org/download-pygplates-0-36/) downloaded and into the same directory.

- to build: `docker build -f Dockerfile-20.04 . -t geodoc`
- to run as user: `docker run -it geodoc bash`
- to run with ports (e.g. for JupyterLab): `docker run -p 8888:8888 geodoc` 

### `Dockerfile-22.XX`:
This doesn't work with DockerDesktop 2.2 (old version). Also not really tested. Also need [pygplates](https://www.earthbyte.org/download-pygplates-0-36/) downloaded and into the same directory.
