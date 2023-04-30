# Pythonic-dockers for geosciences
Dockerfile(s) for running various pygplates and geosciency codes

- [Dockerfile-20.04](https://github.com/nickywright/super-invention/blob/main/Dockerfile-20.04): **For DockerDesktop 2.2**, an old version of docker and using Ubuntu 20.04 (Focal Fossa). This includes an older version of GDAL, as well as pygplates, many other python packages, and GMT 6.4. 
- [Dockerfile-22.04](https://github.com/nickywright/super-invention/blob/main/Dockerfile-22.04): **recommended version to use**, using Ubuntu 22.04 (Jammy Jellyfish). This includes pygplates, GMT (v6.4), [gplately](https://github.com/GPlates/gplately) (v1.0) and all its trimmings, pygmt (v0.9), shapely (v2.0.1), and many many other useful modules!
- [Dockerfile-22.10](https://github.com/nickywright/super-invention/blob/main/Dockerfile-22.10): does **not** include pygplates

## How-to
- `docker pull nickywright/geo-python`: this will download the docker container image created using **[Dockerfile-22.04](https://github.com/nickywright/super-invention/blob/main/Dockerfile-22.04)**
- For systems that can only use an older version of Docker Desktop (~2.2), use the **[Dockerfile-20.04](https://github.com/nickywright/super-invention/blob/main/Dockerfile-20.04)** image using `docker pull nickywright/geo-docker`





## Build instructions
For the Dockerfiles, you might need to have [pygplates](https://www.earthbyte.org/download-pygplates-0-36/) downloaded and in the same directory.

### Dockerfile-20.04:
- to build: `docker build -f Dockerfile-20.04 . -t geodoc`
- to run as user: `docker run -it geodoc bash`
- to run with ports (e.g. for JupyterLab): `docker run -p 8888:8888 geodoc` 

### Dockerfile-22.04:
Note: this will not work with DockerDesktop 2.2 (an old version).

We need to do this on two machines: an arm64 (e.g. M1/M2 Macs) and an intel machine, so that we get docker containers compatible with both.
- to build: `docker build -f Dockerfile-22.04 . -t geodoc`
- Tag: `docker tag geodoc nickywright/geo-python:22.04-arm64` (on arm64) or `docker tag geodoc nickywright/geo-python:22.04-x86` (on x86)
- Push to dockerhub: `docker push nickywright/geo-python:22.04-arm64` or `docker push nickywright/geo-python:22.04-x86`
- Manifest step so that everything is under a single 'latest' tag:
  - `docker manifest create nickywright/geo-python:latest 
--amend nickywright/geo-python:22.04-arm64 
--amend nickywright/geo-python:22.04-x86`
  - `docker manifest push nickywright/geo-python:latest`
  
- To get: `docker pull nickywright/geo-python`

- To run: Put relevant files into a folder, navigate to that folder in terminal, and then do:
  - `docker run -v $PWD:/home/jovyan/workspace -p 8888:8888 nickywright/geo-python`
  - Copy the last JupyterLab URL into a web browser, where you can then run the notebooks and scripts!


***Other helpful tips:***

If you modify a text file on windows, you might need to fix so the docker (unix system) can read it.
In a terminal (via the JupyterLab interface, once the docker is launched, you can do:
- `tr -d '\15\32' < windows_compatible_file.txt > unix_compatible_file.txt`

  
