# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

# Set DEBUG_MODE to 1 to disable all the lengthy shit.
DEBUG_MODE=1

# If the old files isn't removed, the duplicate APT alias will break sudo!
# Don't need this.
#sudoers_old="/etc/sudoers.d/sudoers-cowboy"; [[ -e "$sudoers_old" ]] && sudo rm "$sudoers_old"

# Installing this sudoers file makes life easier.
sudoers_file="sudoers-dotfiles"
sudoers_src=~/.dotfiles/conf/ubuntu/$sudoers_file
sudoers_dest="/etc/sudoers.d/$sudoers_file"
if [[ ! -e "$sudoers_dest" || "$sudoers_dest" -ot "$sudoers_src" ]]; then
  cat <<EOF
The sudoers file can be updated to allow certain commands to be executed
without needing to use sudo. This is potentially dangerous and should only
be attempted if you are logged in as root in another shell.

This will be skipped if "Y" isn't pressed within the next 15 seconds.
EOF
  read -N 1 -t 15 -p "Update sudoers file? [y/N] " update_sudoers; echo
  if [[ "$update_sudoers" =~ [Yy] ]]; then
    e_header "Updating sudoers"
    visudo -cf "$sudoers_src" >/dev/null && {
      sudo cp "$sudoers_src" "$sudoers_dest" &&
      sudo chmod 0440 "$sudoers_dest"
    } >/dev/null 2>&1 &&
    echo "File $sudoers_dest updated." ||
    echo "Error updating $sudoers_dest file."
  else
    echo "Skipping."
  fi
fi

# I hate PPAs, but they make my life easier so...
e_header "Adding APT repositories"
sudo add-apt-repository -y ppa:indicator-multiload/stable-daily
sudo add-apt-repository -y ppa:webupd8team/atom
sudo add-apt-repository -y ppa:noobslab/themes
sudo add-apt-repository -y ppa:webupd8team/java

# Add Spotify
sudo sh -c 'echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list.d/spotify.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59

# Remove APT packages first so we don't update them.  Teh bandwidth.
remove_packages=(
  evolution-common
  totem-common
  f-spot
  tomboy
  computer-janitor
  gnome-orca
  gnome-pilot
  vino
  vinagre
  gnome-accessibility-themes
  gnome-doc-utils
  gcalctool
  gucharmap
  ubuntuone-client
  whoopsie
  thunderbird
  rhythmbox
  transmission-common
)

remove_list=()
e_header "Removing APT packages: ${remove_packages[*]}"
sudo apt-get -qq remove ${remove_packages[*]}

if [[ "${DEBUG_MODE}" == "0" ]]
then
  # Update APT.
  e_header "Updating APT"
  sudo apt-get -qq update
  sudo apt-get -qq dist-upgrade


  # Install APT packages.
  install_packages=(
    build-essential libssl-dev oracle-java8-installer
    git-core
    tree sl cowsay
    nmap telnet sipcalc
    htop
    virtualbox
    indicator-multiload
    atom
    chromium-browser
    spotify-client
    unity-tweak-tool numix-bluish-theme
  )

  install_list=()
  for package in "${install_packages[@]}"; do
    if [[ ! "$(dpkg -l "$package" 2>/dev/null | grep "^ii  $package")" ]]; then
      install_list=("${install_list[@]}" "$package")
    fi
  done

  if (( ${#install_list[@]} > 0 )); then
    e_header "Installing APT packages: ${install_list[*]}"
    for package in "${install_list[@]}"; do
      sudo apt-get -qq install "$package"
    done
  fi
fi

# Autoremove to clean up
e_header "Autoremove APT cleanup"
sudo apt-get -qq autoremove

# Install Git Extras
#if [[ ! "$(type -P git-extras)" ]]; then
#  e_header "Installing Git Extras"
#  (
#    cd ~/.dotfiles/libs/git-extras &&
#    sudo make install
#  )
#fi

# Fix ubuntu
e_header "Running fixubuntu.sh (fixubuntu.com)"
sudo wget -q -O - https://fixubuntu.com/fixubuntu.sh | bash

# Remove Amazon Icon from Launcher
e_header "Removing Amazon Icon and search scopes"
sudo mv /usr/share/applications/ubuntu-amazon-default.desktop /usr/share/applications/ubuntu-amazon-default.desktop.old

sudo gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"

# Disable ubuntu scroll bar
e_header "Disabling weird Ubuntu scrollbar"
sudo gsettings set com.canonical.desktop.interface scrollbar-mode normal

# Disable guest account login
e_header "Disabling guest account login"
sudo echo allow-guest=false | sudo tee -a /usr/share/lightdm/lightdm.conf.d/50-ubuntu.conf

# Remove white dots login screen
e_header "Removing white dots on login...annoying"
sudo xhost +SI:localuser:lightdm
sudo su lightdm -s /bin/bash
gsettings set com.canonical.unity-greeter draw-grid false;exit

# Download and install synergy
e_header "Downloading and installing Synergy"
wget http://synergy-project.org/files/packages/synergy-1.5.0-r2278-Linux-x86_64.deb
sudo dpkg -i synergy-1.5.0-r2278-Linux-x86_64.deb

# Disable god damn oneservice.  Can't remove the damn thing so let's stop it from running!
sudo chmod a-x /usr/share/oneconf/oneconf-service
sudo chmod a-x /usr/share/oneconf/oneconf-query
sudo chmod a-x /usr/share/oneconf/oneconf-update
