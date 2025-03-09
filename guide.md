# Install guide for my dotfiles

- Install Arch Linux

- Use archinstall for installing Hyprland and setting up my environment
```bash
archinstall
```

- After installing, clone the dotfiles repo
```bash
git clone https://github.com/marshfellow42/dotfiles.git
```

- Run the setup script
```bash
./setup.sh
```

- After the setup is finished, install the apps
```bash
./install/install.sh
```

- Copy the cronjob.txt content to crontab
```bash
crontab -e
```

- Copy the .config folder to the Home directory
```bash
cp ./.config ~/
```
