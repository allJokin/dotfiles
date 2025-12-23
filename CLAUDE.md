# CLAUDE.md - AI Assistant Guide for Dotfiles Repository

This document provides comprehensive guidance for AI assistants working with this dotfiles repository.

## Repository Overview

This is a **personal dotfiles repository** for managing development environment configurations. It follows the common Unix/Linux tradition of storing user-specific configuration files (dotfiles) in a version-controlled repository for easy deployment and backup.

### Purpose
- Manage shell configurations (Zsh)
- Maintain Git settings and custom commands
- Automate development environment setup
- Provide consistent configuration across machines

## Repository Structure

```
dotfiles/
├── .gitconfig          # Git configuration with aliases
├── .gitignore          # Excludes .gitconfig.local from version control
├── .zshrc              # Zsh shell configuration with Zinit plugin manager
├── README.md           # Basic repository description
├── bootstrap.sh        # Main installation script (syncs files to ~/)
├── brew.sh             # Homebrew package installation script
└── bin/
    └── git-dem         # Custom git command to delete merged branches
```

### Key Files

#### `.zshrc` (lines 1-103)
The main Zsh configuration file with:
- **Prompt customization**: Shows username, hostname, current directory, and time
- **Zinit plugin manager**: Automatic installation and configuration
- **Plugins loaded**:
  - `zsh-autosuggestions` - Command suggestions
  - `zsh-completions` - Additional completion definitions
  - `fast-syntax-highlighting` - Syntax highlighting
  - `history-search-multi-word` - Enhanced history search (Ctrl+r)
  - `git-open` - Open GitHub repository in browser
  - `oh-my-git` - Git status display
- **VCS integration**: Git branch display in right prompt
- **Environment setup**:
  - Editor set to vim
  - Custom PATH including `~/bin`
  - Homebrew configuration for user-local install
  - anyenv initialization for version management
  - SDKMAN configuration

#### `.gitconfig` (lines 1-10)
Git configuration with common aliases:
- `ci` = commit
- `st` = status
- `br` = branch
- `co` = checkout
- `sw` = switch
- **Important**: Includes `~/.gitconfig.local` for machine-specific settings (not tracked in repo)

#### `bootstrap.sh` (lines 1-26)
Installation script that:
1. Pulls latest changes from `origin main`
2. Uses `rsync` to sync dotfiles to home directory
3. Excludes: `.git/`, `.DS_Store`, `.osx`, `bootstrap.sh`, `README.md`, `LICENSE-MIT.txt`
4. Requires confirmation unless `-f` or `--force` flag is used
5. Preserves no permissions (`--no-perms`)

#### `brew.sh` (lines 1-10)
Package installation script:
- Checks if Homebrew is installed
- Installs `anyenv` (version manager manager)

#### `bin/git-dem` (lines 1-2)
Custom git command to delete merged branches:
- Accessible as `git dem` when `~/bin` is in PATH
- Deletes all local branches that have been merged
- Excludes branches: current branch (`*`), `develop`, `master`

## Development Workflows

### Initial Setup
1. Clone this repository
2. Run `./bootstrap.sh` to sync dotfiles to home directory
3. Run `./brew.sh` to install required packages (requires Homebrew)
4. Restart shell or source `~/.zshrc`

### Making Changes
1. **Create feature branch**: Work on branches prefixed with `claude/` for AI-assisted changes
2. **Edit files**: Modify configuration files as needed
3. **Test locally**: Source the changed files or restart shell to test
4. **Commit changes**: Use clear, descriptive commit messages
5. **Push to origin**: Push to the feature branch

### Syncing to Home Directory
- Run `./bootstrap.sh` (with confirmation)
- Or `./bootstrap.sh -f` (force without confirmation)
- This will overwrite files in `~/` with repository versions

## Key Conventions for AI Assistants

### File Editing Guidelines

1. **Shell Configuration (.zshrc)**
   - Preserve Japanese comments (encoded in UTF-8)
   - Maintain plugin load order (Zinit requires specific ordering)
   - Keep Zinit installer chunk intact (lines 42-62)
   - When adding new plugins, place after existing plugins but before custom configurations
   - Test that changes don't break shell startup

2. **Git Configuration (.gitconfig)**
   - Never commit machine-specific settings here
   - Use `.gitconfig.local` for personal info (user.name, user.email)
   - Keep aliases short and memorable
   - Maintain alphabetical ordering of aliases

3. **Bootstrap Script (bootstrap.sh)**
   - Always pull from `origin main` before syncing
   - Maintain exclude list to prevent syncing unnecessary files
   - Preserve confirmation prompt for safety

4. **Custom Commands (bin/)**
   - Make files executable (`chmod +x`)
   - Use shebang for proper interpreter
   - Keep commands focused and single-purpose
   - Document purpose with comments

### Git Workflow Conventions

- **Main branch**: Default branch is `main` (not master)
- **Feature branches**: Use `claude/*` prefix for AI-generated changes
- **Commit messages**: Be descriptive about what configuration changed and why
- **Testing**: Always test configuration changes before committing

### Environment Assumptions

- **OS**: Primarily macOS (references to `/Users/kddi/`, SDKMAN paths)
- **Shell**: Zsh (not Bash)
- **Package Manager**: Homebrew installed at `~/.homebrew/bin`
- **Version Manager**: anyenv (manages rbenv, pyenv, nodenv, etc.)
- **Java SDK Manager**: SDKMAN for Java version management

### Important Paths

- `~/bin` - Added to PATH for custom commands
- `$HOME/.homebrew/bin` - Homebrew binaries (user-local install)
- `$HOME/.zinit/bin` - Zinit plugin manager
- `~/.gitconfig.local` - Local git config (not tracked)
- `/Users/kddi/.sdkman` - SDKMAN installation (user-specific)

### Things to Avoid

1. **Don't** remove or modify the Zinit installer chunk without understanding its purpose
2. **Don't** commit `.gitconfig.local` or other machine-specific files
3. **Don't** change the bootstrap script's pull from `origin main` without good reason
4. **Don't** add large binaries or compiled files
5. **Don't** modify PATH order carelessly (can break tool precedence)
6. **Don't** remove safety confirmations from destructive operations

### Testing Checklist

When making changes, verify:
- [ ] Zsh starts without errors: `zsh -i -c 'echo "OK"'`
- [ ] Git commands work: `git st`, `git br`, etc.
- [ ] Custom commands are executable: `git dem`
- [ ] Plugins load correctly: Check for Zinit errors on startup
- [ ] PATH is correct: `echo $PATH` includes `~/bin` and homebrew
- [ ] No hard-coded paths that won't work on other machines

### Debugging Common Issues

**Zsh won't start or shows errors**:
- Check syntax in `.zshrc`
- Ensure Zinit is installed: `ls ~/.zinit/bin/zinit.zsh`
- Check plugin names are correct

**Bootstrap fails**:
- Ensure git remote is configured: `git remote -v`
- Check rsync is installed: `which rsync`
- Verify file permissions: `ls -la`

**Custom git commands don't work**:
- Ensure `~/bin` is in PATH: `echo $PATH | grep ~/bin`
- Check file is executable: `ls -l ~/bin/git-dem`
- Verify git can find it: `git --exec-path`

## Code Quality Standards

### Shell Scripts
- Use `#!/usr/bin/env bash` or `#!/bin/bash` shebang
- Quote variables: `"$variable"` not `$variable`
- Check command success: `if [ $? -eq 0 ]`
- Use `set -e` for critical scripts (fail on error)

### Configuration Files
- Maintain consistent indentation (tabs or spaces, not mixed)
- Group related settings together
- Comment non-obvious configurations
- Keep portable (avoid hard-coded user paths)

## Repository Metadata

- **Current Branch**: `claude/add-claude-documentation-uGm4f`
- **Primary Remote**: `origin`
- **Default Branch**: `main`
- **Git Status**: Clean (at time of documentation)

## Recent Commit History

```
3ee7627 - brew install
3b71748 - brewとanyenvの設定
159fda1 - git commandを作成
d56ac6e - zshrc作成
5031f67 - gitconfigを作成
```

## Additional Notes for AI Assistants

### When Suggesting Changes

1. **Read before editing**: Always use Read tool before suggesting modifications
2. **Preserve existing style**: Match indentation, comment style, and structure
3. **Explain impact**: Describe what will change in the user's environment
4. **Consider portability**: Will this work on different machines/users?
5. **Security awareness**: Don't commit secrets, tokens, or personal information

### When Adding New Features

1. **Check for existing solutions**: Many common needs are already handled by plugins
2. **Prefer plugins over custom code**: Zinit ecosystem has many quality plugins
3. **Document additions**: Add comments explaining why something was added
4. **Test thoroughly**: Shell configuration errors can be disruptive

### When Refactoring

1. **Maintain backward compatibility**: Don't break existing workflows
2. **Preserve comments**: Especially those in Japanese
3. **Keep git history clean**: Logical, atomic commits
4. **Update this document**: Keep CLAUDE.md in sync with changes

## Useful Commands

```bash
# Test zsh configuration without affecting current shell
zsh -n ~/.zshrc              # Check syntax
zsh -i -c 'echo "OK"'        # Start interactive shell and exit

# Sync dotfiles to home directory
./bootstrap.sh               # With confirmation
./bootstrap.sh -f            # Force without confirmation

# Install packages
./brew.sh                    # Install Homebrew packages

# Custom git commands
git dem                      # Delete merged branches
git open                     # Open repo in browser (requires git-open plugin)

# Check what will be synced
rsync -avn --exclude ".git/" --exclude ".DS_Store" --exclude ".osx" \
  --exclude "bootstrap.sh" --exclude "README.md" --exclude "LICENSE-MIT.txt" . ~/
```

## Resources

- [Zinit Documentation](https://github.com/zdharma-continuum/zinit)
- [Zsh Plugin List](https://github.com/unixorn/awesome-zsh-plugins)
- [Git Aliases](https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases)
- [anyenv Documentation](https://github.com/anyenv/anyenv)

---

**Last Updated**: 2025-12-23
**Document Version**: 1.0
**Maintained By**: AI Assistants and Repository Owner
