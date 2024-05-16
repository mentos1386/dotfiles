{ lib, config, pkgs, ... }:

{
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
    yq
    fd
    fzf
    gnumake
    age
    sops
    http-prompt
    watchexec
    devbox
    nodePackages.prettier
    direnv
    sqlfluff
    tree
    redis
    dive
    ctop
    bottom
    tailscale

    # Nodejs
    nodejs_20
    deno

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

    # Services
    terraform
    opentofu
    flyctl
    awscli2

    # Kubernetes
    k9s
    kubectl
    kubectx
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
    "${config.xdg.configHome}/Code/User" = {
      recursive = true;
      source = ../code;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Tine";
    userEmail = "tine@tjo.space";

    difftastic.enable = true;
    lfs.enable = true;

    includes = [
      { path = "~/.gitconfig.local"; }
    ];

    extraConfig = {
      user = {
        signingkey = "~/.ssh/id_ed25519";
      };

      rerere = {
        enabled = true;
      };

      commit = {
        gpgsign = true;
      };

      gpg = {
        format = "ssh";
      };

      credential = {
        helper = "secretservice";
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

  programs.direnv = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    history = {
      size = 10000000;
      save = 10000000;
      ignoreAllDups = true;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    autosuggestion.enable = true;
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
