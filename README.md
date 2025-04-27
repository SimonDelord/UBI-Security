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


Pushing a Red Hat UBI image to Quay, and using VEX to analyse the CVEs.

Showing the vim-minimal package, and how it contributes over 108 CVES

Hardening the UBI image via pipeline:
 - remove vim-minimal
 - update
 - sign + attestation (via Tekton Chains)

Show that the new image has less CVEs

So now we have:
Quay using Red Hat VEX (and other sources) to evaluate CVEs inside the UBI
A pipeline that:
Pulls a UBI image
Hardens it
Signs it
Pushes it to Quay, where CVEs are evaluated with VEX
We also have provenance:
Records stored in Rekor on how the hardened UBI was created - including build inputs / outputs
Records stored in Rekor on the pipeline used to harden the UBI - which commit was used from the repo, etc


## Platform components

 - Quay (using ODF as a way of setting up automatically Quay)
 - Tekton
 - RHTAS (Red Hat Trusted Artifact Signer)
 - OpenShift Pipelines (e.g Tekton)

Details on how to build the platform and setup the various functions are described under the [platform-build folder](https://github.com/SimonDelord/UBI-Security/tree/main/platform-build) . 


## Pipeline build

Once the platform and its components have been setup, the main part of the demo is the actual hardening of the Red Hat UBI image.

To achieve this, [Shane Boulden](https://github.com/shaneboulden) and I have defined a workflow that does the following: 

This is the first pipeline
 - Copy the Red Hat UBI into a local container registry:
    - check signature of the Red Hat UBI
    - provide SBOM (Software Bill of Material) for the Red Hat UBI
    - upload UBI to private local Container Registry
    - sign UBI in the private local Container Registry
    - check for vulnerabilities in the UBI in the local Container Registry

The second pipeline is the following:
 - based on the vulnerabilities found in the UBI in the local container registry
    - remove packages / patch packages with vulnerabilities
    - deploy packages relevant to the "local UBI build"
    - provide SBOM for the "hardened UBI" build
    - sign UBI in the private local Container Registry
    - check for vulnerabilities in the hardened UBI in the local container Registry 

Details of both pipelines are available in the [pipelines folder](https://github.com/SimonDelord/UBI-Security/tree/main/pipelines)

Steps:
Clone the code: https://github.com/shaneboulden/chains-pipeline
Create the pipeline-run: oc create -f pipeline-run-chains.yaml
Watch the build. Resulting image is signed with Tekton chains
Next steps:
Parameterise the source image (and update it in the dockerfile via sed
Document the repo

## Structure of the Quay Repo

There are 3 repos used in Quay as part of the demo:
 - ubi-base repo: this is simulating the Red Hat repo where the base ubi exists.
 - ubi-base-customer repo: this is where the customer is uploading all of the base images (e.g it's a mirror copy of the ubi-base repo)
 - ubi-hardened repo: this is where the customer is uploading all of the hardened based images

I need to create an image showing how images flow from ubi-base to ubi-base-customer to ubi-hardened
