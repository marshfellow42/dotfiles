#!/usr/bin/env python3
import subprocess
import shutil
import platform
import sys
from pathlib import Path

def ubuntu_setup():
    print("Detected Ubuntu/Debian. Starting setup...")
    
    if not shutil.which("ansible"):
        subprocess.run(["sudo", "apt-get", "update"], shell=True, check=True)
        subprocess.run(["sudo", "apt-get", "upgrade"], shell=True, check=True)
        subprocess.run(["sudo", "apt-get", "install", "-y", "software-properties-common"], shell=True, check=True)
        subprocess.run(["sudo", "apt-get", "install", "-y", "ansible", "python3-argcomplete"], shell=True, check=True)

    if not shutil.which("python3"):
        subprocess.run(["sudo", "apt-get", "install", "-y", "python3"], shell=True, check=True)

    # Handling Ubuntu versioning for Pip/Watchdog
    # Example: version 22.04 -> 22
    major_version = int(platform.release().split('.')[0])
    
    try:
        os_info = platform.freedesktop_os_release()
        major_version = int(os_info.get("VERSION_ID", "0").split('.')[0])
    except AttributeError:
        pass

    if major_version <= 22:
        subprocess.run(["sudo", "apt-get", "install", "-y", "python3-pip", "python3-watchdog"], shell=True, check=True)

def arch_setup():
    if shutil.which("yay"):
        subprocess.run(["yay", "-Syu", "--noconfirm"], shell=True, check=True)
    else:
        subprocess.run(["sudo", "pacman", "-Syu", "--noconfirm"], shell=True, check=True)
    
    pkgs = ["uv", "ansible"]
    
    for pkg in pkgs:
        check = subprocess.run(["pacman", "-Qq", pkg], capture_output=True, text=True)
        if check.returncode != 0:
            subprocess.run(["sudo", "pacman", "-S", "--noconfirm", pkg], shell=True, check=True)

def macos_setup():
    print("Detected macOS. Starting setup...")
    if not shutil.which("brew"):
        subprocess.run(["/bin/bash", "-c", "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"], shell=True, check=True)
    
    tools = ["git", "ansible", "1password-cli"]
    for tool in tools:
        if not shutil.which(tool):
            subprocess.run(["brew", "install", tool], shell=True, check=True)

def run_os_setup():
    system = platform.system()
    distro = "unknown"

    match system:
        case "Linux":
            distro = platform.freedesktop_os_release().get("ID", "").lower()
            
            match distro:
                case "ubuntu" | "debian":
                    ubuntu_setup()
                case "arch":
                    arch_setup()
                case _:
                    print(f"Linux distribution '{distro}' is not supported.")
                    sys.exit(1)

        case "Darwin":
            distro = "macos"
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
            subprocess.run(["uv", "tool", "install", ".", "--force"], shell=True, check=True)
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
                
            print("--> Running ansible-galaxy install...")
            subprocess.run(galaxy_cmd, check=True)
        except FileNotFoundError:
            print("Error: ansible-galaxy is not installed or not found in your PATH.")
            sys.exit(1)

if __name__ == "__main__":
    run_os_setup()