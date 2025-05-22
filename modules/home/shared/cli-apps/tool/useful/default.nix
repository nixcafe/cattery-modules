{
  pkgs,
  config,
  lib,
  namespace,
  ...
}:
let
  aliases = {
    # nix uses too many links, this is really needed
    rl = "readlink -f";
    # cd aliases
    "..." = "cd ../..";
    "...." = "cd ../../..";
    "....." = "cd ../../../..";
    "......" = "cd ../../../../..";
    "1" = "cd -1";
    "2" = "cd -2";
    "3" = "cd -3";
    "4" = "cd -4";
    "5" = "cd -5";
    "6" = "cd -6";
    "7" = "cd -7";
    "8" = "cd -8";
    "9" = "cd -9";
    "~" = "cd ~";
    "-" = "cd -";

    # ls aliases
    l = "ls -lah";
    la = "ls -lAh";
    ll = "ls -lh";
    lsa = "ls -lah";

    # grep aliases
    grep = "grep --color=auto";

    # git aliases
    g = "git";
    ga = "git add";
    gaa = "git add --all";
    gb = "git branch";
    gba = "git branch -a";
    gc = "git commit -v";
    gcm = "git commit -m";
    gco = "git checkout";
    gd = "git diff";
    gf = "git fetch";
    gl = "git pull";
    gp = "git push";
    gpf = "git push --force-with-lease";
    gst = "git status";
    glg = "git log --stat";
    glog = "git log --oneline --decorate --graph";

    # general convenience aliases
    please = "sudo";
    _ = "sudo";
    h = "history";
    j = "jobs -l";
    md = "mkdir -p";
    dud = "du -d 1 -h";
    duf = "du -sh *";
  };

  cfg = config.${namespace}.cli-apps.tool.useful;
in
{
  options.${namespace}.cli-apps.tool.useful = {
    enable = lib.mkEnableOption "useful";
    commonAliases = lib.mkEnableOption "common aliases";
    persistence = lib.mkEnableOption "add files and directories to impermanence" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        # cli utils
        lrzsz # communication package providing the XMODEM, YMODEM ZMODEM file transfer protocols
        parallel # for executing jobs in parallel using one or more computers
        rsync # fast incremental file transfer utility
        rclone # command line program to sync files and directories to and from major cloud storage
        smartmontools # tools for monitoring the health of hard drives
        tldr # simplified and community-driven man pages
        tokei # a program that allows you to count your code, quickly
        iperf # tool to measure IP bandwidth using UDP or TCP
        nmap # a free and open source utility for network discovery and security auditing
        pciutils # lspci
        openssl # a cryptographic library that implements the SSL and TLS protocols
        tree # command to produce a depth indented directory listing
        ast-grep # a new AST based tool for managing your code, at massive scale.

        # tui
        dua # most convenient disk stuff I've ever used
      ];

      shellAliases = {
        ls = "eza";
        find = "fd";
        grep = "rg --smart-case";
        cat = "bat";
        z = "zoxide";
        cd = "z";
      } // lib.mkIf cfg.commonAliases aliases;
    };

    programs = {
      # ls
      eza.enable = true;

      # better find, why debian uses `fd-find` still bothers me
      fd.enable = true;

      # i should learn this
      jq.enable = true;

      # grep
      ripgrep.enable = true;

      # the cat replacement that actually does something
      bat.enable = true;

      # great file fuzzy finder
      fzf.enable = true;

      # use zoxide to replace cd
      zoxide = {
        enable = true;
        options = [ "--cmd cd" ];
      };
    };

    ${namespace}.system.impermanence = lib.mkIf cfg.persistence {
      directories = [ ".tldrc" ];
      xdg.cache.directories = [ "bat" ];
      xdg.data.directories = [ "zoxide" ];
    };
  };

}
