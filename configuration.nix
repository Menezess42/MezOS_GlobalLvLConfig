{ config, pkgs, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "nixos"; # Define your hostname.
        networking.networkmanager.enable = true;

    time.timeZone = "America/Sao_Paulo";

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

    services.xserver.enable = true;

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

    services.xserver.xkb = {
        layout = "br";
        variant = "nodeadkeys";
    };

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


    services.printing.enable = true;

    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
        enable = true; # if not already enabled
            alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };
    users.users.menezess42 = {
        isNormalUser = true;
        description = "Menezess42";
        extraGroups = [ "networkmanager" "wheel" ];
        shell=pkgs.zsh;
    };

    programs.firefox.enable = true;

    nixpkgs.config = {
        allowUnfree = true;
        doCheck = false;
    };
    environment.systemPackages = with pkgs; [
        qt6.qtwayland
            qt6Packages.qtwayland
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
            papirus-icon-theme
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
    };
    programs.zsh.enable = true;
    stylix ={
        enable=true;
        image = ./wall.png;
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

boot.kernelParams = ["nvidia-drm.modeset=1"];
hardware.opengl.enable=true;
# environment.sessionVariables.NIXOS_OZONE_WL="1";
}
