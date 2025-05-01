This folder contains the "task" that uses the syft cli and the cosign cli to upload the output of syft into the local container registry.

What a joy this demo has become. 

When using an insecure container registry, everything breaks.

To disable TLS verification in syft, you need to create a yaml file that disable a variable,
have a look at this stuff [here](https://github.com/anchore/syft/wiki/configuration).

