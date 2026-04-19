# dotfiles

This repo contains the configuration to setup my machines. This is using [Ansible](https://docs.ansible.com/), the dotfile manager to setup the install.

This repo is heavily influenced by [TechDufus](https://github.com/TechDufus/dotfiles)'s repo.

## How to install

Just run the bash file

```bash
curl -fsSL https://raw.githubusercontent.com/marshfellow42/dotfiles/main/install/install.sh | bash
```

Then, just run the dotfiles command

```bash
dotfiles
```

To update the dotfiles, just run the command below

```bash
dotfiles update
```