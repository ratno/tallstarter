# Updating Guide

This guide explains how to keep your Laravel TALL Merged Starter up-to-date with the latest changes from upstream sources.

## Overview

This starter kit tracks two upstream sources:

1. **[mortenebak/tallstarter](https://github.com/mortenebak/tallstarter)** - TALL stack features
2. **Laravel Official Livewire Starter** - Fortify and 2FA features

Updates from both sources are tracked and can be applied to keep your starter current.

## Automatic Update Checks

### GitHub Actions Workflow

A GitHub Actions workflow runs weekly to check for updates:

**Location**: `.github/workflows/sync-upstream.yml`

**Schedule**: Every Monday at 00:00 UTC

**What it does**:
1. Checks for new commits in TALL Starter
2. Checks for new Laravel versions
3. Creates a GitHub Issue if updates are available

### Manual Trigger

You can manually trigger the workflow:

1. Go to your repository on GitHub
2. Click "Actions" tab
3. Select "Sync Upstream Sources"
4. Click "Run workflow"

## Checking for Updates

### Using Artisan Command

```bash
# Check for updates
php artisan starter:check-updates

# Output as JSON
php artisan starter:check-updates --json

# Verbose output
php artisan starter:check-updates --verbose
```

**Example output:**
```
🔍 Checking for upstream updates...

📦 Checking TALL Starter (mortenebak/tallstarter)...
📦 Checking Laravel Official Livewire Starter...

+------------------+-----------+-----------+---------------------+
| Source           | Current   | Latest    | Status              |
+------------------+-----------+-----------+---------------------+
| TALL Starter     | abc123... | def456... | ⚠️  Update Available |
| Laravel Official | 12.20.0   | 12.40.2   | ⚠️  Update Available |
+------------------+-----------+-----------+---------------------+

💡 To apply updates, run:
   ./bin/merge-starters.sh
   or
   php artisan starter:sync
```

### Using Merge Script

```bash
# Check for updates (dry run)
./bin/merge-starters.sh --dry-run

# Check TALL Starter only
./bin/merge-starters.sh --tall-only --dry-run

# Check Laravel Official only
./bin/merge-starters.sh --official-only --dry-run
```

## Applying Updates

### Important: Before You Update

1. **Create a backup** of your database
2. **Commit your changes** to git
3. **Create a new branch** for the update
4. **Review the changelog** from upstream sources
5. **Check for breaking changes**

```bash
# Create backup branch
git checkout -b backup-before-update

# Commit everything
git add .
git commit -m "Backup before applying upstream updates"

# Create update branch
git checkout -b update-upstream-$(date +%Y%m%d)
```

### Step 1: Generate Changelog

```bash
# Run the merge script
./bin/merge-starters.sh

# This will generate: CHANGELOG-MERGE-YYYYMMDD.md
```

### Step 2: Review Changes

Review the generated changelog file:

```bash
# View the changelog
cat CHANGELOG-MERGE-*.md
```

Check upstream repositories for details:
- [TALL Starter Commits](https://github.com/mortenebak/tallstarter/commits/main)
- [Laravel Releases](https://github.com/laravel/framework/releases)

### Step 3: Manual Merge Process

Since automatic merging can cause conflicts, follow this manual process:

#### 3.1. Update Dependencies

Compare and update `composer.json`:

```bash
# Check for new package versions
composer outdated

# Update specific packages
composer update laravel/framework laravel/fortify spatie/laravel-permission

# Or update all
composer update
```

#### 3.2. Update NPM Packages

```bash
# Check for updates
npm outdated

# Update packages
npm update

# Or use npm-check-updates
npx npm-check-updates -u
npm install
```

#### 3.3. Review Configuration Files

Check for changes in:
- `config/fortify.php`
- `config/permission.php`
- `config/app.php`
- `.env.example`

#### 3.4. Check for New Migrations

```bash
# Look for new migration files in upstream repos
# If found, copy them to database/migrations/

# Then run migrations
php artisan migrate
```

#### 3.5. Update Views and Components

Compare Livewire components and views:
- `resources/views/livewire/`
- `app/Livewire/`

#### 3.6. Review Service Providers

Check for changes in:
- `app/Providers/FortifyServiceProvider.php`
- `app/Providers/AppServiceProvider.php`

### Step 4: Test Everything

```bash
# Clear all caches
php artisan optimize:clear

# Run migrations (if any new ones)
php artisan migrate

# Re-seed if needed (BE CAREFUL in production!)
php artisan db:seed

# Run tests
composer test:pest

# Run quality checks
composer review

# Test manually:
# - Login/Registration
# - Two-Factor Authentication
# - Admin panel
# - User management
# - Roles & Permissions
# - Localization switching
```

### Step 5: Update Version Tracking

Update `config/upstream-sources.json`:

```json
{
    "sources": {
        "tall_starter": {
            "current_version": {
                "commit_hash": "NEW_COMMIT_HASH",
                "laravel_version": "12.40.2",
                "last_checked": "2025-11-27",
                "last_synced": "2025-11-27"
            }
        },
        "laravel_official_livewire": {
            "current_version": {
                "laravel_version": "12.40.2",
                "fortify_version": "^1.30",
                "last_checked": "2025-11-27",
                "last_synced": "2025-11-27"
            }
        }
    },
    "last_update_check": "2025-11-27T10:00:00Z"
}
```

### Step 6: Commit and Deploy

```bash
# Add all changes
git add .

# Commit with detailed message
git commit -m "Update upstream sources - $(date +%Y-%m-%d)

- Updated TALL Starter from abc123 to def456
- Updated Laravel from 12.20.0 to 12.40.2
- Added new feature XYZ
- Fixed issue ABC

See CHANGELOG-MERGE-YYYYMMDD.md for details"

# Push to remote
git push origin update-upstream-$(date +%Y%m%d)

# Create pull request for review
```

## Update Strategies

### Strategy 1: Conservative (Recommended)

Update only when necessary, thoroughly test before deploying.

```bash
# Monthly check
php artisan starter:check-updates

# Only update if critical security fixes or major features
```

### Strategy 2: Regular Updates

Stay current with latest versions, update bi-weekly or monthly.

```bash
# Bi-weekly checks
./bin/merge-starters.sh --dry-run

# Review and apply updates in development first
```

### Strategy 3: Aggressive

Always use latest versions (not recommended for production).

```bash
# Weekly updates
composer update
npm update
```

## Handling Conflicts

### File Conflicts

If you've customized files that have upstream changes:

1. **Manual merge**: Use a diff tool to merge changes
2. **Git merge**: Use git merge strategies
3. **Keep yours**: If your customizations are intentional
4. **Take theirs**: If upstream changes are better

```bash
# Use a diff tool
code --diff file-yours.php file-theirs.php

# Use git mergetool
git mergetool
```

### Database Conflicts

If new migrations conflict with your schema:

1. **Review the migration** carefully
2. **Modify if needed** to fit your schema
3. **Test on a copy** of your database first
4. **Create a rollback plan**

### Dependency Conflicts

If package dependencies conflict:

```bash
# Check what's conflicting
composer why-not package/name version

# Try updating in steps
composer update package/name --with-dependencies

# Check for alternatives
# May need to wait for package compatibility
```

## Rollback Procedure

If an update causes issues:

```bash
# Checkout your backup branch
git checkout backup-before-update

# Or revert specific commits
git revert <commit-hash>

# Restore database backup
# (use your backup restoration method)

# Clear caches
php artisan optimize:clear

# Reinstall dependencies
composer install
npm install

# Rebuild assets
npm run build
```

## Version Tracking

The `config/upstream-sources.json` file tracks:

- Current commit hash of TALL Starter
- Current Laravel version
- Last sync date
- Features included from each source

Always update this file after applying updates.

## Best Practices

1. ✅ **Always test in development first**
2. ✅ **Create backups before updating**
3. ✅ **Use version control** (Git branches)
4. ✅ **Review changelogs** from upstream
5. ✅ **Run full test suite** after updates
6. ✅ **Update documentation** if features change
7. ✅ **Notify team members** of updates
8. ✅ **Monitor for issues** after deployment

## Troubleshooting Updates

### Issue: Composer Update Fails

```bash
# Clear composer cache
composer clear-cache

# Update composer itself
composer self-update

# Try with verbose output
composer update -vvv
```

### Issue: Migration Fails

```bash
# Check migration status
php artisan migrate:status

# Try step-by-step
php artisan migrate --step

# Rollback last batch
php artisan migrate:rollback
```

### Issue: Tests Fail After Update

```bash
# Clear all caches
php artisan optimize:clear

# Regenerate autoload files
composer dump-autoload

# Re-run migrations in test environment
php artisan migrate --env=testing

# Run tests with verbosity
./vendor/bin/pest --verbose
```

## Getting Help

If you encounter issues during updates:

1. Check the [Troubleshooting](#troubleshooting-updates) section
2. Review upstream changelogs for breaking changes
3. Search [GitHub Issues](https://github.com/YOUR-USERNAME/laravel-tall-merged-starter/issues)
4. Ask in [GitHub Discussions](https://github.com/YOUR-USERNAME/laravel-tall-merged-starter/discussions)
5. Check upstream repositories for similar issues

## Automated Update Tools (Future)

Planned features for easier updates:

- [ ] `php artisan starter:sync` command for automatic merging
- [ ] Conflict resolution wizard
- [ ] Automated testing before applying updates
- [ ] One-click update button in admin panel
- [ ] Email notifications for new updates

## Contributing Update Strategies

If you develop a better update strategy, please:

1. Document your process
2. Submit a pull request
3. Share in GitHub Discussions

Help make updates easier for everyone!
