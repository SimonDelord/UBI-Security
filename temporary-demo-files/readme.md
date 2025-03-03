This is the repo that has some of the K8 CRs and instructions to do the demo. Those items may or may not be relevant for the final demo.

 - buildconfig-redhat-ubi.yaml: is the BuildConfig for downloading the ubi9.5 and pushing it to the local Quay Container Registry (uses the dockerhub-secret.yaml as a way of authenticating against Quay)
 - customer-ubi.yaml: is the BuildConfig for modifying the redhat-ubi and removing vim-minimal package and then pushing this new image to the local Quay CR.
