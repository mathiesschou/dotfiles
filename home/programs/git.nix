{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user.name = "mathiesschou";
      user.email = "mathiesschou@icloud.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push = {
        default = "current";
        autoSetupRemote = true;
      };
      core = {
        editor = "nvim";
        autocrlf = "input";
      };
      color.ui = "auto";
      diff.colorMoved = "zebra";
      merge.conflictstyle = "diff3";
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        lg = "log --oneline --graph --decorate --all";
      };
    };
  };
}
