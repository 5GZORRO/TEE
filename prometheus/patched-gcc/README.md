the package signing keys were generated with:
```
docker run --name keys --entrypoint abuild-keygen -e PACKAGER="C.Jorge <cjorge@ubiwhere.com>" andyshinn/alpine-abuild:v2 -n
```

the Dockerfile present here generates an abuilder image that will be used to produce Alpine packages from the APKBUILD file + patches:
```
docker build -t abuilder:latest .
```

that image can be used to produce ALPINE packages for the patched gcc:
```
docker run -v "$PWD/alpine-gcc-build:/home/builder/package" -v "$PWD/packages:/packages" abuilder:latest
```

resulting packages will be saved in the packages/ dir.
