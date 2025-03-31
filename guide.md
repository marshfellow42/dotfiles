# Install guide for my dotfiles

- Install [Arch Linux](https://archlinux.org/download/)

- Use archinstall for installing Hyprland and setting up my environment
```bash
archinstall
```

- After installing Hyprland, install Git
```bash
sudo pacman -S git
```

- After installing Git, clone the dotfiles repo
```bash
git clone https://github.com/marshfellow42/dotfiles.git ~/
```

- Run the setup script
```bash
./setup.sh
```
