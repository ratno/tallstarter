# Changelog

All notable changes to `ratno/tallstarter` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-11-27

### Added
- Initial release of Laravel TALL Merged Starter
- **Authentication & Security**
  - Laravel Fortify authentication backend
  - Two-Factor Authentication (2FA) with TOTP
  - Email verification
  - Password reset functionality
  - Session management
- **User Management & Permissions**
  - Complete RBAC system using Spatie Laravel Permission
  - User CRUD operations
  - User impersonation for admin support
  - Role management interface
  - Permission management interface
  - Pre-seeded roles and permissions
- **Admin Panel**
  - Comprehensive admin dashboard (`/admin/*`)
  - User administration interface
  - Role & permission management UI
  - Analytics dashboard
- **Localization**
  - Multi-language support (English, Danish)
  - User-specific locale preferences
  - Locale switching UI
  - Localization middleware
- **Developer Tools**
  - PHPStan (Larastan) for static analysis
  - Rector for automated refactoring
  - Laravel Pint for code style
  - Pest testing framework
  - Laravel IDE Helper
  - Debugbar for development
- **TALL Stack Components**
  - Tailwind CSS 4
  - Alpine.js integration
  - Laravel 12 framework
  - Livewire 3 full-stack framework
  - Volt functional API
  - Flux UI components
- **Additional Features**
  - Livewire Alert for SweetAlert notifications
  - Wire Elements Modal components
  - Custom Artisan commands (`app:create-super-admin`, `starter:check-updates`)
  - Database seeders for roles & permissions
  - Comprehensive test suite (25 test files)
  - GitHub Actions CI/CD workflows
  - Automated update tracking from upstream sources

### Infrastructure
- **Update Mechanism**
  - Version tracking via `config/upstream-sources.json`
  - Shell script for checking updates (`bin/merge-starters.sh`)
  - Artisan command for update checks (`starter:check-updates`)
  - GitHub Actions workflow for weekly upstream sync
  - Automated update notifications
- **Documentation**
  - Comprehensive README.md
  - Detailed installation guide (docs/INSTALLATION.md)
  - Complete updating procedures (docs/UPDATING.md)
  - Setup guide for quick start
  - Merge strategy documentation

### Testing
- Authentication tests (5 test files)
- Admin panel tests (10 test files)
- Settings tests (2 test files)
- Command tests (1 test file)
- Example tests (2 test files)
- Pest configuration
- Code quality checks via composer scripts

### Configuration
- Fortify configuration for authentication
- Spatie Permission configuration
- PHPStan configuration
- Rector configuration
- Pest configuration
- GitHub Actions workflows

## Credits

This starter kit is built by merging:
- [mortenebak/tallstarter](https://github.com/mortenebak/tallstarter) - TALL stack starter with admin features
- [Laravel Official Livewire Starter](https://laravel.com) - Laravel's official starter kit with Fortify

## Links

- [GitHub Repository](https://github.com/ratno/tallstarter)
- [Issue Tracker](https://github.com/ratno/tallstarter/issues)
- [Packagist](https://packagist.org/packages/ratno/tallstarter)

[Unreleased]: https://github.com/ratno/tallstarter/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/ratno/tallstarter/releases/tag/v1.0.0
