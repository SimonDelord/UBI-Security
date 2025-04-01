This is the repo for the second pipeline.

There are a couple of things.

First, I didn't manage to get the path to be read properly for the git-clone task so I simply created a brand new git repo to point to the git-clone task.
This git repo is https://github.com/SimonDelord/hardened-ubi-demo.git

Second, if I point to the "customer base ubi" i need to add the password in there as part of the pipeline, which I haven't done (so I simply reused the ubi from the red hat repo)
registry.access.redhat.com/ubi9/ubi:9.5-1739751568

Apart from that, the pipeline works and removes the vim-minimal package and all the associated vulnerabilities.


