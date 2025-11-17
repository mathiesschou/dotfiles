{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user.name = "mathiesschou";
      user.email = "mathiesschou@icloud.com";
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";
    };
  };
}
