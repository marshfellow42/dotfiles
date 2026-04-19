#!/usr/bin/env python3
import subprocess
import shutil
import platform
import sys
from pathlib import Path

def run_cmd(command):
    # Helper to run shell commands and handle errors.
    try:
        # shell=True is needed for piped commands or sudo strings
        subprocess.run(command, shell=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error executing {command}: {e}")

def ubuntu_setup():
    print("Detected Ubuntu/Debian. Starting setup...")
    
    # Check for Ansible using shutil.which()
    if not shutil.which("ansible"):
        run_cmd("sudo apt-get update")
        run_cmd("sudo apt-get upgrade")
        run_cmd("sudo apt-get install -y software-properties-common")
        run_cmd("sudo apt-add-repository -y ppa:ansible/ansible")
        run_cmd("sudo apt-get install -y ansible python3-argcomplete")

    if not shutil.which("python3"):
        run_cmd("sudo apt-get install -y python3")

    # Handling Ubuntu versioning for Pip/Watchdog
    # Example: version 22.04 -> 22
    major_version = int(platform.release().split('.')[0]) 
    # Note: On Linux, platform.freedesktop_os_release() is more accurate for VERSION_ID
    try:
        os_info = platform.freedesktop_os_release()
        major_version = int(os_info.get("VERSION_ID", "0").split('.')[0])
    except AttributeError: pass

    if major_version <= 22:
        run_cmd("sudo apt-get install -y python3-pip python3-watchdog")

def arch_setup():
    if shutil.which("yay"):
        run_cmd("yay -Syu --noconfirm")
    else:
        run_cmd("sudo pacman -Syu --noconfirm")
    
    pkgs = ["uv", "ansible", "python-argcomplete", "python-watchdog", "openssh", "git"]
    
    for pkg in pkgs:
        check = subprocess.run(["pacman", "-Qq", pkg], capture_output=True, text=True)
        if check.returncode != 0:
            run_cmd(f"sudo pacman -S --noconfirm {pkg}")

def macos_setup():
    print("Detected macOS. Starting setup...")
    if not shutil.which("brew"):
        run_cmd('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"')
    
    tools = ["git", "ansible", "1password-cli"]
    for tool in tools:
        if not shutil.which(tool):
            run_cmd(f"brew install {tool}")

def run_os_setup():
    system = platform.system()

    match system:
        case "Linux":
            distro = platform.freedesktop_os_release().get("ID", "").lower()
            
            match distro:
                case "ubuntu" | "debian":
                    ubuntu_setup()
                case "arch":
                    arch_setup()
                case "fedora":
                    fedora_setup()
                case _:
                    print(f"Linux distribution '{distro}' is not supported.")
                    sys.exit(1)

        case "Darwin":
            macos_setup()

        case "Windows":
            print("Windows is not supported.")
            sys.exit(1)

        case _:
            print(f"Operating system '{system}' is not supported.")
            sys.exit(1)

    tool_check = subprocess.run(["uv", "tool", "list"], capture_output=True, text=True)
    if "dotfiles" not in tool_check.stdout:
        try:
            print("Installing dotfiles tool via uv...")
            run_cmd("uv tool install . --force")
        except FileNotFoundError:
            print("Error: uv is not installed or not found in your PATH.")
            sys.exit(1)

    script_dir = Path(__file__).resolve().parent
    requirements_dir = script_dir.parent / "requirements"
    
    common_reqs = requirements_dir / "common.yml"
    os_reqs = requirements_dir / f"{distro}.yml"
    
    ansible_galaxy_check = subprocess.run(["ansible-galaxy", "collection", "list"], capture_output=True, text=True)
    if "kewlfft.aur" not in ansible_galaxy_check.stdout or "community.general" not in ansible_galaxy_check.stdout:
        try:
            galaxy_cmd = ["ansible-galaxy", "install", "-r", str(common_reqs)]
            
            if os_reqs.exists():
                print(f"Adding OS-specific requirements: {os_reqs.name}")
                galaxy_cmd.extend([str(os_reqs)])
                
            print(f"--> Running ansible-galaxy install...")
            subprocess.run(galaxy_cmd, check=True)
        except FileNotFoundError:
            print("Error: ansible-galaxy is not installed or not found in your PATH.")
            sys.exit(1)