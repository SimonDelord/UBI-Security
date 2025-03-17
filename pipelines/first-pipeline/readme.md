This is the folder for the first pipeline.

There are multiple files for this pipeline to run:
 - pipeline-one.yaml: is effectively the main definition of the pipeline. It contains all the tasks that are being run as part of it.
 - harden-ubi-build-task.yaml: is the slightly modified buildah task (native tekton) for the creation of the ubi image and upload onto the local Quay registry.
 - pipeline-one-run.yaml: the various parameters that will be used by the various tasks defined in the pipeline-one.yaml pipeline.
 - the two pvc.yaml files: those are PVCs that are required for data being handled between the different tasks of the pipeline.
