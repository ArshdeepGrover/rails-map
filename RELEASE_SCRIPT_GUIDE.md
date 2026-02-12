# Release Script Guide

## Overview

The `release.sh` script automates the entire gem release process, including version management, building, and publishing to RubyGems.

## Features

✅ **Interactive Version Management** - Prompts for new version number
✅ **Automatic Version Updates** - Updates `lib/rails_map/version.rb`
✅ **CHANGELOG Integration** - Updates CHANGELOG.md automatically
✅ **Git Integration** - Commits and pushes version changes
✅ **Pre-flight Checks** - Validates version format and runs tests
✅ **Rollback Support** - Reverts changes if push fails
✅ **Old Gem Cleanup** - Removes previous gem files
✅ **Git Tagging** - Creates and pushes version tags
✅ **Post-install Summary** - Shows next steps

## Usage

### Basic Usage

```bash
./release.sh
```

The script will guide you through the entire process with prompts.

### Step-by-Step Process

#### 1. Version Input

```
Current version: 1.2.0

Enter the new version number (e.g., 1.2.0, 1.2.1, 2.0.0):
Version: 1.2.1
```

**Version Format:**

- Must follow semantic versioning: `MAJOR.MINOR.PATCH`
- Examples: `1.2.1`, `2.0.0`, `1.3.0`

#### 2. Version Confirmation

```
Version change: 1.2.0 → 1.2.1
Is this correct? (y/n)
```

#### 3. Automatic Updates

The script automatically updates:

- `lib/rails_map/version.rb` - Sets VERSION constant
- `CHANGELOG.md` - Replaces `[Unreleased]` with `[1.2.1] - 2026-02-12`

#### 4. Git Commit (Optional)

```
Would you like to commit the version changes?
Commit version changes? (y/n)
```

If yes:

```
✓ Version changes committed
Push to remote? (y/n)
```

#### 5. Pre-flight Checks

- Runs test suite (if available)
- Validates gemspec
- Checks for errors

#### 6. Build Gem

```
Building gem: rails_map-1.2.1.gem...
✓ Gem built successfully: rails_map-1.2.1.gem
```

#### 7. Final Confirmation

```
═══════════════════════════════════════════════════════
  READY TO PUSH TO RUBYGEMS
═══════════════════════════════════════════════════════
Gem: rails_map
Version: 1.2.1
File: rails_map-1.2.1.gem
Size: 45K

This will publish the gem to RubyGems.org
Are you sure you want to continue? (y/n)
```

#### 8. Push to RubyGems

```
Pushing gem to RubyGems...
✓ Gem pushed successfully to RubyGems!
```

#### 9. Git Tag (Optional)

```
Git tag: v1.2.1
Create and push git tag? (y/n)
```

#### 10. Cleanup

```
Local gem file: rails_map-1.2.1.gem
Delete local gem file? (y/n)
```

## Rollback Feature

If the push to RubyGems fails, the script offers to rollback:

```
✗ Failed to push gem to RubyGems

Would you like to rollback the version changes?
Rollback to version 1.2.0? (y/n)
```

If you choose yes, it will:

1. Revert `lib/rails_map/version.rb` to previous version
2. Revert `CHANGELOG.md` to `[Unreleased]`
3. Undo the git commit (if made)

## Version Numbering Guide

Follow [Semantic Versioning](https://semver.org/):

### MAJOR version (X.0.0)

Increment when you make incompatible API changes

```
1.2.0 → 2.0.0
```

**Examples:**

- Removing public methods
- Changing method signatures
- Removing configuration options
- Breaking backward compatibility

### MINOR version (x.Y.0)

Increment when you add functionality in a backward compatible manner

```
1.2.0 → 1.3.0
```

**Examples:**

- Adding new features
- Adding new configuration options
- Adding new methods
- Deprecating features (but not removing)

### PATCH version (x.y.Z)

Increment when you make backward compatible bug fixes

```
1.2.0 → 1.2.1
```

**Examples:**

- Bug fixes
- Security patches
- Documentation updates
- Performance improvements

## Pre-Release Checklist

Before running the script:

- [ ] All changes committed to git
- [ ] Tests passing locally
- [ ] CHANGELOG.md updated with changes (under `[Unreleased]`)
- [ ] Documentation updated
- [ ] Breaking changes documented
- [ ] Migration guide written (if needed)
- [ ] RubyGems credentials configured

## RubyGems Authentication

Ensure you're authenticated with RubyGems:

```bash
# First time setup
gem signin

# Or set API key
gem signin --key rubygems
```

## Troubleshooting

### "Invalid version format"

**Problem:** Version doesn't match semantic versioning
**Solution:** Use format `X.Y.Z` (e.g., `1.2.1`)

### "Failed to push gem to RubyGems"

**Possible causes:**

1. Not authenticated with RubyGems
2. Version already exists
3. Network issues
4. Insufficient permissions

**Solutions:**

```bash
# Check authentication
gem signin

# Check existing versions
gem list rails_map --remote --all

# Try manual push
gem push rails_map-1.2.1.gem
```

### "Tests failed"

**Problem:** Test suite not passing
**Solution:** Fix tests before releasing, or skip with 'y' when prompted

### "Can't find version.rb"

**Problem:** Script not run from project root
**Solution:** Run from project root directory:

```bash
cd /path/to/rails-map
./release.sh
```

## Manual Release (Without Script)

If you need to release manually:

```bash
# 1. Update version
vim lib/rails_map/version.rb

# 2. Update CHANGELOG
vim CHANGELOG.md

# 3. Commit changes
git add lib/rails_map/version.rb CHANGELOG.md
git commit -m "Bump version to 1.2.1"
git push

# 4. Build gem
gem build rails_map.gemspec

# 5. Push to RubyGems
gem push rails_map-1.2.1.gem

# 6. Create tag
git tag -a v1.2.1 -m "Release version 1.2.1"
git push origin v1.2.1

# 7. Create GitHub release
# Go to: https://github.com/ArshdeepGrover/rails-map/releases/new
```

## Post-Release Tasks

After successful release:

1. **Verify on RubyGems**

   ```
   https://rubygems.org/gems/rails_map
   ```

2. **Test installation**

   ```bash
   gem install rails_map
   ```

3. **Create GitHub Release**
   - Go to: https://github.com/ArshdeepGrover/rails-map/releases/new
   - Tag: v1.2.1
   - Title: RailsMap v1.2.1
   - Description: Copy from CHANGELOG.md

4. **Announce Release**
   - Twitter/X
   - Reddit (r/rails, r/ruby)
   - Dev.to
   - Ruby Weekly

5. **Update Documentation**
   - Homepage
   - Wiki
   - README (if needed)

## Script Customization

### Change Default Behavior

Edit `release.sh` to customize:

```bash
# Skip tests automatically
# Comment out the test section

# Auto-commit without asking
# Change the commit prompt section

# Skip git tagging
# Comment out the tagging section

# Keep gem file by default
# Change the cleanup section
```

## Safety Features

The script includes several safety features:

1. **Version Validation** - Ensures proper semantic versioning
2. **Confirmation Prompts** - Multiple confirmations before pushing
3. **Rollback Support** - Can undo changes if push fails
4. **Pre-flight Checks** - Validates before building
5. **Error Handling** - Exits gracefully on errors

## Examples

### Patch Release (Bug Fix)

```bash
./release.sh
# Enter: 1.2.1
# Commit: y
# Push: y
# Continue: y
# Tag: y
```

### Minor Release (New Feature)

```bash
./release.sh
# Enter: 1.3.0
# Commit: y
# Push: y
# Continue: y
# Tag: y
```

### Major Release (Breaking Changes)

```bash
./release.sh
# Enter: 2.0.0
# Commit: y
# Push: y
# Continue: y
# Tag: y
```

## Best Practices

1. **Always update CHANGELOG.md first** - Add changes under `[Unreleased]`
2. **Run tests locally** - Ensure everything works
3. **Review changes** - Double-check what's being released
4. **Use semantic versioning** - Follow the guidelines
5. **Create GitHub releases** - Document each release
6. **Announce releases** - Let the community know
7. **Monitor issues** - Watch for problems after release

## Support

If you encounter issues with the release script:

1. Check this guide
2. Review error messages
3. Try manual release process
4. Open an issue on GitHub

---

**Happy Releasing! 🚀**
