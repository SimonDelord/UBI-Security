This is the folder for the first pipeline.

This is the first pipeline that copies the Red Hat UBI into a local container registry:

- Task zero: check signature of the Red Hat UBI - cosign function (using the "magic image")
- Task one: provide SBOM and upload SBOM (Software Bill of Material) to local container image registry for the Red Hat UBI - syft & cosign functions (using the "magic image") - this task has been removed as part of the final demo as it is not really required.
- Task two: clone-source (e.g copy the source Git Repo with the ContainerFile for the build of the base UBI). - tekton git-clone Task (pre-existing).
- Task three: build and upload UBI to private local Container Registry - buildah functions (using buildah bud and push functions).
- Task four (otional if using Tekton Chains): sign UBI in the private local Container Registry - cosign function (using the "magic image") - this task has been removed since there is no modification in the UBI and hence there is no need to sign this image again.
- Task five (optional with Quay): check for vulnerabilities in the UBI in the local Container Registry - roxctl or native Quay view (in this demo I simply use the Quay UI).

The various tasks are read sequentially.

### Task zero

Defined in zero-task.yaml and associated TaskRun in zero-task-run.yaml

There are a couple of things that need to be done first.

To check that the specific image you are checking is signed, you need to have a public-key (e.g of the instance that signed it) available.

You can then create a secret

```
oc create secret generic cosign-public-key --from-file=cosign.pub
```

You can then run the following command (e.g as part of the tekton Task)

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

Please note the first task uses the "magic image" that has been build (e.g rekor-cli, crane, cosign, syft) in the folder [bastion-build](https://github.com/SimonDelord/UBI-Security/tree/main/bastion-build)

#### Updated Task zero

In the case where you want to check directly from the Red Hat website (registry.redhat.io/ubi9/ubi:latest), you can run a different task that uses cosign directly.

This updated task is called task-zero-fromredhat-website.yaml and the associated taskrun is task-zero-fromredhat-website-run.yaml.


### First Task

Defined in first-task.yaml and associated TaskRun in first-task-run.yaml.

This task takes a "container image" called sourceImage and does an SBOM analysis and uploads this SBOM to a specific Repo.

Please note the first task uses the "magic image" that has been build (e.g rekor-cli, crane, cosign, syft) in the folder [bastion-build](https://github.com/SimonDelord/UBI-Security/tree/main/bastion-build)

### Second Task

This is a native task using the git-clone tekton Task (e.g existing task). 
An example of the TaskRun is presented in the second-task-run.yaml.

OK there is something not working properly here. So instead, I have simply created a "one step  pipeline" and an associated pipeline-run. 
These two artefacts will be used as part of the overall pipeline.
They make use of the pipeline-pvc-2 and container-pvc-2 PVCs to store their outputs.


### Third Task

The third task is effectively two steps (done in a single task) using the Tekton buildah pre-defined task.

This task is available under the third-task.yaml (there is no third-task-run.yaml because it requires the output of second-task).

So it is available as a two steps pipeline and an associated pipeline run:
 - third-task-pipeline.yaml
 - third-task-pipeline-run.yaml

### Fourth and Fifth tasks

Because I'm using Tekton / Tekton chains and Quay, I don't need to do steps 4 and 5 since those two steps are natively handled by both TektonChains and Quay.


## Overal Pipeline

The overall Pipeline and PipelineRun files are available as:
 - first-pipeline-final.yaml
 - first-pipeline-run-final.yaml

