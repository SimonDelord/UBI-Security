This is the folder with the pipelines


## Pipeline build

Once the platform and its components have been setup, the main part of the demo is the actual hardening of the Red Hat UBI image.

To achieve this, [Shane Boulden](https://github.com/shaneboulden) and I have defined a workflow that does the following: 


## Benefits of using Tekton

There are multiple benefits to using Tekton as part of the build:
 - reuse of multiple Taks that have been pre-built
 - TektonChains which does the automatic signing of each of the tasks and upload to the relevant Rekor Server for it.


### First pipeline

This is the first pipeline that copies the Red Hat UBI into a local container registry:
    - check signature of the Red Hat UBI - cosign function
    - provide SBOM and upload SBOM (Software Bill of Material) to local container image registry for the Red Hat UBI - syft & cosign functions
    - build and upload UBI to private local Container Registry - git and buildah functions
    - sign UBI in the private local Container Registry - cosign function
    - check for vulnerabilities in the UBI in the local Container Registry - roxctl or native Quay view (in this demo I simply use the Quay UI).
    

For uploading the UBI to private local Container Registry it uses the following Tasks:
 - git-clone (native Tekton task)
 - harden-ubi-build (a slightly modified version of buildah (native Tekton task) 


For checking the signature it uses cosign (native Tekton)
for providing the SBOM it could use syft however I slightly modified it (see syft folder) to combo syft and cosign together.


### Second pipeline


The second pipeline is the following:
 - based on the vulnerabilities found in the UBI in the local container registry
    - remove packages / patch packages with vulnerabilities
    - deploy packages relevant to the "local UBI build"
    - provide SBOM for the "hardened UBI" build
    - sign UBI in the private local Container Registry
    - check for vulnerabilities in the hardened UBI in the local container Registry 

Details of both pipelines are available in the [pipelines folder](https://github.com/SimonDelord/UBI-Security/tree/main/pipelines)


