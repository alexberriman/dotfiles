# Dotfiles

Personal development environment configuration managed with chezmoi.

## Prerequisites

- macOS or Linux
- `curl` or `wget`

## Getting Started

### From GitHub (Recommended)

Install chezmoi and apply dotfiles in one command:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/alexberriman/dotfiles.git
```

### From Local Clone

If you've already cloned this repo:

```bash
# Install chezmoi (if not already installed)
brew install chezmoi

# Navigate to the dotfiles directory
cd /path/to/dotfiles

# Initialize and apply (if you're IN the dotfiles directory)
chezmoi init --apply "$(pwd)"

# This will:
# - Set this directory as chezmoi's source
# - Copy all dot_* files to your home directory
# - Run all run_onchange_ scripts (brew bundle, nvm install, etc.)
# - Install all tools via Homebrew (5-10 min first run)
```

**Note**: The `"$(pwd)"` command uses your current directory. Make sure you're inside the dotfiles directory when running this!

### Troubleshooting: Nothing Happens After `chezmoi init`?

If `chezmoi init --apply "$(pwd)"` runs but doesn't install anything or show output, run these diagnostics:

```bash
# 1. Check where chezmoi thinks its source is
chezmoi source-path
# Expected: ~/.local/share/chezmoi

# 2. List what chezmoi is managing
chezmoi managed
# Should show: .zshrc, .gitconfig, .tmux.conf, etc.

# 3. Verify you're in the dotfiles directory
pwd
# Should show: /path/to/your/dotfiles

# 4. List dotfiles in current directory
ls -1 | grep "^dot_"
# Should show: dot_zshrc.tmpl, dot_gitconfig.tmpl, etc.

# 5. Check if files already exist in home directory
ls -la ~ | grep ".zshrc"
# If exists, chezmoi may think it's already applied
```

**Common Issues:**

1. **Chezmoi source is empty (`chezmoi managed` shows nothing)**
   ```bash
   # Clean slate and reinitialize
   rm -rf ~/.local/share/chezmoi
   cd /path/to/dotfiles
   chezmoi init --apply .

   # Verify it worked
   chezmoi managed  # Should now show files
   chezmoi apply -v  # Apply with verbose output
   ```

2. **Chezmoi was already initialized elsewhere**
   - Run `chezmoi source-path` - if it shows a different directory, chezmoi is using that instead
   - Fix: Same as issue #1 above

3. **Files are already applied (no diff)**
   - If `chezmoi diff` shows nothing, files are already in sync
   - This is actually good - it means everything is already applied!
   - Verify by checking: `cat ~/.zshrc | grep "zoxide"`

4. **Wrong directory**
   - Make sure you're IN the dotfiles directory when running `chezmoi init --apply .`
   - `pwd` should show your dotfiles path, not your home directory

5. **Force re-run scripts**
   - If tools aren't installed, run: `chezmoi apply --force`
   - This forces run_onchange_ scripts to execute again

**Still stuck?** Run `chezmoi doctor` to check for issues.

## Usage

```bash
# Apply changes
chezmoi apply

# Preview changes before applying
chezmoi diff

# Edit a dotfile
chezmoi edit ~/.zshrc

# Add a new file
chezmoi add ~/.config/newfile

# Update from repo and apply
chezmoi update
```

## What's Included

### Shell Environment
- **zsh** with Powerlevel10k theme
- **Shell enhancements**:
  - `zsh-autosuggestions` - Fish-like command suggestions from history
  - `zsh-syntax-highlighting` - Real-time command validation
  - `zoxide` - Smart cd that learns your frequent directories (use `z` instead of `cd`)
  - `eza` - Modern ls replacement with git integration and icons
  - `bat` - Better cat with syntax highlighting
- **fzf** - Fuzzy finder with keybindings

### Development Tools
- **Node.js**: nvm with automatic version switching via `.nvmrc`
- **JavaScript Runtime**: bun for fast JavaScript execution
- **Environment Management**: direnv for per-directory environment variables

### Editor (Neovim)
- **Plugin Manager**: lazy.nvim
- **LSP**: Full LSP support with mason.nvim for easy server installation
- **Completion**: nvim-cmp with LSP, buffer, path, and snippet sources
- **Formatting**: conform.nvim with auto-format on save (prettier, stylua)
- **Git Integration**: gitsigns.nvim for inline git blame and hunks
- **File Navigation**: telescope.nvim and nvim-tree
- **Syntax**: treesitter for better highlighting
- **Diagnostics**: trouble.nvim for better error lists

### Terminal & Multiplexer
- **tmux** with vi mode and vim-style pane navigation (Ctrl+hjkl)
- **iTerm2** as terminal emulator

### Git Workflow
- **Conditional identity switching** (default vs. banja repos)
- **delta** - Beautiful syntax-highlighted diffs
- **lazygit** - Terminal UI for git operations
- **gh** - GitHub CLI for PR and issue management
- **Global .gitignore** - Common patterns (node_modules, .DS_Store, etc.)
- **Useful aliases**: `st`, `co`, `br`, `unstage`, `undo`, `visual`, `amend`

### Kubernetes Tools
- **kubectl** - Kubernetes CLI
- **kubectx** - Fast context switching
- **k9s** - Terminal UI for Kubernetes cluster management
- **stern** - Multi-pod log tailing
- **Multi-config support** - Automatically merges all configs from `~/.kube/configs/`

### Observability & Utilities
- **btop** - Beautiful system monitor
- **httpie** - User-friendly HTTP client
- **jq/yq** - JSON and YAML processors
- **ripgrep/fd** - Fast search tools

### macOS Integration
- **Homebrew** - Package management
- **Raycast** - Productivity and window management
- **Fast key repeat** and other macOS optimizations

## Post-Installation Setup

After applying dotfiles for the first time, complete these manual steps:

### GitHub CLI
```bash
gh auth login
```

### Neovim LSP Servers
On first launch, mason.nvim will automatically install LSP servers. You can also manually manage them:
```bash
# Open nvim and run:
:Mason
```

### Kubernetes Configs
Place additional kubeconfig files in `~/.kube/configs/` to automatically merge them:
```bash
mkdir -p ~/.kube/configs
# Copy your kubeconfig files to this directory
```

## Quick Reference

🎯 **New to these dotfiles? Just type `dx` for an interactive cheatsheet!**

```bash
dx           # Show top commands
dx git       # Git workflow commands
dx k8s       # Kubernetes tools
dx shell     # Shell enhancements
dx nvim      # Neovim keybindings
dx tools     # Other utilities
dx all       # Everything (piped to less)
```

## Key Commands & Aliases

### Shell
- `z <directory>` - Jump to frequently used directory (zoxide)
- `ll` - Enhanced ls with icons and git status
- `lt` - Tree view of current directory
- `cat <file>` - View file with syntax highlighting (bat)

### Git
- `lg` - Launch lazygit TUI
- `git st` - Short status
- `git unstage` - Unstage files
- `git undo` - Undo last commit (keeps changes)
- `git visual` - Pretty commit graph

### Kubernetes
- `k` - kubectl shorthand
- `k9s` - Launch Kubernetes TUI
- `kx` - Switch context (kubectx)
- `kn` - Switch namespace (kubens)
- `logs <pod>` - Tail logs from multiple pods (stern)

### Neovim
- `<leader>ff` - Find files (telescope)
- `<leader>fg` - Live grep (telescope)
- `<leader>t` - Toggle file tree
- `<leader>xx` - Show diagnostics (trouble)
- `<C-Space>` - Trigger completion
- Auto-format on save enabled for supported file types
