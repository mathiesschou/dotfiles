{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.lua
        p.c
        p.cpp
        p.javascript
        p.typescript
        p.tsx
        p.html
        p.css
        p.json
        p.python
        p.rust
        p.nix
        p.latex
        p.typst
        p.svelte
        p.bash
        p.markdown
        p.markdown_inline
        p.vim
        p.vimdoc
      ]))
    ];
  };

  # Link neovim configuration directory
  # This allows you to keep your existing nvim config structure
  home.file.".config/nvim" = {
    source = ../../nvim/.config/nvim;
    recursive = true;
    force = true;
  };
}
