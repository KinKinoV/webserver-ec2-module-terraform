# Rollback mechanism

In this task I implemented rules for the main branch and tried simple rollback mechanism available.

## Branch rules

Before trying to push terraform code with error into repository I configured rules for the main branch.

I created simple rule that prohibits to push commits straight into main branch, only using pull requests and made a requirement for all PRs to pass security-test and terratest checks in CI pipeline if they wish to merge into main branch.

Result of implementing these rules are next:
![cannot push commit straight into main branch](/img/git_branch_protection.png)

![cannot merge pull requests if didn't pass checks](/img/impossible_pr.png)

## Rollback

To try out rollback mechanism at first I had to push faulty code to repo:
![faulty terraform code](/img/terraform_error.png)

After pushing commit with faulty code, my CI pipeline alerted me that it didn't pass some checks:
![failed pipeline](/img/failed_pipeline.png)

If this was main branch, FluxCD would have picked up terraform code with a bug and automatically deployed infrastructer that wouldn't have worked. But because I implemented rules for the main branch it's now impossible to push code with errors into main branch.

But in case if some commit or merge into main branch broke "production" infrastructure or just to cancel changes, you can use next command:
```bash
git revert HEAD~0
```
`HEAD~0` means that I want to cancel changes made by previous commit. If i wanted to revert changes made by previous 5 commits, I would have used `HEAD~4` and so on. `revert` directive will create a new commit, but witch changes that negates changes introduced by specified ammount of past commits. In our case that's perfect, because CI pipeline will trigger on revert commit and do checks for the reverted code just to be sure everything works. And FLuxCD would have picked this change too and introduced changes into "production" infrastructure.

Results of the pipeline triggered by revert commit:
![successfull pipeline for revert commit](/img/successfull_revert_check.png)