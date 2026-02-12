# URL Change Summary: /api-doc → /rails-map

## Overview

All references to `/api-doc` have been changed to `/rails-map` throughout the project for better branding and clarity.

## Files Updated

### Core Files

1. ✅ `lib/generators/rails_map/install_generator.rb` - Generator now mounts at `/rails-map`
2. ✅ `lib/generators/rails_map/templates/README` - Installation instructions updated

### Documentation Files

3. ✅ `README.md` - All examples and instructions updated
4. ✅ `CHANGELOG.md` - Both v1.2.0 and v1.1.0 entries updated
5. ✅ `QUICKSTART.md` - Quick start guide updated
6. ✅ `AUTHENTICATION.md` - Authentication examples updated
7. ✅ `SECURITY.md` - Security examples updated

### Gem Files

8. ✅ `rails_map.gemspec` - Description and post-install message updated

### Website

9. ✅ `docs/index.html` - Homepage demo URL updated

## What Changed

### Before

```ruby
mount RailsMap::Engine, at: '/api-doc'
```

Visit: `http://localhost:3000/api-doc`

### After

```ruby
mount RailsMap::Engine, at: '/rails-map'
```

Visit: `http://localhost:3000/rails-map`

## Impact

### For New Users

- Generator automatically mounts at `/rails-map`
- All documentation shows the new URL
- Post-install message shows correct URL

### For Existing Users

When upgrading to v1.2.0, users will need to update their routes:

```ruby
# config/routes.rb

# Old (still works but deprecated)
mount RailsMap::Engine, at: '/api-doc'

# New (recommended)
mount RailsMap::Engine, at: '/rails-map'
```

## Migration Guide for Existing Users

If you're upgrading from a previous version:

1. **Update your routes file:**

   ```ruby
   # config/routes.rb
   mount RailsMap::Engine, at: '/rails-map'  # Changed from '/api-doc'
   ```

2. **Update any bookmarks or documentation:**
   - Old: `http://localhost:3000/api-doc`
   - New: `http://localhost:3000/rails-map`

3. **Update any scripts or automation:**
   - Search for `/api-doc` in your codebase
   - Replace with `/rails-map`

4. **Restart your Rails server:**

   ```bash
   rails server
   ```

5. **Visit the new URL:**
   ```
   http://localhost:3000/rails-map
   ```

## Why This Change?

1. **Better Branding** - `/rails-map` clearly identifies the gem
2. **Consistency** - Matches the gem name `rails_map`
3. **Clarity** - More descriptive than generic `/api-doc`
4. **Uniqueness** - Less likely to conflict with other documentation tools

## Backward Compatibility

The change is **not backward compatible** by default. Users must update their routes file.

However, if you want to support both URLs temporarily:

```ruby
# config/routes.rb
mount RailsMap::Engine, at: '/rails-map'

# Optional: Support old URL temporarily
mount RailsMap::Engine, at: '/api-doc'  # Deprecated, remove in future
```

## Testing

After making the change, verify:

1. ✅ Generator creates correct route
2. ✅ Documentation loads at new URL
3. ✅ All internal links work
4. ✅ Authentication works (if enabled)
5. ✅ Static HTML generation works

## Rollback

If you need to use the old URL:

```ruby
# config/routes.rb
mount RailsMap::Engine, at: '/api-doc'
```

The engine will work at any path you specify.

## Future Considerations

- Consider adding a deprecation warning for `/api-doc` in future versions
- Could add automatic redirect from old URL to new URL
- Update any external documentation or blog posts

---

**Note:** This change was made in version 1.2.0 and affects all new installations. Existing installations need manual update.
