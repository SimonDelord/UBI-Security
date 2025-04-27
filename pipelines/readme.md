This is the folder with the pipelines


## Pipeline build

Once the platform and its components have been setup, the main part of the demo is the actual hardening of the Red Hat UBI image.

To achieve this, [Shane Boulden](https://github.com/shaneboulden) and I have defined a workflow that does the following: 


### First pipeline

This is the first pipeline that copies the Red Hat UBI into a local container registry:
 - check signature of the Red Hat UBI - cosign function
 - build and upload UBI to private local Container Registry - git and buildah functions
 - check for vulnerabilities in the UBI in the local Container Registry - roxctl or native Quay view (in this demo I simply use the Quay UI).
    

For uploading the UBI to private local Container Registry it uses the following Tasks:
 - git-clone (native Tekton task)
 - harden-ubi-build (a slightly modified version of buildah (native Tekton task)) 


#### Example on how to check a container image signature using your own key

```
crane digest example-registry-quay-quay.apps.rosa-pwfrp.lnqt.p1.openshiftapps.com/quayuser1/demo:v.9.6
sha256:b8e657c0628a947e8c57616becbdb78f3c3ccbbc4dae27272ffbbd243a04735c

cosign verify --key cosign.pub example-registry-quay-quay.apps.rosa-pwfrp.lnqt.p1.openshiftapps.com/quayuser1/demo:v.9.6@sha256:b8e657c0628a947e8c57616becbdb78f3c3ccbbc4dae27272ffbbd243a04735c --insecure-ignore-tlog=true
WARNING: Skipping tlog verification is an insecure practice that lacks of transparency and auditability verification for the signature.

Verification for example-registry-quay-quay.apps.rosa-pwfrp.lnqt.p1.openshiftapps.com/quayuser1/demo@sha256:b8e657c0628a947e8c57616becbdb78f3c3ccbbc4dae27272ffbbd243a04735c --
The following checks were performed on each of these signatures:
  - The cosign claims were validated
  - The signatures were verified against the specified public key

[{"critical":{"identity":{"docker-reference":"example-registry-quay-quay.apps.rosa-pwfrp.lnqt.p1.openshiftapps.com/quayuser1/demo"},"image":{"docker-manifest-digest":"sha256:b8e657c0628a947e8c57616becbdb78f3c3ccbbc4dae27272ffbbd243a04735c"},"type":"cosign container image signature"},"optional":{"Bundle":{"SignedEntryTimestamp":"MGQCMBtDAoVdRftPBWXPwbSRvKpFpe6WDjWBloNwVHbGKKYxr+idRD+Gj7hHtgIdliCI/gIwW3hy3P+aQebP7UHCDOW7PO/n8G50Rhuwj0ZbECj6UTNTD+N8PwqX2dosF1De986E","Payload":{"body":"eyJhcGlWZXJzaW9uIjoiMC4wLjEiLCJraW5kIjoiaGFzaGVkcmVrb3JkIiwic3BlYyI6eyJkYXRhIjp7Imhhc2giOnsiYWxnb3JpdGhtIjoic2hhMjU2IiwidmFsdWUiOiJhYzkyNjY3ZTJkOGUxZjc5MWZhYzBiZTRjZTc3NWE2YTNhY2I5NmE5ZjE1OThiMDdlMDFkZWJhYzA1YWMyZGM2In19LCJzaWduYXR1cmUiOnsiY29udGVudCI6Ik1FVUNJQk9QT2dmU2JpM1ZSSXVhcDh5MjYyQm9yMTE5UlY5QUc3SUpnM0NOaWl0bUFpRUFtWDlGdkhtRlc3L2xFblB2Z050WFpuYjBIRUplV2JDZXpzS2V3dmIzcnVzPSIsInB1YmxpY0tleSI6eyJjb250ZW50IjoiTFMwdExTMUNSVWRKVGlCUVZVSk1TVU1nUzBWWkxTMHRMUzBLVFVacmQwVjNXVWhMYjFwSmVtb3dRMEZSV1VsTGIxcEplbW93UkVGUlkwUlJaMEZGUlRscmEwaDRVR1p5UkhGc1kwZzRZU3N5VEU4NFNrZHZVMnA2UmdwMVRFeHJkM1pKWTAxcUwybFJWRXBpYm1OMFpVeGpaMnhKV1dZdmRVeG5Oa2hFZFZoRVpUQnBNVUZqY2tKUVpUTTRZV2REWlV0eU1qSm5QVDBLTFMwdExTMUZUa1FnVUZWQ1RFbERJRXRGV1MwdExTMHRDZz09In19fX0=","integratedTime":1741654026,"logIndex":10,"logID":"6c5582ec9e796b510f463af7accef9d1a254aeffb384d16099ccc1819db85375"}}}}]
```


#### Example on how to check the digest of the latest UBI from the red hat Container catalog:
```
crane digest registry.redhat.io/ubi9/ubi:latest
sha256:8d53b60617e53e4dbd6c0d485c569801f48dbeb40b48c8424a67e33a07320968
```
Download Red Hat release key 3 from here: https://access.redhat.com/security/team/key
```
curl https://security.access.redhat.com/data/63405576.txt > redhat.pub
Verify the image signature without tlog (rekor):
cosign verify --key redhat.pub registry.redhat.io/ubi9/ubi@$(crane digest registry.redhat.io/ubi9/ubi:latest) --insecure-ignore-tlog=true
Now the signature is verified:
Verification for registry.redhat.io/ubi9/ubi@sha256:8d53b60617e53e4dbd6c0d485c569801f48dbeb40b48c8424a67e33a07320968 --
The following checks were performed on each of these signatures:
  - The cosign claims were validated
  - The signatures were verified against the specified public key
```

### Second pipeline

The second pipeline is the following:
 - based on the vulnerabilities found in the UBI in the local container registry
    - remove packages / patch packages with vulnerabilities
    - deploy packages relevant to the "local UBI build"
    - provide SBOM for the "hardened UBI" build
    - sign UBI in the private local Container Registry
    - check for vulnerabilities in the hardened UBI in the local container Registry 

Details of both pipelines are available in the [pipelines folder](https://github.com/SimonDelord/UBI-Security/tree/main/pipelines)

## Benefits of using Tekton

There are multiple benefits to using Tekton as part of the build:
 - reuse of multiple Tasks that have been pre-built (git, buildah, etc).
 - TektonChains which does the automatic signing of each of the tasks and upload to the relevant Rekor Server for it.

