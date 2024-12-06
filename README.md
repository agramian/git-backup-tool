# Git Backup Tool

A simple shell script to backup Git repositories as compressed bundles for long-term storage.

## Features
- Clones repositories in bare format
- Creates a Git bundle with all history and refs
- Verifies the bundle integrity
- Compresses the bundle for efficient storage

## Usage

1. Create a file containing the list of Git repository URLs (one per line):
    ```
    https://github.com/example/repo1.git
    ssh://git@github.com:/example/repo2.git
    # Skip the following commented out repo.
    # ssh://git@github.com:/example/repo3.git
    ```

2. Run the script:
    ```bash
    ./git-backup.sh <repo_list_file> <output_directory>
    ```

    - `repo_list_file`: Path to the file with repository URLs.
    - `output_directory`: Directory to store backups.

3. Example:
    ```bash
    ./git-backup.sh repos.txt backups/
    ```

4. The backups will be stored as compressed `.tar.gz` files in the specified output directory.

## Prerequisites
- `git` (to clone repositories and create bundles)
- `tar` (to compress the bundles)

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
