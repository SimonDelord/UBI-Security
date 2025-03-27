This is the folder for the first pipeline.

This is the first pipeline that copies the Red Hat UBI into a local container registry:

- Task zero: check signature of the Red Hat UBI - cosign function
- Task one: provide SBOM and upload SBOM (Software Bill of Material) to local container image registry for the Red Hat UBI - syft & cosign functions
- Task two: build and upload UBI to private local Container Registry - git and buildah functions
- Task three: sign UBI in the private local Container Registry - cosign function
- Task four (optional with Quay): check for vulnerabilities in the UBI in the local Container Registry - roxctl or native Quay view (in this demo I simply use the Quay UI).

The various tasks are read sequentially.

### Task zero
Defined in zero-task.yaml and associated TaskRun in zero-task-run.yaml



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
