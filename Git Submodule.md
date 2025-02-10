# Git Submodules

## Add Submodule

To add submodule repositories to your main repository, you can follow these steps:

1. **Navigate to the Main Repository**

    > [!NOTE] Ensure you're inside the directory of your main repository. If it's not already a Git repository, initialize it using:

    ```bash
    git init
    ```

1. **Add the Submodule**

    Use the git submodule add command to add the submodule repository:

    ```bash
    git submodule add <repository-url> <path>
    ```

    - `<repository-url>`: URL of the repository you want to add as a submodule.
    - `<path>`: Optional. Directory where the submodule will be cloned (defaults to the repository's name).

    Example:

    ```bash
    git submodule add https://github.com/example/repo-name submodules/repo-name
    ```

1. **Commit Changes**

    After adding the submodule, Git creates a `.gitmodules` file to track submodule information. Commit this file and the submodule addition:

    ```bash
    git commit -am "Added submodule repo-name"
    ```

1. **Initialize and Update Submodules**

    Initialize and update the submodule to fetch its contents:

    ```bash
    git submodule update --init --recursive
    ```

    - `--init` sets up the submodule's local configuration by creating the `.git/config` entries for the submodule(s).
    - `--recursive` ensures that the command also operates on any submodules within submodules (nested submodules).

## Working with Submodules

To update the submodule to the latest commit on its branch:

```bash
cd <submodule-path>
git pull origin <branch>
```

To ensure submodules are updated when someone clones the main repository, use:

```bash
git clone --recursive <main-repo-url>
```

If already cloned without submodules:

```bash
git submodule update --init --recursive
```

## Removing a Submodule

If you need to remove a submodule later:

1. Delete the relevant entry from `.gitmodules`and `.git/config`.

1. Remove the submodule directory and related entries from the Git index:

    ```bash
    git rm --cached <submodule-path>
    ```

1. Commit the changes.

This setup allows you to manage multiple repositories as part of a single main repository while keeping their histories and development separate.
