## Platform build

There are multiple components that need to be installed on OpenShift for the platform to do this UBI hardening demo.

 - first you need a cluster: in this demo we are using a ROSA cluster (4.17)
 - second you need an underlying storage capability for Quay: we are using ODF (as it allows a simpler deployment of Quay - but this is not resource friendly)

### Install ODF as the underlying storage capability

Requirements for ODF are quite big - https://docs.redhat.com/en/documentation/red_hat_openshift_data_foundation/4.17/html-single/planning_your_deployment/index#resource-requirements_rhodf
30 CPUs / 72 Gb of RAM -> 3 nodes.
As part of the ROSA deployment, go to the OCM console and add a node pool -> called odf-node-pool -> 3 x m5.2xlarge EC2 instances.

![Browswer](https://github.com/SimonDelord/UBI-Security/blob/main/platform-build/images/odf-node-pool.png)
