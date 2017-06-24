# Docker static webserver

A simple alpine based nginx web container that has the ability to insert environment variables. Created to add a bit more configuraiton flexibility to staticly generated front-ends (like webpack builds) without having to re-build your Docker image or use a scripting language.

## Getting Started

This repository is used to generate the images available in the Docker hub. Using this image for your own project is as simple as creating a Dockerfile with the two lines below: 

```
FROM nstapelbroek:docker-static-webserver
COPY ./dist /var/www
``` 

Note that the `./dist` folder is where your static site is placed.

### Using enviornment variables

When this container bootstraps, a script will find and replace all occurrences of container.env.{variableName} and replace them for their matching values passed in the environment variables of your container. 

For instance, a HTML file containing the code:
```
<p>
    My backend is located at container.env.BACKEND_URL
</p>
```

Ran with an `-e BACKEND_URL=https://api.someproject.com` argument, will result in:

![result](https://user-images.githubusercontent.com/3368018/27512102-48ae27aa-5936-11e7-824a-92ca12d5334f.png)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* [s6-overlay](https://github.com/just-containers/s6-overlay) for making a easy and powerfull init setup & process supervisor
* [alpine](https://alpinelinux.org/) for creating a small base image
* [html5up](html5up.net) for providing the template used in the placeholder page
