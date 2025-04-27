# UBI-Security
This is the demo that [Shane Boulden](https://github.com/shaneboulden) and myself have developed to cover how organisations can better manage the UBI, and create internal workflows to build 'golden' base images.

A recorded video of this is available [here](https://videos.learning.redhat.com/media/Platform%20engineering%20and%20building%20UBI-based%20golden%20images/1_bio6rg2o) (20 minutes)

The demo covers:
- Verifying UBI provenance with cosign and Sigstore
- Analysing the UBI for CVEs and unnecessary packages
- Building pipelines to harden and sign the UBI, using cosign and Tekton Chains
- Using Red Hat Advanced Cluster Security for Kubernetes (RHACS) admission control to block base images that haven't been through internal hardening pipelines

This demo also highlights how the CSAF/VEX format is used to secure the UBI and report on it.

Another key point of this demo is that it is an hermetic build systems - Hermetic meaning - contained with everything performed in OCP (harden, sign, build apps, etc).



## High level flow of the demo

The high level flow of the demo is shown in the figure below

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/images/UBI-demo-flow.png)


The first part of the demo shows (this is called the first pipeline):
 - how the [Red Hat Container Catalog](https://catalog.redhat.com/software/containers/) through the use of SigStore can show the provenance and associated vulnerabilities of the various UBI releases.
 - how to provide more details on the UBI health using the VEX format. The analysis is done using the Clair Scanner tool within a local Quay Instance.

The second part of the demo shows (this is called the second pipeline):
 - which vulnerabilities and packages could/should be removed as part of the previous steps.
 - the build of the hardened UBI, the generation of an SBOM (Software Bill of Material) and the signing of the hardened image using cosign/tekton chains.
 - all the above artefacts (signature, SBOM and hardened image) are stored on the local Quay instance
 - all the records associated with the creation of those artefacts are stored into a local Rekor Instance (deployed locally on the OCP cluster under the RHTAS component).

The third part of the demo shows:
 - how ACS can be used to block deployments of container images that do not have the proper signature (e.g provenance) in the environment. 

This demo also covers:
 - Records stored in Rekor on how the hardened UBI was created - including build inputs / outputs
 - Records stored in Rekor on the pipeline used to harden the UBI - which commit was used from the repo, etc


## Platform components

 - Quay (using ODF as a way of setting up automatically Quay)
 - Tekton
 - RHTAS (Red Hat Trusted Artifact Signer)
 - OpenShift Pipelines (e.g Tekton)
 - ACS (Advanced Cluster for Security)

Details on how to build the platform and setup the various functions are described under the [platform-build folder](https://github.com/SimonDelord/UBI-Security/tree/main/platform-build) . 


## Pipeline build

Once the platform and its components have been setup, the main part of the demo is the actual hardening of the Red Hat UBI image.

To achieve this, [Shane Boulden](https://github.com/shaneboulden) and I have defined a workflow that does the following: 

This is the first pipeline
 - Copy the Red Hat UBI into a local container registry:
    - check signature of the Red Hat UBI
    - upload UBI to private local Container Registry
    - check for vulnerabilities in the UBI in the local Container Registry (this provides more information than the Red Hat container catalog). 

The second pipeline is the following:
 - based on the vulnerabilities found in the UBI in the local container registry
    - remove packages / patch packages with vulnerabilities
    - deploy packages relevant to the "local UBI build"
    - provide SBOM for the "hardened UBI" build
    - sign UBI in the private local Container Registry
    - check for vulnerabilities in the hardened UBI in the local container Registry 

Details of both pipelines are available in the [pipelines folder](https://github.com/SimonDelord/UBI-Security/tree/main/pipelines)

## "Magic" container image

Because the demo uses all of the sigstore functions (cosign, rekor-cli, crane, syft), I have created a container image (clearly not optimised but ok for a demo) that can be uploaded in advance to the local Quay repo to provide some of the Tekton Tasks used in the pipelines (typically the SBOM, the image signature checks, etc..).
The ContainerFile for it is available under [magic-image](https://github.com/SimonDelord/UBI-Security/tree/main/bastion-build)


## Structure of the Quay Repo

There are 2 repos used in Quay as part of the demo:
 - ubi-base-customer repo: this is where the customer is uploading all of the base images (e.g it's a mirror copy of the ubi-base repo)
 - ubi-hardened repo: this is where the customer is uploading all of the hardened based images

