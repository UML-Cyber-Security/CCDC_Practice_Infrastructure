# Contribution
Author: Matthew Harper

> [!NOTE]
> Information here is likely to change year-by-year. Please check in with the current CCDC Coaches and Captains.
---
This repository is used by the University of Massachusetts Lowell (student) Cyber Security Teams. It contains scripts, documentation, notes and some scenarios. Anything that should be kept confidential or private should **NOT** be pushed to this repository. Anything that is pushed to this is public and can be seen by anyone so passwords, usernames, etc are often temporary or placeholders used in the initial infrastructure deployments.

## Keep in mind
> [!IMPORTANT]
> ***Do Not*** Push Personal Information.

1. All documents should have all authors listed at the top of scripts and documents.
    ```
    Author: XYZ
    Author: ZYX (Updated 2024)
    ...
    ```
2. All scripts should be working and have the execute permission bit set!
3. All documents should be complete and somewhat well written.
4. Any usernames and passwords should be placeholders if they are included as part of the commit.

## Guidelines and Procedure
> [!IMPORTANT]
> If you make a branch it should be *focused* that is we should keep the changes in that branch to specific technology or set of files. You should not be updating Windows, AWS and Linux documents unless you are working with a technology that uses all three of those things. In that case it may be a good idea for the technology (such as Wazuh) to be in it's own folder.

1. All contributions should first be pushed to a branch that is based on the *main* branch.
   * This branch should be named after what you are doing, something like creating a *contributions guideline* or updating one it could be `CreatingContributionsGuideline` or `Creating-Contributions-Guideline`, etc.
   * See [Github - Creating and Deleting Branches](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-and-deleting-branches-within-your-repository), you can also use [Git Checkout](https://git-scm.com/docs/git-checkout).
2. All commits should attempt to have some meaningful header. Although descriptions are appreciated they are not required (You do not need sign-off lines either!).
   * See [Atlassian - Git Commit](https://www.atlassian.com/git/tutorials/saving-changes/git-commit) or [Gitlab - Make your first Git commit](https://docs.gitlab.com/ee/tutorials/make_first_git_commit/).
3. Once the documentation is **COMPLETED** you should make a Pull Request (PR) to merge your work into the *main* branch.
   * See [Github - Creating a PR](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request).
4. Assign a reviewer in the PR, and notify them through whatever medium they prefer.
5. Look at the comments from the reviewers.
   * If they *all* approve, you should merge the changes into *main* and delete the branch.
   * If changes have been requested you should either make the requested changes or communicate with the reviewer about them if you believe they are not required.

## CCDC Contributions
1. All Contributions will first go through the above process in this repository.
2. Once approved you can make a branch in the appropriate CCDC repository, add the files and make a final PR.
   * As we archive our CCDC repositories and do not un-archive them, this practice repository acts as a *rolling* version, whereas the CCDC ones are eventually static.
