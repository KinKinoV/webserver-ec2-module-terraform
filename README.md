# How to

![infra instance with multiple network](./img/03-multiple-network.png "infra instance with multiple network")

### Create stack

```
terraform apply
```

This script will create:
-   1 vpc
-   2 networks
-   2 instances http
-   3 instances db

### Delete stack

```
terraform destroy
```

# How to deploy new environment

1. Create new branch and switch to it
2. Make changes in `./infrastructure` directory so that new environment doesn't conflict with other ones
3. Make commit with changes (optionally use `[skip_tests]` in commit message to skip general tests)
  Example:
  ```bash
  git commit -m "[skip_tests] Made changes in params file for new env"
  ```
  If there is no need to make changes make empty commit: `git commit --allow-empty -m "[skip_tests] Create new env"`

4. CI pipeline will create all needed files and configs for FluxCD and new PR into main branch
5. After accepting PR, FluxCD will automatically pick up new environment from `kubernetes/.../apps/tf-app` folder in repo and deploy needed infrastructure

## Changes in CI pipeline

To support multiple environments in this repository I've made next changes:
1. CI [pipeline](/.circleci/config.yml) now has new workflow `create-env` with the same named job. This workflow automatically creates required files for new environment, pushes them into branch that triggered CI and creates PR request into main branch, so that FluxCD will be able to provision new environment.
2. I created [tf-app](/kubernetes/fluxcd/repositories/infra-repo/clusters/dev-cluster/tf-app/) folder in `kubernetes/.../clusters/dev_cluster/` directory for FluxCD to pick up new Kustomization manifests created by CI pipeline
3. Created templates for FluxCD Kustomization manifests and templates for Terraform controller in [kubernetes/fluxcd/templates/](/kubernetes/fluxcd/templates/) directory to easily create files for each new environment in CI pipeline.
