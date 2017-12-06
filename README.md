# Docker static webserver

A simple alpine based nginx web container that has the ability to insert environment variables. Created to add a bit more configuration flexibility to statically generated front-ends (like webpack builds) without having to re-build your Docker image or use a scripting language.

## Getting Started

This repository is used to generate the images available in the Docker hub. Using this image for your own project is as simple as creating a Dockerfile with the two lines below: 

```Dockerfile
FROM nstapelbroek:docker-static-webserver
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

Sadly, due to the simple approach of finding & replacing the keywords there are some limitations:
- Please make sure your environment keys do not contain special characters. Only `a-z`, `A-Z`, `0-9` and `_` are allowed.
- Your environment values cannot contain: `&`, `*`, `[`, `]`,`^`
- By default, the script only changes files located in `/var/www` on your container. You can change this by adding an additional [initialization task](https://github.com/just-containers/s6-overlay#executing-initialization-andor-finalization-tasks) to s6-overlay.
- The container does not change files on the fly, so if you can't avoid mounting volumes be carefull.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* [s6-overlay](https://github.com/just-containers/s6-overlay) for making a easy and powerfull init setup & process supervisor
* [alpine](https://alpinelinux.org/) for creating a small base image
* [html5up](html5up.net) for providing the template used in the placeholder page
