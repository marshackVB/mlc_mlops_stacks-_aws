# MLOps Setup Guide
[(back to main README)](../README.md)

## Table of contents
* [Intro](#intro)
* [Create a hosted Git repo](#create-a-hosted-git-repo)
* [Configure CI/CD and ML resource state storage](#configure-cicd-and-ml-resource-state-storage)
* [Merge PR with initial ML code](#merge-a-pr-with-your-initial-ml-code)
* [Create release branch](#create-release-branch)
* [Deploy ML resources and enable production jobs](#deploy-ml-resources-and-enable-production-jobs)
* [Next steps](#next-steps)

## Intro
This page explains how to productionize the current project, setting up CI/CD and
ML resource deployment, and deploying ML training and inference jobs.

After following this guide, data scientists can follow the [ML Pull Request](ml-pull-request.md) and 
[ML Config](../mlc_mlops_stacks_aws/terraform/README.md) guides to make changes to ML code or deployed jobs.

## Create a hosted Git repo
Create a hosted Git repo to store project code, if you haven't already done so. From within the project
directory, initialize git and add your hosted Git repo as a remote:
```
git init --initial-branch=master
```

```
git remote add upstream <hosted-git-repo-url>
```

Commit the current README file and other docs to the `master` branch of the repo, to enable forking the repo:
```
git add README.md docs .gitignore .mlops-setup-scripts mlc_mlops_stacks_aws/terraform/README.md
git commit -m "Adding project README"
git push upstream master
```

## Configure CI/CD and ML resource state storage
Follow the guide in [.mlops-setup-scripts/README.md](../.mlops-setup-scripts/README.md) to
configure and enable CI/CD for the hosted Git repo created in the previous step, as well as
set up a state storage backend for ML resources (jobs, experiments, etc) created for the
current ML project.
## Configure profiles for tests, staging, and prod
Address the TODOs in the following files:
* [databricks-test.yaml](../mlc_mlops_stacks_aws/training/profiles/databricks-test.yaml): specify recipe configs to use in integration tests
* [databricks-staging.yaml](../mlc_mlops_stacks_aws/training/profiles/databricks-staging.yaml): specify recipe configs to use in recurring model training and batch inference
  jobs that run in the staging workspace
* [databricks-prod.yaml](../mlc_mlops_stacks_aws/training/profiles/databricks-prod.yaml) specify recipe configs to use in recurring model training and batch inference
  jobs that run in the prod workspace

## Merge a PR with your initial ML code
Create and push a PR branch adding the ML code to the repository.
We recommend including all files outside of `mlc_mlops_stacks_aws/terraform` in this PR:

```
git checkout -b add-ml-code
git add -- . ':!mlc_mlops_stacks_aws/terraform'
git commit -m "Add ML Code"
git push upstream add-ml-code
```

Open a PR from the newly pushed branch. CI will run to ensure that tests pass
on your initial ML code. Fix tests if needed, then get your PR reviewed and merged.
After the pull request merges, pull the changes back into your local `master`
branch:

```
git checkout master
git pull upstream master
```

## Create release branch
Create and push a release branch called `release` off of the `master` branch of the repository:
```
git checkout -b release master
git push upstream release
git checkout master
```

Your production jobs (model training, batch inference) will pull ML code against this branch, while your staging jobs will pull ML code against the `master` branch. Note that the `master` branch will be the source of truth for ML resource configurations and CI/CD workflows.

For future ML code changes, iterate against the `master` branch and regularly deploy your ML code from staging to production by merging code changes from the `master` branch into the `release` branch.
## Deploy ML resources and enable production jobs
Follow the instructions in [mlc_mlops_stacks_aws/terraform/README.md](../mlc_mlops_stacks_aws/terraform/README.md) to deploy ML resources
and production jobs.

## Next steps
After you configure CI/CD and deploy training & inference pipelines, notify data scientists working
on the current project. They should now be able to follow the
[ML pull request guide](ml-pull-request.md) and [ML resource config guide](../mlc_mlops_stacks_aws/terraform/README.md) to propose, test, and deploy
ML code and pipeline changes to production.
