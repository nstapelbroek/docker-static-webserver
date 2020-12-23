[![Travis](https://api.travis-ci.org/nstapelbroek/docker-static-webserver.svg?style=flat-square)](https://travis-ci.org/nstapelbroek/docker-static-webserver)
[![Docker Pulls](https://img.shields.io/docker/pulls/nstapelbroek/static-webserver.svg?style=flat-square)](https://hub.docker.com/r/nstapelbroek/static-webserver/tags/)
[![](https://images.microbadger.com/badges/image/nstapelbroek/static-webserver.svg?style=flat-square)](https://microbadger.com/images/nstapelbroek/static-webserver)

# Docker static webserver

A simple alpine based nginx web container that has the ability to insert environment variables. Created to add a bit more configuration flexibility to statically generated front-ends (like webpack builds) without having to re-build your Docker image or use a scripting language.

## Getting Started

This repository generates the images available on the [Docker hub](https://hub.docker.com/r/nstapelbroek/static-webserver/tags). Using this image for your own project is as simple as creating a Dockerfile with the two lines below: 

```Dockerfile
FROM nstapelbroek/static-webserver:3
COPY ./your-static-content /var/www
``` 

A more modern example where you build your frontend project and ship it with the image:

```Dockerfile
FROM node:14 as build
WORKDIR /opt/project

COPY package.json package-lock.json /opt/project/
RUN npm ci

COPY . /opt/project
RUN npm run build

FROM nstapelbroek/static-webserver:3
COPY --from=build --chown=nginx:nginx /opt/project/dist /var/www
```

### Using environment variables

When this container starts, a script will replace all occurrences of {container.env.%variableName%} in `/var/www` with
their matching environment variable. 

For example, given this HTML in a file located at `/var/www/index.html`
```HTML
<p>
    My backend is located at {container.env.BACKEND_URL}
</p>
```

Will result in the image below when you run your image with `-e BACKEND_URL=https://api.someproject.com`.

![result](https://user-images.githubusercontent.com/3368018/27512102-48ae27aa-5936-11e7-824a-92ca12d5334f.png)

### What tag should I use?

To prevent sudden BC-breaks you should avoid using the `latest` tag when building upon this image (or any image for that matter). 
I'm using [Semver](https://semver.org/) as a base for versioning schematics. Due to the small functionality of this container I'm considering the following changes as "incompatible API changes": 

- Altered behavior at clients, for example due to changes in cache-headers
- Altered behavior in the find & replace script
- Altered behavior in the file locations

There are a couple of tags [available in the registry](https://hub.docker.com/r/nstapelbroek/static-webserver/tags/) for this image:

- `3` refers to its equally named support branch for preparing new minor or patch releases. This branch will be auto-rebuild every day meaning you'll also get the latest updates from the [upstream nginx image](https://hub.docker.com/_/nginx/). Use this branch whenever you can.
- `latest` refers to a build with new features or improvements that are potentially BC-breaking.

## Known limitations

Due to the simple approach of finding & replacing the keywords there are some limitations:
- Please make sure your environment keys do not contain special characters. Only `a-z`, `A-Z`, `0-9` and `_` are recommended.
- Due to their usage in the find & replace script, you are required to escape the following symbols in your environment values: `&`, `^`, `\`. Escaping these characters will look like: `\&`, `\^`, `\\`
- By default, the script only changes files located in `/var/www` on your container. You can change this by adding an additional [initialization task](https://github.com/just-containers/s6-overlay#executing-initialization-andor-finalization-tasks) to s6-overlay.
- The container does not change files on the fly, so if you can't avoid mounting volumes be carefull.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* [s6-overlay](https://github.com/just-containers/s6-overlay) for making an easy and powerful init setup & process supervisor
* [alpine](https://alpinelinux.org/) for creating a small base image
* [html5up](html5up.net) for providing the template used in the placeholder page
