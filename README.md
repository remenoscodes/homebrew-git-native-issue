# Homebrew Tap for git-native-issue

[![Test Formula](https://github.com/remenoscodes/homebrew-git-native-issue/actions/workflows/test.yml/badge.svg)](https://github.com/remenoscodes/homebrew-git-native-issue/actions/workflows/test.yml)
[![Update Formula](https://github.com/remenoscodes/homebrew-git-native-issue/actions/workflows/update-formula.yml/badge.svg)](https://github.com/remenoscodes/homebrew-git-native-issue/actions/workflows/update-formula.yml)

Official Homebrew tap for **git-native-issue** — a distributed issue tracker that uses Git's native data model.

## 📦 What is This?

This repository contains the Homebrew formula for [git-native-issue](https://github.com/remenoscodes/git-native-issue), enabling easy installation on macOS and Linux via Homebrew.

**Main Repository:** https://github.com/remenoscodes/git-native-issue

## 🚀 Installation

### Quick Install (Recommended)

```bash
brew install remenoscodes/git-native-issue/git-native-issue
```

This single command:
- Automatically adds the tap (if not already added)
- Installs the latest version
- Makes `git-issue` available system-wide

### Manual Tap + Install

```bash
# Add the tap
brew tap remenoscodes/git-native-issue

# Install git-native-issue
brew install git-native-issue
```

### Verify Installation

```bash
git-issue version
# Should output: git-native-issue version 1.0.2 (or latest)
```

## 🔄 Updating

```bash
# Update Homebrew and all formulas
brew update && brew upgrade git-native-issue

# Or just update this tap
brew update
brew upgrade git-native-issue
```

## 🛠️ Usage

Once installed, use `git-issue` commands in any Git repository:

```bash
# Initialize issue tracking
git issue init

# Create an issue
git issue create "Add dark mode support" -m "Users have requested this"

# List issues
git issue ls

# Show an issue
git issue show a7f3b2c

# Comment on an issue
git issue comment a7f3b2c -m "Working on this now"

# Close an issue
git issue state a7f3b2c --close --fixed-by abc123
```

For complete documentation, see: https://github.com/remenoscodes/git-native-issue

## 🤖 Automated Updates (CI/CD Architecture)

This tap uses an **automated release pipeline** that keeps the formula in sync with upstream releases:

```
┌─────────────────────────────────────────────────────────────┐
│ git-native-issue Repository                                 │
│                                                              │
│  1. Tag pushed (e.g., v1.0.3)                               │
│  2. Release workflow triggers:                              │
│     - Creates tarball                                       │
│     - Computes SHA256                                       │
│     - Publishes GitHub release                              │
│     - Sends repository_dispatch event → homebrew tap       │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│ homebrew-git-native-issue Repository (this repo)            │
│                                                              │
│  3. Update workflow triggered by dispatch                   │
│  4. Automatically updates formula:                          │
│     - Version number                                        │
│     - SHA256 checksum                                       │
│     - Download URL                                          │
│  5. Commits and pushes changes                              │
└─────────────────────────────────────────────────────────────┘
```

**Result:** Users get the latest version within minutes of release, with zero manual intervention.

### Workflow Files

- **[test.yml](.github/workflows/test.yml)** - Tests formula on every commit (validates syntax + installation)
- **[update-formula.yml](.github/workflows/update-formula.yml)** - Auto-updates formula on new releases

## 📝 Formula Details

The formula ([git-native-issue.rb](git-native-issue.rb)) specifies:

- **Version:** Tracks latest stable release
- **URL:** Points to official GitHub release tarball
- **SHA256:** Cryptographic checksum for integrity verification
- **Dependencies:** `git` (the only runtime dependency)

**Current formula structure:**
```ruby
class GitNativeIssue < Formula
  desc "Distributed issue tracking using Git's native data model"
  homepage "https://github.com/remenoscodes/git-native-issue"
  url "https://github.com/remenoscodes/git-native-issue/releases/download/v1.0.2/git-native-issue-v1.0.2.tar.gz"
  sha256 "e9d4cdf6239a7175a651b8dc89bef1b133500306b5e7fe6cd78025f83082d40d"
  version "1.0.2"

  depends_on "git"

  def install
    bin.install Dir["bin/*"]
    man1.install Dir["doc/*.1"] if Dir.exist?("doc")
    doc.install "README.md", "LICENSE", "ISSUE-FORMAT.md"
  end

  test do
    system "#{bin}/git-issue", "version"
    assert_match "1.0.2", shell_output("#{bin}/git-issue version")
  end
end
```

## 🐛 Troubleshooting

### Formula not found after `brew tap`

```bash
# Update Homebrew
brew update

# Verify tap was added
brew tap | grep remenoscodes

# Re-add tap if needed
brew untap remenoscodes/git-native-issue
brew tap remenoscodes/git-native-issue
```

### Installation fails with checksum error

```bash
# Clear Homebrew cache
brew cleanup git-native-issue

# Try again
brew update
brew reinstall git-native-issue
```

### Old version installed

```bash
# Force update
brew update
brew upgrade git-native-issue

# Or reinstall
brew uninstall git-native-issue
brew install remenoscodes/git-native-issue/git-native-issue
```

### Check formula audit

```bash
# Validate formula syntax
brew audit --strict remenoscodes/git-native-issue/git-native-issue

# Test installation locally
brew install --build-from-source remenoscodes/git-native-issue/git-native-issue
```

## 🔧 For Maintainers

### Manual Formula Update (Emergency)

If automated updates fail, manually update the formula:

1. **Get release info:**
   ```bash
   VERSION="1.0.3"
   curl -sL "https://github.com/remenoscodes/git-native-issue/releases/download/v${VERSION}/git-native-issue-v${VERSION}.tar.gz" \
     | shasum -a 256
   ```

2. **Update formula:**
   ```ruby
   url "https://github.com/remenoscodes/git-native-issue/releases/download/v1.0.3/git-native-issue-v1.0.3.tar.gz"
   sha256 "NEW_SHA256_HERE"
   version "1.0.3"
   ```

3. **Test locally:**
   ```bash
   brew uninstall git-native-issue
   brew install --build-from-source remenoscodes/git-native-issue/git-native-issue
   brew test git-native-issue
   ```

4. **Commit and push:**
   ```bash
   git add git-native-issue.rb
   git commit -m "Update formula to v1.0.3"
   git push origin main
   ```

### Testing Automated Updates

Trigger a manual workflow run:

```bash
# Using GitHub CLI
gh workflow run update-formula.yml

# Or via API
curl -X POST \
  -H "Authorization: token YOUR_TOKEN" \
  https://api.github.com/repos/remenoscodes/homebrew-git-native-issue/actions/workflows/update-formula.yml/dispatches \
  -d '{"ref":"main"}'
```

### Required Secrets

The main repository needs this secret configured:

- **TAP_UPDATE_TOKEN** - Personal Access Token with `repo` scope to trigger workflows in this repository

Configure at: https://github.com/remenoscodes/git-native-issue/settings/secrets/actions

## 📊 Repository Structure

```
homebrew-git-native-issue/
├── .github/
│   └── workflows/
│       ├── test.yml           # Tests formula on every push
│       └── update-formula.yml # Auto-updates on release
├── git-native-issue.rb        # Homebrew formula (source of truth)
└── README.md                  # This file
```

## 🌐 Links

- **Main Repository:** https://github.com/remenoscodes/git-native-issue
- **Issue Tracker:** https://github.com/remenoscodes/git-native-issue/issues
- **Format Specification:** https://github.com/remenoscodes/git-native-issue/blob/main/ISSUE-FORMAT.md
- **Release Notes:** https://github.com/remenoscodes/git-native-issue/releases

## 📜 License

The formula in this repository is released under the same license as git-native-issue (GPL-2.0).

See: https://github.com/remenoscodes/git-native-issue/blob/main/LICENSE

## 🤝 Contributing

Formula updates are automated, but if you find issues:

1. **Report bugs:** https://github.com/remenoscodes/git-native-issue/issues
2. **Suggest improvements:** Open an issue in this repository
3. **Test pre-release versions:** Use `--HEAD` install (if available)

---

**Maintained by:** [Emerson Soares](https://github.com/remenoscodes)
**Built with:** ❤️ and [Claude Code](https://claude.com/claude-code)
