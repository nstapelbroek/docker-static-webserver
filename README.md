[![Docker Pulls](https://img.shields.io/docker/pulls/nstapelbroek/static-webserver.svg?style=flat-square)](https://hub.docker.com/r/nstapelbroek/static-webserver/tags/)

# Docker static webserver

A simple nginx docker image that has the ability to insert environment variables. Created so I could re-use an image between prod and staging environments for my frontend builds.
It replaces environment variables on container startup so you don´t have to rebuild your Docker image or use a server-side language to change some settings.

## Getting Started

This repository generates the images available on the [Docker hub](https://hub.docker.com/r/nstapelbroek/static-webserver/tags).
Using this image for your own project is as simple as creating a Dockerfile with the two lines below:

```Dockerfile
FROM nstapelbroek/static-webserver:4
COPY ./your-static-content /var/www
``` 

A more modern example where you build your frontend project and ship it:

```Dockerfile
FROM node:18 as build
WORKDIR /opt/project

COPY package.json package-lock.json /opt/project/
RUN npm ci

COPY . /opt/project
RUN npm run build

FROM nstapelbroek/static-webserver:4
COPY --from=build --chown=nginx:nginx /opt/project/dist /var/www
```

### Using environment variables

When this container starts, a script will replace all occurrences of ${%variableName%} in `/var/www` with
their matching environment variable. 

For example, given this HTML in a file located at `/var/www/index.html`
```HTML
<p>
    My backend is located at ${BACKEND_URL}
</p>
```

And building & running this with an environment variable passed in docker run (`docker run -p 8080:80 -e BACKEND_URL=https://api.someproject.com myimage:latest`), you'll end up with:

![result](https://user-images.githubusercontent.com/3368018/27512102-48ae27aa-5936-11e7-824a-92ca12d5334f.png)

### What tag should I use?

To prevent sudden BC-breaks you should avoid using the `latest` tag when building upon this image (or any image for that reason).
I'm using [Semver](https://semver.org/) as a base for versioning schematics. Due to the small functionality of this container I'm considering the following changes as "incompatible API changes": 

- Altered behavior at clients, for example due to changes in cache-headers
- Altered behavior in the find & replace script
- Altered behavior in the file locations

You should use the latest available tag in [at in the registry](https://hub.docker.com/r/nstapelbroek/static-webserver/tags/).

## Known limitations

Due to the simple approach of finding & replacing the keywords there are some limitations:
- Please make sure your environment keys do not contain special characters. Only `a-z`, `A-Z`, `0-9` and `_` are recommended.
- By default, the script only changes files located in `/var/www`. You can change this by setting the `NGINX_ENVSUBST_WWW_DIR` environment variable. 
- The project is not meant as a development environment. Don´t mount your code in here as it will only change envioronment variables on the first starutp.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* [nginx dockerfiles](https://github.com/nginxinc/docker-nginx) for creating a stable base image
* [h5bp server configs](https://github.com/h5bp/server-configs-nginx) for providing the nginx config
* [html5up](html5up.net) for providing the template used in the placeholder page
* [envsubst](https://linux.die.net/man/1/envsubst) for doing the replacements
