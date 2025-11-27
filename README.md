# Laravel TALL Merged Starter 🚀

A comprehensive Laravel 12 starter kit that combines the best of **[mortenebak/tallstarter](https://github.com/mortenebak/tallstarter)** with **Laravel's Official Livewire Starter Kit**, giving you a production-ready application with enterprise-level features.

## ✨ Features

This starter kit includes everything you need to build modern Laravel applications:

### 🔐 Authentication & Security
- **Laravel Fortify** - Robust authentication backend
- **Two-Factor Authentication (2FA)** - Enhanced security with TOTP
- **Email Verification** - Verify user email addresses
- **Password Reset** - Secure password recovery
- **Session Management** - Control active sessions

### 👥 User Management & Permissions
- **Roles & Permissions** - Complete RBAC system using Spatie Laravel Permission
- **User CRUD** - Full user management interface
- **User Impersonation** - Admin can impersonate users for support
- **Role Management** - Create and manage roles
- **Permission Management** - Fine-grained permission control

### 🎨 Admin Panel
- **Admin Dashboard** - Comprehensive admin area (`/admin/*`)
- **User Administration** - Manage all users
- **Role & Permission UI** - Visual management of RBAC
- **Analytics Dashboard** - Key metrics at a glance

### 🌍 Localization
- **Multi-language Support** - Built-in internationalization
- **User Locale Preference** - Each user can choose their language
- **Locale Switching** - Easy language switcher in UI

### 🛠️ Developer Tools
- **Code Quality Tools**:
  - **PHPStan** (Larastan) - Static analysis
  - **Rector** - Automated refactoring
  - **Laravel Pint** - Code style fixer
  - **Pest** - Modern testing framework
- **IDE Support** - Laravel IDE Helper included
- **Debugbar** - Development debugging (dev only)

### 🎯 TALL Stack
- **Tailwind CSS 4** - Utility-first CSS framework
- **Alpine.js** - Minimal JavaScript framework
- **Laravel 12** - The latest Laravel version
- **Livewire 3** - Full-stack framework for Laravel
- **Volt** - Functional API for Livewire
- **Flux UI** - Beautiful UI components

### 📦 Additional Features
- **Livewire Alert** - SweetAlert notifications
- **Wire Elements Modal** - Modal components
- **Custom Artisan Commands** - Helpful CLI tools
- **Database Seeders** - Pre-configured roles & permissions
- **Automated Testing** - Comprehensive test suite

## 🚀 Quick Start

### Using Laravel New

```bash
# Clone this repository as a template
git clone https://github.com/YOUR-USERNAME/laravel-tall-merged-starter my-project
cd my-project

# Install dependencies
composer install
npm install

# Setup environment
cp .env.example .env
php artisan key:generate

# Create database
touch database/database.sqlite

# Run migrations and seeders
php artisan migrate --seed

# Create super admin
php artisan app:create-super-admin

# Build assets
npm run build

# Start development server
composer dev
```

### Using Composer Create-Project

```bash
composer create-project your-username/laravel-tall-merged-starter my-project
cd my-project
php artisan app:create-super-admin
npm install && npm run build
composer dev
```

## 📚 Documentation

Detailed documentation is available in the `docs/` directory:

- **[Installation Guide](docs/INSTALLATION.md)** - Complete installation instructions
- **[Features Overview](docs/FEATURES.md)** - Detailed feature documentation
- **[Update Guide](docs/UPDATING.md)** - How to keep your starter up-to-date
- **[Merge Strategy](docs/MERGE_STRATEGY.md)** - Understanding the merge approach

## 🔄 Keeping Up-to-Date

This starter automatically tracks updates from both upstream sources:

### Automatic Checks (GitHub Actions)
- Weekly automated checks for updates
- GitHub Issues created when updates are available
- Version tracking in `config/upstream-sources.json`

### Manual Checks

```bash
# Check for updates
php artisan starter:check-updates

# Run merge script
./bin/merge-starters.sh

# Dry run (preview only)
./bin/merge-starters.sh --dry-run
```

## 🏗️ Project Structure

```
laravel-tall-merged/
├── app/
│   ├── Actions/Fortify/          # Fortify actions (2FA, auth)
│   ├── Console/Commands/         # Custom Artisan commands
│   ├── Http/
│   │   ├── Controllers/          # Controllers (incl. Impersonation)
│   │   └── Middleware/           # Custom middleware (Localization)
│   ├── Livewire/
│   │   ├── Admin/                # Admin panel components
│   │   ├── Auth/                 # Authentication components
│   │   └── Settings/             # User settings (incl. 2FA)
│   └── Models/                   # Eloquent models
├── bin/
│   └── merge-starters.sh         # Update merge script
├── config/
│   ├── fortify.php               # Fortify configuration
│   ├── permission.php            # Spatie permissions config
│   └── upstream-sources.json     # Version tracking
├── database/
│   ├── migrations/               # Database migrations
│   └── seeders/                  # Database seeders (roles, permissions)
├── docs/                         # Documentation
├── resources/
│   └── views/livewire/           # Livewire views
└── tests/                        # Pest tests
```

## 🧪 Testing

```bash
# Run all tests
composer test:pest

# Run with parallel execution
composer test:pest

# Code style check
composer test:pint

# Static analysis
composer test:static

# Rector check
composer test:rector

# Run all quality checks
composer review
```

## 🎨 Development

```bash
# Start development servers (Laravel + Vite + Queue + Logs)
composer dev

# This runs:
# - php artisan serve (port 8000)
# - php artisan queue:listen
# - php artisan pail (log viewer)
# - npm run dev (Vite HMR)
```

## 📋 Default Credentials

After running `php artisan app:create-super-admin`, you'll be prompted to create a super admin user.

## 🔒 Security Features

- **Two-Factor Authentication** - TOTP-based 2FA
- **Role-Based Access Control** - Spatie permissions
- **Password Hashing** - Bcrypt by default
- **CSRF Protection** - Built-in Laravel protection
- **XSS Protection** - Blade automatic escaping
- **SQL Injection Protection** - Eloquent query builder

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines first.

## 📝 License

This project is open-sourced software licensed under the [MIT license](LICENSE).

## 🙏 Credits

This starter kit is built on top of:

- **[mortenebak/tallstarter](https://github.com/mortenebak/tallstarter)** - TALL stack starter with admin features
- **[Laravel Official Livewire Starter](https://laravel.com)** - Laravel's official starter kit
- **[Spatie Laravel Permission](https://spatie.be/docs/laravel-permission)** - Role and permission management
- **[Laravel Fortify](https://laravel.com/docs/fortify)** - Authentication backend

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/YOUR-USERNAME/laravel-tall-merged-starter/issues)
- **Discussions**: [GitHub Discussions](https://github.com/YOUR-USERNAME/laravel-tall-merged-starter/discussions)

## 🗺️ Roadmap

- [ ] Multi-tenancy support
- [ ] API authentication (Sanctum)
- [ ] Team management
- [ ] Subscription billing (Cashier)
- [ ] Advanced audit logging
- [ ] Real-time notifications

---

**Built with ❤️ using the TALL stack**

[Laravel](https://laravel.com) • [Livewire](https://livewire.laravel.com) • [Alpine.js](https://alpinejs.dev) • [Tailwind CSS](https://tailwindcss.com)
