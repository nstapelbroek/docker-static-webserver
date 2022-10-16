# Changelog

## [4.0.0](https://github.com/nstapelbroek/docker-static-webserver/tree/4.0.0) (2022-10-16)

[Full Changelog](https://github.com/nstapelbroek/docker-static-webserver/compare/3.0.0...4.0.0)

### Added 

- Docker multiarch builds
- A changelog to keep track of upgrading
- Goss test config for serverspec like testing
- CI and weekly image building with cirrus-ci

### Fixed

- Typo in license file
- Healthchecks no longer show up in the accesslogs

### Changed

- Docker base image is now debain
- BREAKING: Removed the custom bash script for a more stable an predictable envsubst implementation. Variables your files should no longer be prefixed with `container.env`. Example: `{container.env.HOST}` now becomes `${HOST}`
- BREAKING: Dropped s6 as init system becuase I now use the docker-entrypoint.sh from upstream nginx to replace the variables


## [3.0.0](https://github.com/nstapelbroek/docker-static-webserver/tree/3.0.0) (2019-04-06)

[Full Changelog](https://github.com/nstapelbroek/docker-static-webserver/compare/2.0.0...3.0.0)


- Seperate vhost config from nginx [\#8](https://github.com/nstapelbroek/docker-static-webserver/issues/8)
- Follow symbolic links when searching for files with environment variable to replace. [\#10](https://github.com/nstapelbroek/docker-static-webserver/pull/10) ([rick-nu](https://github.com/rick-nu))

## [2.0.0](https://github.com/nstapelbroek/docker-static-webserver/tree/2.0.0) (2018-03-09)

[Full Changelog](https://github.com/nstapelbroek/docker-static-webserver/compare/1.0.1...2.0.0)

##  Pre 2.x

[Full Changelog](https://github.com/nstapelbroek/docker-static-webserver/compare/1.0.0...1.0.1)

