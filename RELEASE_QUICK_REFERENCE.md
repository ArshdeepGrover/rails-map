# Release Script Quick Reference

## Quick Start

```bash
./release.sh
```

## What It Does

1. ✅ Asks for new version number
2. ✅ Updates `lib/rails_map/version.rb`
3. ✅ Updates `CHANGELOG.md` (if has `[Unreleased]`)
4. ✅ Commits changes (optional)
5. ✅ Runs tests
6. ✅ Builds gem
7. ✅ Pushes to RubyGems
8. ✅ Creates git tag (optional)
9. ✅ Cleans up

## Version Format

```
MAJOR.MINOR.PATCH
```

Examples: `1.2.0`, `1.2.1`, `2.0.0`

## When to Bump

| Type      | When                               | Example       |
| --------- | ---------------------------------- | ------------- |
| **PATCH** | Bug fixes, security patches        | 1.2.0 → 1.2.1 |
| **MINOR** | New features (backward compatible) | 1.2.0 → 1.3.0 |
| **MAJOR** | Breaking changes                   | 1.2.0 → 2.0.0 |

## Pre-Release Checklist

```bash
# 1. Update CHANGELOG.md
vim CHANGELOG.md  # Add changes under [Unreleased]

# 2. Run tests
bundle exec rake spec

# 3. Commit changes
git add .
git commit -m "Prepare for release"

# 4. Run release script
./release.sh
```

## Prompts You'll See

```
Current version: 1.2.0
Enter the new version number: 1.2.1
Is this correct? (y/n) y
Commit version changes? (y/n) y
Push to remote? (y/n) y
Continue with tests? (y/n) y
Push to RubyGems? (y/n) y
Create git tag? (y/n) y
Push tag to remote? (y/n) y
Delete local gem file? (y/n) y
```

## Common Commands

```bash
# Make script executable
chmod +x release.sh

# Run release
./release.sh

# Check RubyGems auth
gem signin

# View gem versions
gem list rails_map --remote --all

# Manual push (if needed)
gem push rails_map-1.2.1.gem
```

## Rollback

If push fails, script offers rollback:

- Reverts version.rb
- Reverts CHANGELOG.md
- Undoes git commit

## Post-Release

1. Verify: https://rubygems.org/gems/rails_map
2. Test: `gem install rails_map`
3. Create GitHub release
4. Announce on social media

## Troubleshooting

| Problem             | Solution             |
| ------------------- | -------------------- |
| Invalid version     | Use X.Y.Z format     |
| Push failed         | Run `gem signin`     |
| Tests failed        | Fix tests or skip    |
| Not in project root | `cd` to project root |

## Full Documentation

See `RELEASE_SCRIPT_GUIDE.md` for complete documentation.
