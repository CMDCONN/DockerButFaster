# DockerButFaster (Ubuntu branch)

A simple shell-based tool that installs Docker on your system and manages which users have permission to run Docker commands without `sudo`.

## What This Does

- Checks whether Docker is already installed on the system
- Installs Docker if it's missing
- Lists existing users on the system
- Lets you select a user to grant Docker access to
- Adds the selected user to the `docker` group via `usermod`

## Requirements

- A Linux system (tested on Debian/Ubuntu-based distributions)
- `sudo` privileges
- `bash`

## Installation

Clone or download this repository, then make the script executable:

```bash
chmod +x DockerButFaster.sh
```

## Usage

Run the script with:

```bash
./DockerButFaster.sh
```

You'll be guided through the following steps:

1. **Docker version check** — the script checks if Docker is installed by running `docker --version`. If it's not found, Docker will be installed automatically.
2. **User privilege prompt** — you'll be asked whether you want to update user privileges to allow Docker access without `sudo`.
3. **User list** — if you choose yes, a list of existing users on the system (UID 1000 and above) will be displayed.
4. **User selection** — enter the username of the account you want to add to the `docker` group.
5. **Group update** — the script runs `sudo usermod -aG docker <username>` to grant access.

## Important Notes

- **Log out and back in** (or run `newgrp docker`) after the script finishes for the group membership change to take effect. Group changes don't apply to your current session automatically.
- Adding a user to the `docker` group is roughly equivalent to giving that user root access, since Docker can be used to mount the host filesystem and run privileged containers. Only add users you trust with administrative-level access.
- The script filters out system accounts (UID below 1000) when listing users, so you should only see real human user accounts.

## Verifying the Setup

After logging back in, confirm the user can run Docker without `sudo`:

```bash
docker run hello-world
```

If this runs successfully without a permissions error, the setup is complete.

## Troubleshooting

| Issue | Possible Cause |
|---|---|
| `docker: command not found` after install | Shell session needs to be restarted, or PATH not updated |
| `permission denied` when running docker commands | Group change hasn't taken effect yet — log out and back in |
| User not found error | Username entered doesn't match an existing account — check with `cat /etc/passwd` |

## License

MIT License — feel free to modify and distribute.
