1. pipeline failed as credentials were not updated on github secrets. updated secrets in repository to resolve
2. could not build docker image as package.json file was missing. ran npm init -y command to generate package file and corrected location path in dockerfile
3. could not find command terraform. it is not installed by default on github runner.
4. terraform cyclic dependency error. removed by troubleshooting using terraform graph and then removing dependencies.
5. after updating tf configuration files, some resources still required previous variables to be destroyed. Hence, pipeline was failing.

