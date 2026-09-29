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
      docker cloudflare-warp claude-code
      texliveFull onlyoffice-desktopeditors
    ];
  };
  programs.starship = {
    enable = true;
  };

  programs.steam.enable = true;

  
  environment.sessionVariables = {
    # NIXPKGS_OPENCODE_DISABLE_LEGACY_DB_WORKAROUND = "1";
    # NIXOS_OZONE_WL = "1";
  };

  programs.bash.shellAliases = {
    disk = "cd /run/media/sharwesh/Disk";
  };
}
