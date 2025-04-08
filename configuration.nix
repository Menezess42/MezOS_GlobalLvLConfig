# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services={
	  displayManager.sddm = {
		  enable = true;
		  wayland = {
			  enable = true;
		  };
	  };
  };
  programs.hyprland = {
  enable = true;
  xwayland.enable = true; 
  };
  environment.sessionVariables = {WL_NO_HARDWARE_CURSOR="1"; NIXOS_OZONE_WL="1";};
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "nodeadkeys";
  };

  # Configure console keymap
  console = {keyMap = "br-abnt2";
  packages = [pkgs.terminus_font];
  font="${pkgs.terminus_font}/share/consolefonts/ter-i22.psf.gz";
  };

  fonts = {
	  packages = with pkgs;[
		  noto-fonts
			  noto-fonts-cjk-sans
			  noto-fonts-emoji
			  fira-code
			  fira-code-symbols
			  mplus-outline-fonts.githubRelease
			  dina-font
			  proggyfonts
			  (nerdfonts.override{fonts=["FiraCode" "DroidSansMono"];})
	  ];
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;

  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   # If you want to use JACK applications, uncomment this
  #   #jack.enable = true;
  #
  #   # use the example session manager (no others are packaged yet so this is enabled by default,
  #   # no need to redefine it in your config for now)
  #   #media-session.enable = true;
  # };
  services.pipewire = {
  enable = false;
  alsa.enable = false;
  pulse.enable = false;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.menezess42 = {
    isNormalUser = true;
    description = "Menezess42";
    extraGroups = [ "networkmanager" "wheel" ];
    shell=pkgs.zsh;
    # packages = with pkgs; [
    # git
    # kitty
    # chromium
    # ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  nvtop
  btop
  wget
  virtualglLib
  glxinfo
  pciutils
  mesa
  waybar
  swww
  rofi-wayland
  kitty
  ntfs3g
  lm_sensors
  #neovim
  # gst_all_1.gstreamer       
  # gst_all_1.gst-plugins-base
  # gst_all_1.gst-plugins-good
  # gst_all_1.gst-plugins-bad 
  # gst_all_1.gst-plugins-ugly
  # gst_all_1.gst-libav       
  papirus-icon-theme
  obs-studio
  krita
  ];
  systemd.user.services.invert-webcam ={
  description = "Inverter webcam image";
  wantedBy = [ "default.target" ];
  serviceConfig ={
    ExecStart = "${pkgs.gst_all_1.gstreamer}/bin/gst-launch-1.0 v4l2src device=/dev/video0 ! videoflip method=rotate-180 ! waylandsink";
    Restart = "always";
  };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  hardware.graphics = {
  enable = true;
  extraPackages = with pkgs; [vaapiVdpau nvidia-vaapi-driver ];
  };

  time.hardwareClockInLocalTime = true;

  fileSystems."/mnt/hdmenezess42" = {
  device = "/dev/sda1";
  fsType = "ntfs-3g";
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = false;
  powerManagement.finegrained = false;
  open = false;
  nvidiaSettings = true;
  #package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  programs.zsh.enable = true;
  stylix ={
    enable=true;
    image = ./dfw_new.png;
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    override = {
      base00 = "0a506e";  # Fundo escuro (azul profundo)
      base01 = "585f62";  # Cinza mais escuro para contraste sutil
      base02 = "653b27";  # Marrom escuro para elementos menos destacados
      base03 = "cc8f62";  # Comentários (marrom claro)
      base04 = "66a1b8";  # Azul médio para variáveis
      base05 = "e5dccb";  # Texto principal (cinza claro)
      base06 = "58c5cd";  # Azul ciano para destaques leves
      base07 = "548851";  # Verde suave para pequenos destaques
      base08 = "e35b22";  # Laranja vibrante (palavras-chave)
      base09 = "d19742";  # Funções (laranja suave)
      base0A = "cc8f62";  # Tipos (mesmo dos comentários)
      base0B = "84dcd4";  # Strings (ciano claro)
      base0C = "58c5cd";  # Constantes e built-in
      base0D = "66a1b8";  # Variáveis (azul médio)
      base0E = "653b27";  # Palavras-chave secundárias (marrom escuro)
      base0F = "66a1b8";  # Debug ou informativo
    };
    autoEnable = true;
  };

# programs.steam = {
# enable = true;
# remotePlay.openFirewall = true;
# dedicatedServer.openFirewall=true;
# localNetworkGameTransfers.openFirewall = true;
# };
    # services.xserver.displayManager.lightdm.greeters.slick.enable=true;
}
