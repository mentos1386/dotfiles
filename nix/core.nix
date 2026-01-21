{
  lib,
  config,
  pkgs,
  ...
}:

let
  gcloud = pkgs.google-cloud-sdk.withExtraComponents (
    with pkgs.google-cloud-sdk.components;
    [
      pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
    ]
  );
in
{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.enableNixpkgsReleaseCheck = false;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # VCS
    git
    git-lfs
    difftastic
    jujutsu

    # Tools
    ripgrep
    bat
    tmux
    jq
    yq
    fd
    eza
    fzf
    gnumake
    age
    sops
    watchexec
    devbox
    nodePackages.prettier
    direnv
    tree
    bottom
    nmap
    grpcurl
    jwt-cli
    just
    atuin
    bitwarden-cli

    # Refactoring
    ast-grep
    rename

    # VMs
    kraft
    qemu

    # Containers
    dive
    ctop
    skopeo
    buildah
    podman

    # JavaScript
    nodejs_24
    deno
    yarn

    # Python
    black

    # Golang
    go
    gopls
    golangci-lint

    # C & CPP
    gcc
    # This extension is needed for neovim:
    # Ref: https://codeberg.org/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
    vscode-extensions.ms-vscode.cpptools
    gdb

    # Rust
    cargo
    rustc
    vscode-extensions.vadimcn.vscode-lldb.adapter

    # Nix
    nil
    nixfmt-rfc-style
    nix-prefetch-scripts

    # Shell
    zsh
    shfmt
    shellcheck

    # Lua
    stylua

    # Databases
    redis
    mongodb-tools
    mongosh

    # Services
    tailscale
    flyctl
    awscli2
    gcloud
    # https://github.com/NixOS/nixpkgs/issues/380944
    # for now, installed with brew.
    #azure-cli

    # Terraform
    tenv
    tflint
    terraform-docs

    # Kubernetes
    kubernetes-helm
    k9s
    kubectl
    kubectx
    talosctl
    cilium-cli
    kubelogin-oidc
    kubebuilder
    chart-testing
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

    lfs.enable = true;

    includes = [ { path = "~/.gitconfig.local"; } ];

    signing = {
      #format = "ssh";
      key = "~/.ssh/id_ed25519";
      signByDefault = true;
    };

    settings = {
      user.name = "Tine";
      user.email = "tine@tjo.space";

      gpg = {
        format = "ssh";
      };

      rerere = {
        enabled = true;
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
      "cat" = "bat --plain";
      "find" = "fd";
      "ls" = "eza";
      "ll" = "eza -la";
      "gicm" = "(git checkout main || git checkout master) && git pull";
      "gic" = "git checkout";
      "gip" = "git pull";
      "ga" = "git add";
      "gc" = "git commit";
      "gr" = "git stash && gicm && git rebase main";
      "gs" = "git status";
      "gl" = "git log";
      "gp" = "git push";
      "k" = "kubectl";
      "g" = "git";
    };
    initContent = lib.mkOrder 1000 ''
      read_secret() {
        if command -v secret-tool >/dev/null; then
          secret-tool lookup $1 $2
        elif command -v security > /dev/null; then
          security find-generic-password -w -s '$1' -a '$2'
        else
          echo "Warning: Missing secret-tool and security! Are you on supported OS?" > /dev/stderr
          echo "Warning: Secrets have not been populated!" > /dev/stderr
        fi
      }

      #export EXAMPLE_SECRET="$(read_secret personal example-secret)"
    '';
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
