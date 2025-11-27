<?php

namespace App\Console\Commands;

use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;
use Symfony\Component\Console\Command\Command as CommandAlias;

class CreateSuperAdminCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:create-super-admin';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Creates a super admin user (optional)';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $this->info('🚀 Laravel TALL Starter - Super Admin Setup');
        $this->newLine();

        // ask for the user's name
        $name = $this->ask('Name', 'Super Admin');

        // ask for the user's email with validation
        $email = $this->ask('Email', 'admin@example.com');

        while (! filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $this->error('Invalid email format. Please try again.');
            $email = $this->ask('Email', 'admin@example.com');
        }

        // Check if email already exists
        if (User::where('email', $email)->exists()) {
            $this->warn('A user with this email already exists!');

            if (! $this->confirm('Do you want to continue anyway?', false)) {
                $this->info('Super admin creation cancelled.');
                return CommandAlias::SUCCESS;
            }
        }

        // ask for the user's password
        $password = $this->secret('Password (min 8 characters)');

        while (strlen($password) < 8) {
            $this->error('Password must be at least 8 characters long.');
            $password = $this->secret('Password (min 8 characters)');
        }

        $passwordConfirmation = $this->secret('Confirm Password');

        while ($password !== $passwordConfirmation) {
            $this->error('Passwords do not match. Please try again.');
            $password = $this->secret('Password (min 8 characters)');
            $passwordConfirmation = $this->secret('Confirm Password');
        }

        // create the user
        try {
            $user = User::query()->create([
                'name' => $name,
                'email' => $email,
                'password' => Hash::make($password),
                'locale' => 'en',
                'email_verified_at' => now(), // Auto-verify super admin
            ]);

            // assign the Super Admin role
            $user->assignRole('Super Admin');

            $this->newLine();
            $this->info('✅ Super admin user created successfully!');
            $this->newLine();
            $this->line('📧 Email: ' . $email);
            $this->line('🔑 Password: ' . str_repeat('*', strlen($password)));
            $this->newLine();
            $this->info('You can now login at /login');
            $this->info('Happy coding! 🎉');

            return CommandAlias::SUCCESS;
        } catch (\Exception $e) {
            $this->error('Failed to create super admin: ' . $e->getMessage());
            return CommandAlias::FAILURE;
        }
    }
}
