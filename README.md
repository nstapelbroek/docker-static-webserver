# Docker static webserver

A simple alpine based nginx web container that has the ability to insert environment variables. Created to add a bit more configuraiton flexibility to staticly generated front-ends (like webpack builds) without having to re-build your Docker image.

## Getting Started

This repository is used to generate the images available in the Docker hub. Using this image for your own project is as simple as creating a Dockerfile with the two lines below: 

```
FROM nstapelbroek:docker-static-webserver
COPY ./dist /var/www
``` 

Note that the `./dist` folder is where your static site is placed.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* [s6-overlay](https://github.com/just-containers/s6-overlay) for making a easy and powerfull init setup & process supervisor
* [alpine](https://alpinelinux.org/) for creating a small base image
