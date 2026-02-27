# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **chezmoi dotfiles repository** for managing personal development environment configuration across machines. Chezmoi uses a template-based system where files prefixed with `dot_` become dotfiles (e.g., `dot_zshrc.tmpl` → `~/.zshrc`), and templates ending in `.tmpl` are processed with Go templating.

## Architecture

### Template System
- **File naming**: `dot_` prefix maps to `.` in the home directory
- **Templates**: `.tmpl` files are processed with Go template syntax using data from `.chezmoi.toml.tmpl`
- **Conditional logic**: Uses `{{ if eq .os "darwin" }}` for OS-specific configuration
- **Data variables**: Defined in `.chezmoi.toml.tmpl` (e.g., `{{ .git_name_default }}`, `{{ .git_email_default }}`)

### Script Execution
- **run_onchange_**: Scripts prefixed with `run_onchange_` execute automatically when their content changes
- `run_onchange_brew-bundle.sh.tmpl`: Installs/updates Homebrew packages from Brewfile
- `run_onchange_install-nvm.sh.tmpl`: Installs nvm (Node Version Manager) to `~/.nvm`
- `run_onchange_install-tpm.sh.tmpl`: Installs TPM (tmux plugin manager) to `~/.tmux/plugins/tpm`
- `run_onchange_install-mise-java.sh.tmpl`: Installs Java (Temurin 21) via mise
- `run_onchange_setup-kube-dirs.sh.tmpl`: Creates `~/.kube/configs/` directory for multi-config Kubernetes setup
- `run_onchange_macos-defaults.sh`: Configures macOS system preferences (keyboard, screenshots)

### Configuration Structure
- **Shell**: `.zshrc` with Starship prompt, modern CLI tools (eza, bat, zoxide), zsh plugins (autosuggestions, syntax-highlighting), compinit for tab completion, fzf keybindings with Catppuccin colors, cached `brew --prefix` for performance, and custom aliases
- **Theme**: Catppuccin Mocha color scheme across all tools (terminal, neovim, tmux, fzf, bat)
- **Node.js**: nvm (lazy-loaded) with automatic version switching via `.nvmrc` files
- **Java**: mise with Temurin JDK, supports per-project versions via `mise.toml`
- **JavaScript Runtime**: bun with completions and PATH configuration
- **Environment Management**: direnv for per-directory environment variables
- **Containers**: OrbStack for Docker and Kubernetes management (lightweight Docker Desktop alternative), `dclean` for interactive Docker disk cleanup
- **Kubernetes**: OpenLens (GUI IDE), kubectl, kubectx, k9s (TUI), and stern (log tailing) with multi-config KUBECONFIG setup
- **Git**: Conditional git identity, delta for diffs, lazygit TUI, global .gitignore, and useful aliases
- **Editor**: Neovim with LSP (mason.nvim), completion (nvim-cmp), formatting (conform.nvim), git integration (gitsigns.nvim), diagnostics (trouble.nvim), keybinding help (which-key.nvim), auto-pairs (nvim-autopairs), and telescope with fzf-native
- **Terminal**: tmux configuration with vi mode, vim-style pane navigation (Ctrl+hjkl), and 256color/RGB support

## Key Chezmoi Commands

### First-Time Setup

```bash
# If you're IN the dotfiles directory (most common for development)
chezmoi init --apply "$(pwd)"

# Or if initializing from a specific path
chezmoi init --apply /path/to/dotfiles

# Or from GitHub URL
chezmoi init --apply https://github.com/alexberriman/dotfiles.git
```

**Important**: `"$(pwd)"` must be run from inside the dotfiles directory!

### Daily Usage

```bash
# Apply all dotfiles to home directory
chezmoi apply

# Preview changes without applying
chezmoi diff

# Edit a file in the chezmoi source directory
chezmoi edit ~/.zshrc

# Add a new file to chezmoi
chezmoi add ~/.config/newfile

# Re-run all run_onchange_ scripts (forces re-execution)
chezmoi apply --force

# Update from git and apply changes
chezmoi update

# See what chezmoi is managing
chezmoi managed

# Check chezmoi's source directory location
chezmoi source-path
```

## Configuration Details

### Theme & Color Scheme (Catppuccin Mocha)
A cohesive **Catppuccin Mocha** theme is applied across the entire development environment for a consistent, modern aesthetic:

**Starship Prompt:**
- **What**: Modern, fast (Rust-based) shell prompt replacing Powerlevel10k
- **Features**: Clean, minimal design showing directory, git status, command duration, time, and Java version
- **Config**: `~/.config/starship.toml`
- **Colors**: Integrated with Catppuccin Mocha palette

**iTerm2 Terminal:**
- **Color scheme**: Catppuccin Mocha (warm dark background with soft pastel accents)
- **Location**: `~/.config/iterm2/catppuccin-mocha.itermcolors`
- **Import**: Preferences → Profiles → Colors → Color Presets → Import

**Neovim Editor:**
- **Plugin**: `catppuccin/nvim` with Mocha flavour
- **Integrations**: LSP, completion, git signs, file tree, telescope, trouble
- **Statusline**: Lualine with Catppuccin theme

**tmux Terminal Multiplexer:**
- **Plugin**: `catppuccin/tmux` via TPM (tmux plugin manager)
- **Auto-install**: TPM installed via `run_onchange_install-tpm.sh.tmpl`
- **Activation**: Press `Prefix + I` (Ctrl+b then Shift+I) to install plugins

**CLI Tools:**
- **fzf**: Catppuccin Mocha colors for fuzzy finder UI
- **bat**: TwoDark theme (closest to Catppuccin for syntax highlighting)
- **delta**: Catppuccin Mocha syntax theme for git diffs

**Post-Installation Steps:**
1. Run `chezmoi apply` to install Starship and apply configs
2. Import iTerm2 color scheme manually (Preferences → Colors → Import)
3. Open tmux and press `Prefix + I` to install Catppuccin theme
4. Open Neovim - Catppuccin loads automatically

### Git Identity Switching
The gitconfig uses conditional includes to switch identity based on directory:
- Default identity: `alexb@bezz.com.au`
- Banja identity: `alex@banja.au` (activated for repos under `~/Documents/banja/repos/`)

### Node.js Version Management (nvm)
Automatic Node.js version switching enabled (lazy-loaded for fast shell startup):
- **Installation**: nvm installed to `~/.nvm` via `run_onchange_install-nvm.sh.tmpl`
- **Lazy loading**: nvm, node, npm, and npx are stub functions that load nvm on first use, avoiding ~200ms shell startup penalty
- **Automatic switching**: When entering a directory with a `.nvmrc` file, nvm is loaded and the specified Node version is automatically used
- **Auto-install**: If the required version isn't installed, nvm automatically installs it
- **Usage**: Create a `.nvmrc` file in project root with desired version (e.g., `18.20.0` or `lts/hydrogen`)

### Java Version Management (mise)
Java is managed via mise (a fast, Rust-based version manager):
- **Installation**: mise installed via Homebrew, Java installed via `run_onchange_install-mise-java.sh.tmpl`
- **Default version**: Temurin 21 (Eclipse's open-source JDK distribution)
- **Auto-switching**: mise automatically switches Java versions when entering directories with `mise.toml` or `.tool-versions`
- **Available distributions**: Temurin, Corretto (Amazon), Zulu (Azul), GraalVM, OpenJDK
- **Configuration**: Global settings in `~/.config/mise/config.toml` (Node.js disabled, uses nvm instead)
- **Commands**:
  - `mise use java@temurin-21` - Install and use Java 21 in current project
  - `mise use -g java@temurin-17` - Set global Java version
  - `mise ls` - List installed versions
  - `mise ls-remote java` - List available Java versions
  - `dx mise` - Show all mise commands

### Bun Configuration
- **Installation**: Installed via Homebrew from `oven-sh/bun` tap
- **Completions**: Auto-loaded from `~/.bun/_bun` if available
- **PATH**: `$HOME/.bun/bin` added to PATH

### Kubernetes Configuration
- **Tools**: OpenLens (GUI), kubectl, and kubectx installed via Homebrew
- **Multi-config setup**: KUBECONFIG automatically combines `~/.kube/config` with all YAML files in `~/.kube/configs/`
- **Directory creation**: `~/.kube/configs/` automatically created via `run_onchange_setup-kube-dirs.sh.tmpl`
- **Usage**: Place additional kubeconfig YAML files in `~/.kube/configs/` to automatically merge them

### Environment Management (direnv)
- **Purpose**: Automatically loads/unloads environment variables based on directory
- **Usage**: Create `.envrc` files in project directories with environment variables
- **Activation**: Run `direnv allow` in the directory after creating/modifying `.envrc`

### Shell Aliases

**Modern CLI Replacements:**
- `ls`, `ll`, `lt`: Use eza instead of ls (with icons, git status, tree view)
- `cat`, `less`: Use bat for syntax highlighting
- `cd`: Aliased to `z` (zoxide) for smart directory jumping

**Git Aliases:**
- `lg`: Launch lazygit TUI
- `git st`: Short status
- `git unstage`: Unstage files
- `git undo`: Undo last commit (soft reset)
- `git visual`: Pretty graph of commits
- `git amend`: Amend without editing message

**Docker Aliases:**
- `dclean`: Interactive Docker cleanup (shows disk usage, choose quick/full mode)
- `dclean -f`: Force full cleanup without confirmation
- `dps`: Compact running container list
- `dlog`: Follow container logs

**Kubernetes Aliases:**
- `k`: kubectl shorthand
- `kx`: kubectx (switch context)
- `kn`: kubens (switch namespace)
- `logs`: stern (multi-pod log tailing)
- `kclean`: Cleans up Kubernetes pods in failed states (Evicted, Completed, Error, CrashLoopBackOff, ContainerStatusUnknown, Init:Error, Init:CrashLoopBackOff, ImagePullBackOff, ErrImagePull, CreateContainerError, InvalidImageName)

**Developer Experience Helper:**
- `dx`: Interactive cheatsheet for all dotfiles tools and commands
  - `dx` - Show top commands
  - `dx git` - Git workflow
  - `dx k8s` - Kubernetes tools
  - `dx shell` - Shell enhancements
  - `dx nvm` - Node.js version management (alias: `dx node`)
  - `dx mise` - Java version management (alias: `dx java`)
  - `dx nvim` - Neovim keybindings
  - `dx docker` - Docker & containers (alias: `dx containers`)
  - `dx tools` - Utilities and dotfiles management
  - `dx all` - Complete reference

**Custom Aliases:**
- `letsbanj`: Runs banja-claude script from `~/Documents/repos/banja-claude/run.sh`

### Installed Tools (via Homebrew)

**Core Development:**
- **Editor**: neovim with LSP, completion, and formatting
- **Search**: ripgrep, fd, fzf
- **Shell**: starship (modern prompt), zsh
- **Terminal**: tmux with Catppuccin theme, iTerm2 with Catppuccin Mocha colors
- **Productivity**: raycast (with window management)
- **JavaScript**: bun (via oven-sh/bun tap)
- **Environment**: direnv
- **Containers**: OrbStack (fast, lightweight Docker Desktop alternative)
- **Version management**: mise (Java, Python, etc. - fast Rust-based tool)

**Shell Enhancements (Tier 1):**
- **zsh-autosuggestions**: Fish-like command suggestions from history
- **zsh-syntax-highlighting**: Real-time command validation before execution
- **eza**: Modern ls replacement with git integration and icons
- **bat**: Better cat with syntax highlighting and git integration
- **zoxide**: Smart cd that learns frequently used directories

**Git Workflow (Tier 1):**
- **git-delta**: Beautiful syntax-highlighted diffs with side-by-side view
- **lazygit**: Terminal UI for git operations (staging, commits, branches)
- **gh**: GitHub CLI for PR and issue management
- **jq**: JSON processor for parsing/manipulating JSON data
- **yq**: YAML equivalent of jq

**Neovim Formatters (Tier 2):**
- **stylua**: Lua code formatter for neovim config files

**Kubernetes & Observability (Tier 3):**
- **OpenLens**: Kubernetes IDE (GUI) for visual cluster management
- **kubectl**: Kubernetes CLI
- **kubectx**: Fast context and namespace switching
- **k9s**: Terminal UI for managing Kubernetes clusters
- **stern**: Multi-pod and multi-container log tailing
- **btop**: Beautiful resource monitor (CPU, memory, network)
- **httpie**: User-friendly HTTP client with syntax highlighting

### Neovim Configuration
- **Plugin Manager**: lazy.nvim for fast, lazy-loaded plugin management
- **LSP Management**: mason.nvim for easy LSP server installation
  - Automatically installs: lua_ls, ts_ls, eslint
  - Open `:Mason` to manage servers
- **Completion**: nvim-cmp with sources:
  - nvim_lsp: Completions from LSP servers
  - buffer: Completions from current buffer
  - path: File path completions
  - luasnip: Snippet completions
- **Formatting**: conform.nvim with format-on-save enabled
  - Lua: stylua
  - JavaScript/TypeScript: prettier
  - JSON/YAML/Markdown: prettier
- **Git Integration**: gitsigns.nvim
  - Inline git blame
  - Hunk navigation and staging
  - Git status indicators in sign column
- **Diagnostics**: trouble.nvim for better error/warning lists
  - `<leader>xx`: Toggle diagnostics
  - `<leader>xw`: Buffer diagnostics
- **Keybinding Help**: which-key.nvim shows available keybindings in a popup after pressing leader
- **Auto-pairs**: nvim-autopairs auto-closes brackets and quotes with cmp integration
- **Telescope**: Uses fzf-native extension for significantly faster fuzzy sorting
- **Keybindings**:
  - `<leader>ff`: Find files (telescope)
  - `<leader>fg`: Live grep (telescope)
  - `<leader>fb`: Buffer list (telescope)
  - `<leader>t`: Toggle file tree
  - `<C-Space>`: Trigger completion
  - `<CR>`: Confirm completion

### Git Configuration
- **Pager**: delta for beautiful diffs
  - Side-by-side view enabled
  - Line numbers shown
  - Syntax highlighting with Catppuccin Mocha theme
- **Global .gitignore**: Located at `~/.gitignore_global`
  - Ignores: .DS_Store, node_modules/, .env files, editor files, build outputs
- **Merge Conflict Style**: zdiff3 (shows common ancestor)
- **Git Aliases**: See "Shell Aliases" section above
- **Conditional Identity**: Automatically switches git user based on repo location

### macOS Defaults
System preferences configured on macOS:
- Key repeat: Fast (InitialKeyRepeat=20, KeyRepeat=2)
- Press-and-hold: Disabled for key repeat
- Screenshots: PNG format, saved to Desktop
