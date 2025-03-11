## Platform build

There are multiple components that need to be installed on OpenShift for the platform to do this UBI hardening demo.

 - first you need a cluster: in this demo we are using a ROSA cluster (4.17)
 - second you need an underlying storage capability for Quay: we are using ODF (as it allows a simpler deployment of Quay - but this is not resource friendly)
 - third you need to deploy Quay
 - fourth you need to deploy RHTAS (Red Hat Trusted Artifact Signer)
 - fifth you need to deploy OpenShift Pipelines (e.g Tekton)

### Install ODF as the underlying storage capability

Requirements for ODF are quite big - https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.17/html-single/planning_your_deployment/index#resource-requirements_rhodf
30 CPUs / 72 Gb of RAM -> 3 nodes.
As part of the ROSA deployment, go to the OCM console and add a node pool -> called odf-node-pool -> 3 x m5.2xlarge EC2 instances.

![Browswer](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/odf-node-pool.png)



The next step is to install the ODF operator from the Operator Hub.

Go through all the Defaults for Operator Hub -> OpenShift Data Fundation -> Install


Create a Storage System Instance
Go through the pannels -> select the worker nodes deployed in the previous step and select Use CephRBD as the default storage class


![Browswer](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/odf-add-workers-1.png)

Select lean-mode (as it doesn't have enough CPUs to run Balanced).

![Browswer](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/odf-add-workers-2.png)

Leave the other fields as they are and click create.

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/storage-system.png)


## Install Quay as an Operator using ODF.

Create a new project (called Quay in this demo).

Go to Operator Hub and select the Quay Operator 

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/quay-operator-install-1.png)

Then select the defaults and click install

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/quay-operator-install-2.png)


Go into the Installed Operators under the Quay Project and install the Quay Registry and select the create Quay Registry with the default parameters (you should change the namespace to "Quay")

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/install-quay-instance-1.png)

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/install-quay-instance-2.png)

### Modify Clair to use Scanner v4
In the current Quay release of this demo (3.13.4 - March 2025) we need to "manually" enable Scanner v4 (e.g for CSAF/VEX support).
The following steps have been created by Shane Boulden for the configuration. 
As part of the newer releases, this step will no longer be necessary.

Once Clair is deployed, update the clair component to managed: false

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/clair-1.png)


We can now make changes to the Clair configuration. Update the deployment to reference the image quay.io/projectquay/clair:4.8.0:

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/clair-2.png)

Check that the Clair pods have been re-deployed, and are pulling in VEX for updates:

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/clair-3.png)

Note the name of the service that has been created by the operator for Clair:

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/clair-4.png)

Collect the Clair pre-shared key, from the secret created by the Quay operator:

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/clair-5.png)

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/clair-6.png)


Now, update the secret for the Quay deployment to reference the Clair scanner (this was removed when the Clair component was set to managed: false):
 - FEATURE_SECURITY_SCANNER: true
 - SECURITY_SCANNER_V4_ENDPOINT: http://example-registry-clair-app (name of service you copied)
 - SECURITY_SCANNER_V4_PSK: T2pHeGtDQm1rdFloMWZNRWgwTWtlZHN0ZnJ5OFAyejI= (base64 PSK you copied)


![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/clair-7.png)

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/clair-9.png)

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/clair-8.png)

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/clair-10.png)


You just need to wait a bit and then you should be able to see images being scanned with the CSAF/VEX format displayed.

### Create a Secret to push images into the Quay instance

After creating the user (Which is done as part of the first login), you can then create a K8s secret to provide credentials to upload container images onto the local Quay instance.
Click on the top right corner -> Quayuser1, select account settings

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/quay-secret-1.png)


Click on the create application token and enter the token name (ubi-demo-token in this case). 

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/quay-secret-2.png)

Once the token has been created click on the token itself (ubi-demo-token here) and then select Kubernetes Secret and view ubi-demo-token-secret.yaml file. 
you can then cut and paste the yaml file directly into OpenShift.

![Browser](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/quay-secret-3.png)





