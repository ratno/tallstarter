# Installation Guide

Complete guide to installing and setting up the Laravel TALL Merged Starter.

## Prerequisites

Before you begin, ensure you have the following installed:

- **PHP 8.2 or 8.3**
- **Composer 2.x**
- **Node.js 18+ and NPM**
- **SQLite** (or MySQL/PostgreSQL)
- **Git**

## Installation Methods

### Method 1: Git Clone (Recommended)

```bash
# Clone the repository
git clone https://github.com/YOUR-USERNAME/laravel-tall-merged-starter my-project
cd my-project

# Remove existing git history (optional)
rm -rf .git
git init

# Install PHP dependencies
composer install

# Install JavaScript dependencies
npm install

# Setup environment file
cp .env.example .env

# Generate application key
php artisan key:generate

# Create database (SQLite)
touch database/database.sqlite

# Run migrations
php artisan migrate

# Seed database (creates roles & permissions)
php artisan db:seed

# Create super admin user
php artisan app:create-super-admin

# Build frontend assets
npm run build

# Start development server
composer dev
```

### Method 2: Composer Create-Project

```bash
composer create-project your-username/laravel-tall-merged-starter my-project
cd my-project

# Create super admin
php artisan app:create-super-admin

# Install frontend dependencies
npm install

# Build assets
npm run build

# Start server
composer dev
```

## Environment Configuration

### Database Setup

#### Using SQLite (Default)

```env
DB_CONNECTION=sqlite
# DB_DATABASE will use database/database.sqlite
```

#### Using MySQL

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=your_database_name
DB_USERNAME=your_username
DB_PASSWORD=your_password
```

#### Using PostgreSQL

```env
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=your_database_name
DB_USERNAME=your_username
DB_PASSWORD=your_password
```

### Mail Configuration

For 2FA and email verification to work, configure your mail settings:

```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=your_username
MAIL_PASSWORD=your_password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS="noreply@yourapp.com"
MAIL_FROM_NAME="${APP_NAME}"
```

For development, you can use [Mailtrap](https://mailtrap.io/) or [MailHog](https://github.com/mailhog/MailHog).

### Application Settings

```env
APP_NAME="My Application"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

# Locale settings
APP_LOCALE=en
APP_FALLBACK_LOCALE=en
APP_FAKER_LOCALE=en_US
```

## Post-Installation Steps

### 1. Create Super Admin

```bash
php artisan app:create-super-admin
```

You'll be prompted to enter:
- Name
- Email
- Password

This user will have all permissions and the "Super Admin" role.

### 2. Configure Fortify Features

Edit `config/fortify.php` to enable/disable features:

```php
'features' => [
    Features::registration(),
    Features::resetPasswords(),
    Features::emailVerification(),
    Features::updateProfileInformation(),
    Features::updatePasswords(),
    Features::twoFactorAuthentication([
        'confirm' => true,
        'confirmPassword' => true,
    ]),
],
```

### 3. Set Up Queue Worker (Optional)

For production, set up a queue worker:

```bash
# Using Supervisor (recommended for production)
php artisan queue:work --daemon

# Or use Laravel Horizon (if installed)
php artisan horizon
```

### 4. Configure Permissions

The seeder creates these default permissions:

- users.view
- users.create
- users.edit
- users.delete
- roles.view
- roles.create
- roles.edit
- roles.delete
- permissions.view
- permissions.create
- permissions.edit
- permissions.delete
- admin.access
- admin.impersonate
- settings.manage

Customize in `database/seeders/PermissionSeeder.php`.

## Development Workflow

### Starting Development Servers

```bash
# All-in-one command (recommended)
composer dev

# This runs concurrently:
# - Laravel server (http://localhost:8000)
# - Queue worker
# - Log viewer (Pail)
# - Vite dev server (HMR)
```

### Separate Commands

```bash
# Laravel server only
php artisan serve

# Vite only (frontend)
npm run dev

# Queue worker
php artisan queue:listen

# Logs
php artisan pail
```

## Testing the Installation

### 1. Access the Application

Visit `http://localhost:8000` and you should see the welcome page.

### 2. Log In

- Go to `/login`
- Use the super admin credentials you created
- You should be redirected to `/dashboard`

### 3. Access Admin Panel

- Visit `/admin`
- You should see the admin dashboard
- Try accessing Users, Roles, and Permissions

### 4. Test 2FA

1. Go to Settings → Two-Factor Authentication
2. Enable 2FA
3. Scan the QR code with an authenticator app
4. Confirm the code
5. Log out and log back in
6. You should be prompted for 2FA code

### 5. Run Tests

```bash
# Run all tests
composer test:pest

# Run quality checks
composer review
```

## Troubleshooting

### Issue: Migration Failed

```bash
# Clear config cache
php artisan config:clear

# Drop all tables and re-migrate
php artisan migrate:fresh --seed
```

### Issue: Permission Denied Errors

```bash
# Fix storage permissions
chmod -R 775 storage bootstrap/cache

# Fix ownership (Linux/Mac)
sudo chown -R $USER:www-data storage bootstrap/cache
```

### Issue: npm run dev fails

```bash
# Clear npm cache
npm cache clean --force

# Remove node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

### Issue: Two-Factor Auth Not Working

1. Ensure queue worker is running
2. Check mail configuration
3. Verify time sync (TOTP requires accurate time)

```bash
# Test mail configuration
php artisan tinker
>>> Mail::raw('Test email', function($message) {
...     $message->to('test@example.com')->subject('Test');
... });
```

### Issue: Debugbar Not Showing

```bash
# Publish debugbar assets
php artisan vendor:publish --provider="Barryvdh\Debugbar\ServiceProvider"

# Clear cache
php artisan config:clear
php artisan view:clear
```

## Production Deployment

### Optimization

```bash
# Cache configuration
php artisan config:cache

# Cache routes
php artisan route:cache

# Cache views
php artisan view:cache

# Optimize autoloader
composer install --optimize-autoloader --no-dev

# Build assets for production
npm run build
```

### Environment Changes

```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://yourdomain.com

# Use a production-ready database
DB_CONNECTION=mysql

# Configure queue connection
QUEUE_CONNECTION=redis
```

### Security Checklist

- [ ] Set `APP_DEBUG=false`
- [ ] Use strong `APP_KEY`
- [ ] Enable HTTPS
- [ ] Set up SSL certificates
- [ ] Configure CORS properly
- [ ] Set secure session cookies
- [ ] Enable rate limiting
- [ ] Configure CSP headers
- [ ] Set up automated backups

## Next Steps

After successful installation:

1. **[Read the Features Guide](FEATURES.md)** - Learn about all features
2. **[Set Up Updates](UPDATING.md)** - Configure automatic updates
3. **[Customize Your App](#)** - Start building your features
4. **[Deploy to Production](#)** - Production deployment guide

## Getting Help

If you encounter issues:

- Check the [Troubleshooting](#troubleshooting) section
- Search [GitHub Issues](https://github.com/YOUR-USERNAME/laravel-tall-merged-starter/issues)
- Ask in [GitHub Discussions](https://github.com/YOUR-USERNAME/laravel-tall-merged-starter/discussions)
- Review [Laravel Documentation](https://laravel.com/docs)
