This is the repo for the second pipeline.

It reuses most of the tasks of the first pipeline, the main change is the use of Syft (via the magic-image) to create the SBOM.

The task for it is defined in [syft-task](https://github.com/SimonDelord/UBI-Security/tree/main/bastion-build/syft-build)


### Old caveats - fixed in the latest pipeline

There are a couple of things.

First, I didn't manage to get the path to be read properly for the git-clone task so I simply created a brand new git repo to point to the git-clone task.
This git repo is https://github.com/SimonDelord/hardened-ubi-demo.git

Second, if I point to the "customer base ubi" i need to add the password in there as part of the pipeline, which I haven't done (so I simply reused the ubi from the red hat repo)
registry.access.redhat.com/ubi9/ubi:9.5-1739751568

Apart from that, the pipeline works and removes the vim-minimal package and all the associated vulnerabilities.


## the cosign task

Defined in cosign-task.yaml and associated TaskRun in cosign-task-run.yaml

This task is defined to sign the local ubi image into the hardened-ubi image.

You need to have prepared a key pair (using the cosign cli on a jumphost for example). 

You can then create two secrets

```
oc create secret generic cosign-public-key --from-file=cosign.pub
oc create secret generic cosign-private-key --from-file=cosign.key
```

You can then run the following command (e.g as part of the tekton Task)

cosign verify --key k8s://openshift-pipelines/cosign-public-key example-registry-quay-quay.apps.rosa-pwfrp.lnqt.p1.openshiftapps.com/quayuser1/demo:v.9.6@sha256:b8e657c0628a947e8c57616becbdb78f3c3ccbbc4dae27272ffbbd243a04735c --insecure-ignore-tlog=true
