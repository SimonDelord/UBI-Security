This is the folder for the first pipeline.

This is the first pipeline that copies the Red Hat UBI into a local container registry:

- Task zero: check signature of the Red Hat UBI - cosign function (using the "magic image")
- Task one: provide SBOM and upload SBOM (Software Bill of Material) to local container image registry for the Red Hat UBI - syft & cosign functions (using the "magic image")
- Task two: build and upload UBI to private local Container Registry - git and buildah functions
- Task three: sign UBI in the private local Container Registry - cosign function (using the "magic image")
- Task four (optional with Quay): check for vulnerabilities in the UBI in the local Container Registry - roxctl or native Quay view (in this demo I simply use the Quay UI).

The various tasks are read sequentially.

### Task zero
Defined in zero-task.yaml and associated TaskRun in zero-task-run.yaml

There are a couple of things that need to be done first.

To check that the specific image you are checking is signed, you need to have a public-key (e.g of the instance that signed it) available.

You can then create a secret
```
oc create secret generic cosign-public-key --from-file=cosign.pub
```

you can then run the following command (e.g as part of the tekton Task)

```
cosign verify --key k8s://openshift-pipelines/cosign-public-key example-registry-quay-quay.apps.rosa-pwfrp.lnqt.p1.openshiftapps.com/quayuser1/demo:v.9.6@sha256:b8e657c0628a947e8c57616becbdb78f3c3ccbbc4dae27272ffbbd243a04735c --insecure-ignore-tlog=true
```
The task runs a script that basically:
 - retrieves the hash of the image using crane
 - appends the hash to the image so cosign can verify against the hash (instead of just the version number).
  
```
sha=$(./go/bin/crane digest $(params.sourceImage))
        echo $sha

        finalimage=$(params.sourceImage)@$sha
        echo $finalimage
```



### First Task

Defined in first-task.yaml and associated TaskRun in first-task-run.yaml.

This task takes a "container image" called sourceImage and does an SBOM analysis and uploads this SBOM to a specific Repo.

Please note the first task uses the "magic image" that has been build (e.g rekor-cli, crane, cosign, syft) in the folder [bastion-build](https://github.com/SimonDelord/UBI-Security/tree/main/bastion-build)

### Second task


There are multiple files for this pipeline to run:
 - pipeline-one.yaml: is effectively the main definition of the pipeline. It contains all the tasks that are being run as part of it.
 - harden-ubi-build-task.yaml: is the slightly modified buildah task (native tekton) for the creation of the ubi image and upload onto the local Quay registry.
 - pipeline-one-run.yaml: the various parameters that will be used by the various tasks defined in the pipeline-one.yaml pipeline.
 - the two pvc.yaml files: those are PVCs that are required for data being handled between the different tasks of the pipeline.
