# Linux From Zero

## Day 1 – Environment Setup

**Author:** Kirti Garg

**Goal:** Set up a complete Linux development environment on Windows using WSL, Ubuntu, VS Code, Git, and GitHub.

---

# 1. What is WSL?

**WSL (Windows Subsystem for Linux)** allows us to run Linux directly inside Windows without installing a virtual machine or dual booting.

Instead of creating a separate operating system, WSL provides a Linux environment that works alongside Windows.

### Why do we use WSL?

* Run Linux commands on Windows.
* Learn Linux without formatting the computer.
* Develop Linux applications easily.
* Use Bash, Git, Python, Docker, etc.
* Works perfectly with VS Code.

### Architecture

```
Windows
    │
    ▼
WSL
    │
    ▼
Ubuntu Linux
    │
    ▼
Bash Terminal
```

---

# 2. Installing WSL

### Step 1

Open **Command Prompt** or **PowerShell** as Administrator.

### Step 2

Check WSL status.

```powershell
wsl --status
```

If WSL is not installed,

```powershell
wsl --install
```

---

# Problem I Faced

The installation was not working.

Commands like

```powershell
wsl --install
```

and

```powershell
wsl -l -o
```

were timing out.

---

# Root Cause

The required Windows features were disabled.

When I checked using DISM, I found:

```
Microsoft-Windows-Subsystem-Linux    Disabled

VirtualMachinePlatform               Disabled
```

Without these two features, WSL cannot work.

---

# Solution

Enable WSL

```powershell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

Enable Virtual Machine Platform

```powershell
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Restart the computer.

---

# Another Problem

After enabling both features,

```
wsl --status
```

showed

```
The WSL 2 kernel file is not found.
```

---

# Solution

Run

```powershell
wsl --update
```

This downloaded and installed the latest WSL kernel.

---

# Verify Installation

```powershell
wsl --status
```

Output

```
Default Version: 2

WSL automatic updates are on.
```

---

# Important Commands

```powershell
wsl --status #(Displays the current WSL installation status, default version, and kernel information)

wsl --update #(Downloads and installs the latest WSL kernel and updates WSL to the newest version.)

wsl --install #( Installs Windows Subsystem for Linux along with the default Linux distribution (Ubuntu).)

wsl -l -v #(Lists all installed Linux distributions and shows their WSL version and current status.)
```

---

# 3. Ubuntu Installation

## What is Ubuntu?

Ubuntu is a Linux Operating System based on Debian.

It is beginner-friendly, stable, and one of the most popular Linux distributions.

We installed Ubuntu because our SysPilot project will be developed in Linux.

---

## Install Ubuntu

```powershell
wsl --install -d Ubuntu
```

After installation,

Ubuntu asked for

```
Username
```

Example

```
kirti
```

Then

```
Password
```

The password is **not visible while typing**.

This is normal Linux behavior.

---

# Linux Prompt

After successful installation

```
kirti@DESKTOP-KEMA9PL:~$
```

Meaning

```
kirti
```

Current Linux user

```
DESKTOP-KEMA9PL
```

Computer name

```
~$
```

Current directory (Home directory)

---

# 4. Installing VS Code

Download VS Code from

[https://code.visualstudio.com/](https://code.visualstudio.com/)

Install normally.

---

# Connecting VS Code with Ubuntu

Install the extension

```
WSL
```

published by Microsoft.

Open Ubuntu terminal.

Run

```bash
code .
```

VS Code opens inside Ubuntu.

Bottom left corner should show

```
WSL: Ubuntu
```

This means VS Code is connected to Linux.

---

# Why use VS Code with WSL?

Instead of writing Linux code in Windows,

VS Code directly edits files inside Ubuntu.

```
Windows

↓

VS Code

↓

Ubuntu

↓

Linux Files
```

---

# 5. Git

## What is Git?

Git is a Version Control System.

It tracks every change made to your project.

Think of Git as a "Time Machine".

If you accidentally delete code,

Git can restore previous versions.

---

# Configure Git

Set username

```bash
git config --global user.name "Kirti Garg"
```

Set email

```bash
git config --global user.email "your_email@example.com"
```

Check configuration

```bash
git config --global --list
```

---

# Git vs GitHub

## Git

Software installed on your computer.

Tracks project versions.

Works offline.

---

## GitHub

Website where Git repositories are stored.

Used for

* Backup
* Collaboration
* Portfolio
* Open Source

---

# 6. SSH Key

## What is SSH?

SSH stands for

**Secure Shell**

It provides a secure way to communicate with another computer or server.

---

# Why do we need SSH for GitHub?

GitHub must verify your identity before allowing you to push code.

Instead of entering a password every time,

SSH uses cryptographic keys.

---

# Public Key and Private Key

When we generate SSH keys,

Linux creates two files.

```
id_ed25519
```

Private Key

Never share it.

```
id_ed25519.pub
```

Public Key

Upload it to GitHub.

---

# What is Ed25519?

Ed25519 is a modern cryptographic algorithm used to generate SSH keys.

It is

* Faster
* More secure
* Smaller key size
* Recommended by GitHub

---

# Generate SSH Key

```bash
ssh-keygen -t ed25519
```

Press Enter for all default options.

---

# View Public Key

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the output.

---

# Add Key to GitHub

GitHub

↓

Settings

↓

SSH and GPG Keys

↓

New SSH Key

↓

Paste the public key

↓

Save

---

# Test SSH Connection

```bash
ssh -T git@github.com
```

Expected Output

```
Hi itsmekirti!

You've successfully authenticated,
but GitHub does not provide shell access.
```

This confirms that GitHub successfully recognizes your computer.

---

