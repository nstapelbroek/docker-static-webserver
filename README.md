[![Travis](https://api.travis-ci.org/nstapelbroek/docker-static-webserver.svg?style=flat-square)](https://travis-ci.org/nstapelbroek/docker-static-webserver)
[![Docker Pulls](https://img.shields.io/docker/pulls/nstapelbroek/static-webserver.svg?style=flat-square)](https://hub.docker.com/r/nstapelbroek/static-webserver/tags/)
[![](https://images.microbadger.com/badges/image/nstapelbroek/static-webserver.svg?style=flat-square)](https://microbadger.com/images/nstapelbroek/static-webserver)
[![license](https://img.shields.io/github/license/nstapelbroek/docker-static-webserver.svg?style=flat-square)](https://opensource.org/licenses/MIT)

# Docker static webserver

A simple alpine based nginx web container that has the ability to insert environment variables. Created to add a bit more configuration flexibility to statically generated front-ends (like webpack builds) without having to re-build your Docker image or use a scripting language.

## Getting Started

This repository is used to generate the images available in the Docker hub. Using this image for your own project is as simple as creating a Dockerfile with the two lines below: 

```Dockerfile
FROM nstapelbroek/static-webserver:2
COPY ./dist /var/www
``` 

Note that the `./dist` folder is where your static site is placed.

### Using enviornment variables

When this container bootstraps, a script will find and replace all occurrences of {container.env.%variableName%} and replace them for their matching values passed in the environment variables of your container.

For instance, a HTML file containing the code:
```HTML
<p>
    My backend is located at {container.env.BACKEND_URL}
</p>
```

Ran with an environment variable `BACKEND_URL=https://api.someproject.com`, will result in:

![result](https://user-images.githubusercontent.com/3368018/27512102-48ae27aa-5936-11e7-824a-92ca12d5334f.png)

### What tag should you use

To prevent [confusion](https://medium.com/@mccode/the-misunderstood-docker-tag-latest-af3babfd6375) and sudden BC-breaks you should avoid using the `latest` tag when building upon this image (or any image for that matter). I'm using [Semver](https://semver.org/) as a base for versioning schematics. Due to the small functionality of this container I'm considering the following changes as "incompatible API changes": 

- Altered behavior at clients, for example due to changes in cache-headers
- Altered behavior in the find & replace script
- Altered behavior in the file locations

There are a couple of tags [available in the registry](https://hub.docker.com/r/nstapelbroek/static-webserver/tags/) for this image:

- `2` refers to its equally named support branch for preparing new minor or patch releases. This branch will be auto-rebuild every day meaning you'll also get the latest updates from the [upstream nginx image](https://hub.docker.com/_/nginx/). Use this branch whenever you can.
- `x.x.x` refers to an release. These releases are not auto-rebuild (yet) so you'll miss out on any updates or patches. It holds a good purpose if you want to pin to a specific release.
- `latest` refers to a build with new features or improvements that are potentially BC-breaking.

## Known limitations

Sadly, due to the simple approach of finding & replacing the keywords there are some limitations:
- Please make sure your environment keys do not contain special characters. Only `a-z`, `A-Z`, `0-9` and `_` are recommended.
- Due to their usage in the find & replace script, you are required to escape the following symbols in your environment values: `&`, `^`, `\`. Escaping these characters will look like: `\&`, `\^`, `\\`
- By default, the script only changes files located in `/var/www` on your container. You can change this by adding an additional [initialization task](https://github.com/just-containers/s6-overlay#executing-initialization-andor-finalization-tasks) to s6-overlay.
- The container does not change files on the fly, so if you can't avoid mounting volumes be carefull.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* [s6-overlay](https://github.com/just-containers/s6-overlay) for making a easy and powerfull init setup & process supervisor
* [alpine](https://alpinelinux.org/) for creating a small base image
* [html5up](html5up.net) for providing the template used in the placeholder page
