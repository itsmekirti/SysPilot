# Git and GitHub Setup

## Objective

The purpose of this document is to configure Git and GitHub for the SysPilot project.

After completing this setup, the project is version controlled locally using Git and backed up remotely on GitHub.

---

# 1. What is Git?

Git is a Distributed Version Control System (DVCS).

It tracks every change made to a project and allows developers to save project history, restore previous versions, and collaborate with others.

Think of Git as a time machine for your code.

---

# 2. Why Git?

Git helps developers to:

- Track changes
- Restore previous versions
- Work on multiple features
- Collaborate with teams
- Maintain project history
- Backup project source code

---

# 3. Git Installation

## Check whether Git is installed

```bash
git --version
```

Example Output

```
git version 2.43.0
```

If Git is already installed, it displays the installed version.

If Git is not installed:

```bash
sudo apt update
sudo apt install git
```

Verify installation again.

```bash
git --version
```

---

# 4. Configure Git

Set Username

```bash
git config --global user.name "Kirti Garg"
```

Set Email

```bash
git config --global user.email "your_email@example.com"
```

Verify Configuration

```bash
git config --global --list
```

Git stores this information with every commit.

---

# 5. What is GitHub?

GitHub is a cloud-based platform used to host Git repositories.

It allows developers to:

- Store projects online
- Backup source code
- Collaborate with teams
- Share open-source projects
- Build a professional portfolio

Git works locally.

GitHub stores Git repositories on the cloud.

---

# 6. Git vs GitHub

| Git | GitHub |
|------|---------|
| Version Control System | Cloud Platform |
| Installed locally | Website |
| Works offline | Requires Internet |
| Tracks project history | Hosts Git repositories |

---

# 7. What is SSH?

SSH stands for **Secure Shell**.

SSH is a secure communication protocol that allows your computer to authenticate with GitHub without entering your username and password every time.

---

# 8. Public Key vs Private Key

SSH creates two keys.

## Public Key

- Shared with GitHub
- Used for identification
- Safe to share

## Private Key

- Stored only on your computer
- Never shared
- Used for authentication

SSH Key Files

```
~/.ssh/

id_ed25519

id_ed25519.pub
```

---

# 9. Why Ed25519?

Ed25519 is a modern cryptographic algorithm.

GitHub recommends it because it is:

- Faster
- More secure
- Smaller key size
- Better performance than RSA

---

# 10. Generate SSH Key

Generate SSH Key

```bash
ssh-keygen -t ed25519
```

Press Enter for all default options.

Display Public Key

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the complete output.

---

# 11. Add SSH Key to GitHub

Open GitHub

↓

Settings

↓

SSH and GPG Keys

↓

New SSH Key

↓

Paste the copied public key

↓

Save

---

# 12. Verify SSH Connection

Run

```bash
ssh -T git@github.com
```

Expected Output

```
Hi itsmekirti!

You've successfully authenticated,
but GitHub does not provide shell access.
```

This confirms that GitHub recognizes your computer.

---

# 13. Create Project Folder

Navigate to the Projects directory.

```bash
cd ~/Project
```

Create the project.

```bash
mkdir SysPilot
```

Move inside the project.

```bash
cd SysPilot
```

---

# 14. Open Project in VS Code

Open the current project.

```bash
code .
```

Visual Studio Code opens the SysPilot folder.

---

# 15. Create Documentation Folder

Create a folder named:

```
docs
```

Inside the docs folder create

```
01-Environment-Setup.md
```

This file stores the environment setup documentation.

---

# 16. Initialize Git Repository

Initialize Git.

```bash
git init
```

Git creates a hidden directory.

```
.git
```

The `.git` folder stores:

- Commit history
- Branches
- Repository configuration
- Logs
- Project metadata

Check hidden files.

```bash
ls -la
```

Check repository status.

```bash
git status
```

---

# 17. Create the First Commit

Stage all files.

```bash
git add .
```

Check status.

```bash
git status
```

Create the first commit.

```bash
git commit -m "Initial project setup and environment documentation"
```

A commit creates a permanent snapshot of the project.

---

# 18. Create GitHub Repository

Open GitHub.

Click

```
New Repository
```

Repository Name

```
SysPilot
```

Visibility

```
Public
```

Do not select

- Add README
- Add .gitignore
- Add License

Click

```
Create Repository
```

---

# 19. Connect Local Repository to GitHub

Add the GitHub repository.

```bash
git remote add origin git@github.com:itsmekirti/SysPilot.git
```

Verify.

```bash
git remote -v
```

Expected Output

```
origin git@github.com:itsmekirti/SysPilot.git (fetch)

origin git@github.com:itsmekirti/SysPilot.git (push)
```

---

# 20. Push Project to GitHub

Push the project.

```bash
git push -u origin main
```

Meaning

- git push → Upload local commits
- -u → Set upstream branch
- origin → GitHub repository nickname
- main → Branch name

After the first push

```bash
git push
```

is enough.

---

# 21. Git Workflow

```
Create Files
      │
      ▼
git status
      │
      ▼
git add .
      │
      ▼
git commit
      │
      ▼
git push
      │
      ▼
GitHub
```

---
