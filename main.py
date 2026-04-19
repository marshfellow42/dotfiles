#!/usr/bin/env python3
import typer
import subprocess
import tomllib
import shutil
import sys
import platform
from rich.console import Console
from rich_argparse import RichHelpFormatter
import install.setup
from typing import Optional
import time

console = Console()

try:
    with open("pyproject.toml", "rb") as f:
        data = tomllib.load(f)
except FileNotFoundError:
    console.print("[bold red]Error:[/bold red] pyproject.toml not found.")
    sys.exit(1)

app = typer.Typer(
    name=data["project"]["name"]
)

def run_step(cmd, description):
    with console.status(f"[{description}...", spinner="dots") as status:
        result = subprocess.run(cmd, check=False, capture_output=True, text=True)
        if result.returncode != 0:
            status.update(f"[bold red]✘[/bold red] {description} failed!")
            sys.exit(result.returncode)
        else:
            status.update(f"[bold green]✔[/bold green] {description} complete!")
    
def is_repo_up_to_date():
    try:
        # Update the local cache of the remote repo
        subprocess.run(["git", "fetch"], check=True, capture_output=True)
        
        # Compare local HEAD to the upstream branch
        # rev-list --count HEAD..@{u} counts commits that exist on remote but not locally
        result = subprocess.run(
            ["git", "rev-list", "--count", "HEAD..@{u}"],
            check=True,
            capture_output=True,
            text=True
        )
        
        # If count is '0', we are up to date
        return int(result.stdout.strip()) == 0
    except Exception:
        # If git isn't initialized or there's no upstream, assume we proceed
        return False

@app.callback(invoke_without_command=True)
def main(ctx: typer.Context):
    if ctx.invoked_subcommand is not None:
        return
    
    install.setup.run_os_setup()
    
    script_dir = Path(__file__).resolve().parent
    main_ansible_file = script_dir.parent / "main.yml"
    subprocess.run("ansible-playbook", main_ansible_file)

@app.command(help="Update the system and the dotfiles.")
def update():
    system = platform.system()

    match system:
        case "Linux":
            distro = platform.freedesktop_os_release().get("ID", "").lower()
            
            match distro:
                case "ubuntu" | "debian":
                    sys_cmd = ["sudo", "apt", "install", "-y", "&&", "sudo", "apt", "upgrade", "-y"]
                case "arch":
                    if shutil.which("yay"):
                        sys_cmd = ["yay", "-Syu", "--noconfirm"]
                    else:
                        sys_cmd = ["sudo", "pacman", "-Syu", "--noconfirm"]
                case "fedora":
                    sys_cmd = ["sudo", "dnf", "upgrade", "--refresh"]
                case _:
                    print(f"Linux distribution '{distro}' is not supported.")

        case "Darwin":
            sys_cmd = ["brew", "update", "&&", "brew", "upgrade"]

        case "Windows":
            print("Windows is not supported.")
            sys.exit(1)

        case _:
            print(f"Operating system '{system}' is not supported.")
            sys.exit(1)
            
    run_step(sys_cmd, "Updating system packages")
    
    if is_repo_up_to_date():
        console.print("[yellow]No git updates found. Skipping update.[/yellow]")
        return
    else:
        run_step(["git", "pull"], "Pulling latest git changes")

        run_step(["uv", "tool", "install", ".", "--force"], f"Updating tool")
        
@app.command(help="Show the version number for this dotfiles.")
def version():
    print(data["project"]["version"])
    
@app.command(help="Show the commands available for the dotfiles.")
def help(ctx: typer.Context):
    console.print(ctx.parent.get_help())

if __name__ == "__main__":
    app()