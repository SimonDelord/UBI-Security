This is the repo that shows how to build a jumphost with all the relevant CLIs for the demo.

You need:
 - cosign
 - rekor
 - crane

Both crane and cosign get installed under Go.


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

