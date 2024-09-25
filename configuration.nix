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

  networking.hostName = "renandl"; # Define your hostname.
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

  # Automatic garbage collection of entries
  nix.gc = {
  	automatic = true;
	dates = "weekly";
  	options = "-d";
  };
 
  # i3
  services.xserver = {
	enable = true;
		
	desktopManager = {
	#  xterm.enable = false;
	};
	
	windowManager.i3 = {
	 enable = true;
	 extraPackages = with pkgs; [ 
	  rofi
	  i3status
	 ];
	};
  };
  
  # making i3 default session
  services.displayManager.defaultSession = "none+i3";

  # Disabling mouse acceleration
  services.libinput = {
	enable = true;

	mouse = {
		accelProfile = "flat";
	};
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "abnt2";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.renandl = {
    isNormalUser = true;
    description = "Renan Bezerra Guima";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    # Text editor
	micro
	vscode
	
	# utilities
	fastfetch
	git
	git-credential-oauth
	kitty # Terminal
	nitrogen # Wallpaper Setter for i3
	pavucontrol
	playerctl
	tldr 
	unzip
	qalculate-qt	
	gh

	nnn # Terminal File explorer
	lf  # Terminal File explorer
	xfce.thunar # GUI File explorer

	# Apps
	okular # Kde Document viewer
	spotify
	obsidian
	dropbox
	megasync
	librewolf
	
	# Screenshot packages
	maim
	xclip
	
	# Python
	python
	python2
    ];

  # Enabling python2
  nixpkgs.config.permittedInsecurePackages = [
  	"python-2.7.18.8"
  ];

  # Flapak enable
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";

  # ZSH Terminal
  programs = {
  	zsh = {
  		enable = true;
  		autosuggestions.enable = true;
  		syntaxHighlighting.enable = true;
  		ohMyZsh = {
  			enable = true;
  			theme = "agnoster";
  		};
  	};
  };

  users.defaultUserShell = pkgs.zsh;

  # Audio
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Bluetooth
  # hardware.bluetooth.enable = true;
  # hardware.bluetooth.powerOnBoot = true;
  # services.blueman.enable = true;

  # Auto update
  system.autoUpgrade.enable = true;

  # Nerd Font
  fonts.packages = with pkgs; [
  	(nerdfonts.override { fonts = ["DaddyTimeMono"];})
  ];

  # Fix Windows Clock when dualboot
  time.hardwareClockInLocalTime = true;

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
  };
  
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Disabling suspend, hibernation
  systemd.sleep.extraConfig = ''
  	AllowSuspend=no
  	AllowHibernation=no
  	AllowHybridSleep=no
  	AllowSuspendThenHibernate=no
  '';
  
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
  system.stateVersion = "24.05"; # Did you read the comment?

}


