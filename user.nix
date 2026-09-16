# User Configuration
{ config, pkgs, zen-browser, ... }:

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
      kitty zen-browser obsidian
      junction opencode nodejs_26
    ];
  };
  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      # add_newline = false;

      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };

      # package.disabled = true;
    };
  };
  environment.sessionVariables = {
    # NIXPKGS_OPENCODE_DISABLE_LEGACY_DB_WORKAROUND = "1";
    # NIXOS_OZONE_WL = "1";
  };
}
