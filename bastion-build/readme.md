This is the repo that shows how to:
 - build a jumphost with all the relevant CLIs for the demo.
 - build the equivalent function as a container image.

You need:
 - cosign (for signing and verifying container images)
 - rekor-cli (for interacting with transparency logs - e.g the local rekor environment) 
 - crane (for retrieving container images manifests and digests)
 - syft (for creating SBOM)

Both crane, cosign and rekor-cli get installed under Go.

Syft is installed running a bash script.


## Install Go ##
Taken from https://go.dev/doc/install

```
wget https://go.dev/dl/go1.24.1.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.1.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version
```

## install Cosign ##
Taken from https://docs.sigstore.dev/cosign/system_config/installation/

```
go install github.com/sigstore/cosign/v2/cmd/cosign@latest
The resulting binary will be placed at $GOPATH/bin/cosign (or $GOBIN/cosign, if set).

cosign version
```

## install Crane ##

```
go install github.com/google/go-containerregistry/cmd/crane@latest
crane version
```

## Install rekor-cli ##

```
go install -v github.com/sigstore/rekor/cmd/rekor-cli@latest
```

## Install syft

```
curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin
syft version
```

The associated container file is available [container-file](https://github.com/SimonDelord/UBI-Security/blob/main/bastion-build/Dockerfile)
