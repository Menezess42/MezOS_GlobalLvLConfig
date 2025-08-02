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
    environment.sessionVariables = {WL_NO_HARDWARE_CURSOR="1";};
    xdg.portal.enable = true;
    # xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk  pkgs.xdg-desktop-portal-wlr ];


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
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
        enable = true; # if not already enabled
            alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
# If you want to use JACK applications, uncomment the following
#jack.enable = true;
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

    nixpkgs.config = {
        allowUnfree = true;
        doCheck = false;
    };
# List packages installed in system profile. To search, run:
# $ nix search wget
    environment.systemPackages = with pkgs; [
        qt6.qtwayland
            qt6Packages.qtwayland
#nvtop
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
#obs-studio
            xdg-desktop-portal
            xdg-desktop-portal-wlr
            wl-clipboard
            grim
            slurp
            krita
            xorg.xorgserver
            wayland-protocols
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
    system.stateVersion = "25.11"; # Did you read the comment?
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
        image = ./wall.png;
#base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
        override = {
            base00 = "22303c";  # Fundo acinzentado azulado, confortável
                base01 = "2e3c48";  # Cinza escuro para status bars
                base02 = "3b4a56";  # Cinza médio para linhas ou blocos secundários
                base03 = "56636f";  # Comentários (cinza mais visível)
                base04 = "81a1c1";  # Azul claro (constantes, destaque leve)
                base05 = "d8dee9";  # Texto principal
                base06 = "e5e9f0";  # Brancos suaves, para negrito ou títulos
                base07 = "eceff4";  # Branco mais puro (não muito usado)
                base08 = "bf616a";  # Vermelho suave (erros, palavras-chave)
                base09 = "d08770";  # Laranja queimado (funções)
                base0A = "ebcb8b";  # Amarelo desaturado (tipos, avisos)
                base0B = "a3be8c";  # Verde suave (strings)
                base0C = "88c0d0";  # Ciano claro (built-in, números)
                base0D = "81a1c1";  # Azul para variáveis
                base0E = "b48ead";  # Roxo suave (keywords secundárias)
                base0F = "5e81ac";  # Azul escuro (debug, outros)

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


### Tests for try to solve Obsidian hyprland flickering
boot.kernelParams = ["nvidia-drm.modeset=1"];
hardware.opengl.enable=true;
environment.sessionVariables.NIXOS_OZONE_WL="1";


}
