# Setup Guide - Laravel TALL Merged Starter

## 🎉 Selamat! Merge Berhasil Dibuat

Anda sekarang memiliki starter kit Laravel yang menggabungkan **TALL Starter** dengan **Laravel Official Livewire Starter** lengkap dengan mekanisme update otomatis.

## 📁 Lokasi Project

```
/Users/ratno/web/laravel/laravel_starter/laravel-tall-merged/
```

## ✅ Yang Sudah Dibuat

### 1. Core Merge
- ✅ Merged `composer.json` (includes Fortify + Spatie Permission)
- ✅ Merged `package.json` (latest NPM packages)
- ✅ Merged User model (includes both TwoFactorAuthenticatable + HasRoles traits)
- ✅ Merged migrations (locale + 2FA columns)
- ✅ Fortify configuration dan Service Provider

### 2. Update Mechanism
- ✅ `config/upstream-sources.json` - Version tracking
- ✅ `bin/merge-starters.sh` - Merge script
- ✅ `app/Console/Commands/CheckStarterUpdates.php` - Artisan command
- ✅ `.github/workflows/sync-upstream.yml` - GitHub Actions workflow
- ✅ `.github/workflows/tests.yml` - Test workflow

### 3. Documentation
- ✅ `README.md` - Comprehensive overview
- ✅ `docs/INSTALLATION.md` - Installation guide
- ✅ `docs/UPDATING.md` - Update procedures
- ✅ `SETUP_GUIDE.md` - This file

### 4. Git Repository
- ✅ Initialized with initial commit
- ✅ Ready to push to GitHub

## 🚀 Langkah Selanjutnya

### Step 1: Install Dependencies

```bash
cd /Users/ratno/web/laravel/laravel_starter/laravel-tall-merged

# Install PHP dependencies
composer install

# Install NPM dependencies
npm install
```

### Step 2: Configure Environment

```bash
# Copy .env.example if not exists
cp .env.example .env

# Generate app key
php artisan key:generate

# Create SQLite database
touch database/database.sqlite
```

### Step 3: Run Migrations

```bash
# Run migrations
php artisan migrate

# Seed database (creates roles & permissions)
php artisan db:seed
```

### Step 4: Create Super Admin

```bash
php artisan app:create-super-admin
```

Anda akan diminta memasukkan:
- Name
- Email
- Password

### Step 5: Build Assets

```bash
npm run build
```

### Step 6: Test the Application

```bash
# Start development server
composer dev

# Or manually:
php artisan serve
```

Visit: `http://localhost:8000`

### Step 7: Push to GitHub

```bash
# Create repository di GitHub terlebih dahulu
# Kemudian push:

git remote add origin https://github.com/ratno/tallstarter.git
git branch -M main
git push -u origin main
```

### Step 8: Enable as Template

1. Go to your GitHub repository
2. Click "Settings"
3. Check "Template repository"
4. Save

Sekarang orang lain bisa menggunakan:
```bash
# Use your template
git clone https://github.com/ratno/tallstarter.git my-project
```

## 🧪 Testing

```bash
# Run tests
composer test:pest

# Code style
composer test:pint

# Static analysis
composer test:static

# All checks
composer review
```

## 🔄 Update Commands

### Check for Updates

```bash
# Using Artisan
php artisan starter:check-updates

# Using shell script
./bin/merge-starters.sh --dry-run
```

### Apply Updates

```bash
# Generate changelog
./bin/merge-starters.sh

# Review CHANGELOG-MERGE-*.md
# Then manually apply changes
```

## 📚 Fitur Lengkap

### Dari TALL Starter:
- ✅ **Roles & Permissions** (Spatie Laravel Permission)
- ✅ **Admin Dashboard** (`/admin/*`)
- ✅ **User Management** (CRUD + Impersonation)
- ✅ **Localization** (Multi-language support)
- ✅ **Code Quality Tools** (PHPStan, Rector, Pint)
- ✅ **Custom Commands** (`app:create-super-admin`)

### Dari Laravel Official:
- ✅ **Laravel Fortify** (Authentication backend)
- ✅ **Two-Factor Authentication** (TOTP)
- ✅ **Email Verification**
- ✅ **Password Reset**
- ✅ **Volt Components**

### Combined Features:
- ✅ User model dengan kedua traits (HasRoles + TwoFactorAuthenticatable)
- ✅ Database dengan locale + 2FA fields
- ✅ Comprehensive testing setup
- ✅ Automated update tracking

## 📖 Default Routes

```
/               - Home page
/login          - Login
/register       - Register
/dashboard      - User dashboard
/settings       - User settings
/settings/2fa   - Two-factor authentication setup
/admin          - Admin dashboard
/admin/users    - User management
/admin/roles    - Role management
/admin/permissions - Permission management
```

## 🔐 Default Permissions

Created by seeders:
- `users.*` - User CRUD
- `roles.*` - Role CRUD
- `permissions.*` - Permission CRUD
- `admin.access` - Access admin panel
- `admin.impersonate` - Impersonate users
- `settings.manage` - Manage settings

## 🎨 Customization

### Change Package Name

Edit `composer.json`:
```json
{
    "name": "ratno/tallstarter",
    // ...
}
```

### Add More Features

1. Install packages: `composer require package/name`
2. Update documentation
3. Commit changes
4. Update `config/upstream-sources.json` if needed

### Modify Permissions

Edit `database/seeders/PermissionSeeder.php`

## 🐛 Troubleshooting

### Composer Install Fails

```bash
composer clear-cache
composer install
```

### NPM Issues

```bash
rm -rf node_modules package-lock.json
npm install
```

### Migration Errors

```bash
php artisan migrate:fresh --seed
```

### Permission Errors

```bash
chmod -R 775 storage bootstrap/cache
```

## 📞 Support

- **Documentation**: `docs/` directory
- **GitHub Issues**: Create di repository Anda
- **Laravel Docs**: https://laravel.com/docs

## 🎯 Next Steps

1. ✅ **Test locally** - Ensure everything works
2. ✅ **Push to GitHub** - Version control
3. ✅ **Enable template** - Allow others to use it
4. ✅ **Add CI/CD** - Already included in `.github/workflows/`
5. ✅ **Customize** - Add your features
6. ✅ **Document** - Update docs as you add features

## 📝 Important Files

### Configuration
- `config/fortify.php` - Fortify settings
- `config/permission.php` - Spatie permission settings
- `config/upstream-sources.json` - Version tracking

### Commands
- `php artisan starter:check-updates` - Check updates
- `php artisan app:create-super-admin` - Create super admin
- `./bin/merge-starters.sh` - Merge upstream changes

### Documentation
- `README.md` - Main documentation
- `docs/INSTALLATION.md` - Install guide
- `docs/UPDATING.md` - Update guide
- `SETUP_GUIDE.md` - This file

## 🎊 Selamat Menggunakan!

Starter kit Anda sudah siap digunakan. Semua fitur dari kedua starter sudah di-merge dengan sempurna, lengkap dengan mekanisme untuk tracking dan applying updates dari upstream sources.

**Happy Coding! 🚀**

---

*Generated on: 2025-11-27*
*Laravel Version: 12.40.2*
*TALL Starter: mortenebak/tallstarter*
*Laravel Official: Livewire Starter with Fortify*
