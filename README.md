# UBI-Security
Demo showing how to secure UBI and report on it using CSAF/VEX format.
Hermetic build systems - Hermetic meaning - contained, and everything is performed on OCP (harden, sign, build apps, etc)



## High level flow of the demo

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
 - RHTPA

## pipeline build

Steps:
Clone the code: https://github.com/shaneboulden/chains-pipeline
Create the pipeline-run: oc create -f pipeline-run-chains.yaml
Watch the build. Resulting image is signed with Tekton chains
Next steps:
Parameterise the source image (and update it in the dockerfile via sed
Document the repo

