# User Configuration
{ config, pkgs, ... }:
{
  networking.hostName = "Sharwesh"; # Define your hostname.
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."sharwesh" = {
    isNormalUser = true;
    description = "Sharwesh";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # Accessories
      vscode obs-studio discord 
      gnome-extension-manager pavucontrol
      gnome-tweaks gh microsoft-edge
      opencode
    ];
  };

}
