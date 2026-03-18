# Managing Dotfiles with Git Submodules, Stow, and a Custom Script

This document outlines the methodology used in this repository to manage dotfiles, focusing on the interplay between Git submodules, the `stow` utility, and the `apply-dotfiles.sh` script. This approach allows for modular, version-controlled management of configurations across different tools.

## Git Submodules for Dependency Management

This repository utilizes Git submodules to incorporate and manage external repositories as dependencies. This is particularly useful for including third-party tools, themes, or plugins without directly copying their code into this repository.

### How it Works

- **`.gitmodules` File:** This file at the root of the repository defines the submodules, mapping a path within this repository to the URL of the external repository.
- **`git submodule` Commands:**
    - `git submodule add <repository_url> <path>`: Adds a new submodule.
    - `git submodule update --init --recursive`: Initializes and clones the submodules listed in the `.gitmodules` file. The `--recursive` flag handles nested submodules.
    - `git submodule update --remote`: Updates the submodules to the latest commit on their respective remote branches.

This setup ensures that the dotfiles repository remains self-contained and that all necessary dependencies are tracked and can be easily installed.

## `stow` for Symbolic Linking

The `stow` command-line utility is used to create and manage symbolic links (symlinks) from the files in this repository to their correct locations in the user's home directory (`$HOME`).

### Key Concepts

- **Stow Directories:** Each top-level directory within this repository (e.g., `zsh`, `git`, `nvim`) is a "stow directory," containing the dotfiles for a specific application.
- **Target Directory:** The `$HOME` directory is the target for the symlinks.
- **Symlinking Process:** `stow` intelligently creates symlinks for files and directories within each stow directory to their corresponding paths in the target directory. For example, a file at `nvim/.config/nvim/init.lua` in this repository would be symlinked to `~/.config/nvim/init.lua`.

This method avoids duplicating files and allows all dotfiles to be managed under a single version-controlled repository.

## `apply-dotfiles.sh` for Automation

The `apply-dotfiles.sh` script automates the process of applying the dotfiles using `stow`.

### Script Breakdown

```sh
#!/bin/sh
for symlink in zsh git karabiner nvim editorconfig starship ghostty k9s claude-skills emacs; do
  stow -v -t "$HOME" "$symlink"
done
```

- **Looping through Stow Directories:** The script iterates through a predefined list of directories (`zsh`, `git`, etc.).
- **Invoking `stow`:** For each directory, it runs `stow -v -t "$HOME" "$symlink"`:
    - `-v` (verbose): Prints details about the links being created or removed.
    - `-t "$HOME"`: Specifies the target directory for the symlinks (the user's home directory).
    - `"$symlink"`: The name of the stow directory to process.

To apply the dotfiles, one simply needs to execute this script from the root of the repository.

## Workflow Summary

1.  **Initial Setup:**
    ```sh
    # Clone the repo and initialize all submodules
    git clone --recurse-submodules <repository_url>
    cd <repository_directory>
    ```
2.  **Apply Dotfiles:**
    ```sh
    ./apply-dotfiles.sh
    ```
3.  **Updating an Existing Clone:** When pulling changes, especially if new submodules have been added, run the following:
    ```sh
    git pull
    # Initializes any new submodules and updates existing ones to the recorded commit
    git submodule update --init --recursive
    ```
4.  **Updating Submodules to Latest:** To update all submodules to the latest commit on their remote branch:
    ```sh
    # This fetches the latest changes from the submodule remotes
    git submodule update --recursive --remote
    ```

By following this structure, the repository provides a robust and maintainable system for managing dotfiles and their dependencies.
