<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\File;

class CheckStarterUpdates extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'starter:check-updates
                            {--json : Output results as JSON}
                            {--verbose : Show detailed information}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Check for updates from upstream starter sources (TALL Starter & Laravel Official)';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $this->info('🔍 Checking for upstream updates...');
        $this->newLine();

        $configPath = config_path('upstream-sources.json');

        if (! File::exists($configPath)) {
            $this->error('❌ Config file not found: ' . $configPath);
            return self::FAILURE;
        }

        $config = json_decode(File::get($configPath), true);

        $updates = [];

        // Check TALL Starter
        $this->line('📦 Checking TALL Starter (mortenebak/tallstarter)...');
        $tallUpdate = $this->checkTallStarter($config['sources']['tall_starter'] ?? []);
        $updates['tall_starter'] = $tallUpdate;

        // Check Laravel Official
        $this->line('📦 Checking Laravel Official Livewire Starter...');
        $laravelUpdate = $this->checkLaravelOfficial($config['sources']['laravel_official_livewire'] ?? []);
        $updates['laravel_official'] = $laravelUpdate;

        $this->newLine();

        if ($this->option('json')) {
            $this->line(json_encode($updates, JSON_PRETTY_PRINT));
            return self::SUCCESS;
        }

        // Display results
        $this->displayResults($updates);

        $hasUpdates = $tallUpdate['has_update'] || $laravelUpdate['has_update'];

        if ($hasUpdates) {
            $this->newLine();
            $this->info('💡 To apply updates, run:');
            $this->line('   ./bin/merge-starters.sh');
            $this->line('   or');
            $this->line('   php artisan starter:sync');
            return self::SUCCESS;
        }

        $this->info('✅ All sources are up to date!');
        return self::SUCCESS;
    }

    /**
     * Check for TALL Starter updates
     */
    protected function checkTallStarter(array $config): array
    {
        try {
            $response = Http::get('https://api.github.com/repos/mortenebak/tallstarter/commits/main');

            if ($response->failed()) {
                return [
                    'has_update' => false,
                    'error' => 'Failed to fetch latest commit',
                    'current' => $config['current_version']['commit_hash'] ?? 'unknown',
                ];
            }

            $latestCommit = $response->json()['sha'] ?? null;
            $currentCommit = $config['current_version']['commit_hash'] ?? 'unknown';

            $hasUpdate = $latestCommit && $currentCommit !== 'main' && $latestCommit !== $currentCommit;

            return [
                'has_update' => $hasUpdate,
                'current' => $currentCommit,
                'latest' => $latestCommit,
                'repository' => 'https://github.com/mortenebak/tallstarter',
            ];
        } catch (\Exception $e) {
            return [
                'has_update' => false,
                'error' => $e->getMessage(),
                'current' => $config['current_version']['commit_hash'] ?? 'unknown',
            ];
        }
    }

    /**
     * Check for Laravel Official updates
     */
    protected function checkLaravelOfficial(array $config): array
    {
        try {
            $response = Http::get('https://packagist.org/packages/laravel/framework.json');

            if ($response->failed()) {
                return [
                    'has_update' => false,
                    'error' => 'Failed to fetch latest version',
                    'current' => $config['current_version']['laravel_version'] ?? 'unknown',
                ];
            }

            $versions = $response->json()['package']['versions'] ?? [];

            // Filter out dev versions and get latest stable
            $stableVersions = array_filter(array_keys($versions), function ($version) {
                return preg_match('/^v?\d+\.\d+\.\d+$/', $version);
            });

            rsort($stableVersions, SORT_NATURAL);
            $latestVersion = $stableVersions[0] ?? null;

            $currentVersion = $config['current_version']['laravel_version'] ?? 'unknown';
            $hasUpdate = $latestVersion && version_compare($latestVersion, $currentVersion, '>');

            return [
                'has_update' => $hasUpdate,
                'current' => $currentVersion,
                'latest' => $latestVersion,
                'repository' => 'https://github.com/laravel/framework',
            ];
        } catch (\Exception $e) {
            return [
                'has_update' => false,
                'error' => $e->getMessage(),
                'current' => $config['current_version']['laravel_version'] ?? 'unknown',
            ];
        }
    }

    /**
     * Display check results
     */
    protected function displayResults(array $updates): void
    {
        $this->table(
            ['Source', 'Current', 'Latest', 'Status'],
            [
                [
                    'TALL Starter',
                    substr($updates['tall_starter']['current'] ?? 'unknown', 0, 8),
                    substr($updates['tall_starter']['latest'] ?? 'unknown', 0, 8),
                    $updates['tall_starter']['has_update'] ? '⚠️  Update Available' : '✅ Up to Date'
                ],
                [
                    'Laravel Official',
                    $updates['laravel_official']['current'] ?? 'unknown',
                    $updates['laravel_official']['latest'] ?? 'unknown',
                    $updates['laravel_official']['has_update'] ? '⚠️  Update Available' : '✅ Up to Date'
                ],
            ]
        );
    }
}
