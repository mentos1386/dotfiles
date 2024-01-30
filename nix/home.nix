{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tine";
  home.homeDirectory = "/var/home/tine";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    git
    git-lfs
    difftastic

    # Tools
    ripgrep
    bat
    tmux
    jq
    fd
    fzf

    # Nodejs
    nodejs_20

    # Golang
    go
    gopls
    golangci-lint

    # C & CPP
    gcc

    # Rust
    cargo

    # Shell
    zsh
    shfmt

    # Lua
    stylua
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    "~/.tmux.conf".source = ../tmux/tmux.conf;
    "~/.ssh/authorized_keys".source = ../ssh/authorized_keys;
    "${config.xdg.configHome}/starship.toml".source = ../starship/starship.toml;
    "${config.xdg.configHome}/bat" = {
      recursive = true;
      source = ../bat;
    };
    "${config.xdg.configHome}/kitty" = {
      recursive = true;
      source = ../kitty;
    };
    "${config.xdg.configHome}/nvim" = {
      recursive = true;
      source = ../nvim;
    };
  };

  programs.git = {
    enable = true;
    userName = "Tine";
    userEmail = "tine@tjo.space";

    difftastic.enable = true;
    lfs.enable = true;

    extraConfig = {
      user = {
        signingkey = "~/.ssh/id_ed25519";
      };

      commit = {
        gpgsign = true;
      };

      gpg = {
        format = "ssh";
      };

      credentials = {
        helper = "libsecret";
      };

      init = {
        defaultBranch = "main";
      };

      push = {
        autoSetupRemote = true;
      };

      pull = {
        ff = "only";
      };
    };
  };

  programs.starship = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.zsh = {
    enable = true;
    history = {
      size = 10000000;
      save = 10000000;
      ignoreAllDups = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      "ll" = "ls -l";
      "gicm" = "(git checkout main || git checkout master) && git pull";
      "gic" = "git checkout";
      "gip" = "git pull";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
