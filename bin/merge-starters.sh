#!/bin/bash

# Laravel TALL Merged Starter - Merge Script
# This script helps merge updates from both upstream starters

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TALL_STARTER_REPO="https://github.com/mortenebak/tallstarter"
LARAVEL_REPO="https://github.com/laravel/laravel"
WORK_DIR="/tmp/laravel-merge-$(date +%s)"
CONFIG_FILE="config/upstream-sources.json"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Laravel TALL Merged Starter - Merge Tool${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if running in project root
if [ ! -f "composer.json" ]; then
    echo -e "${RED}Error: Please run this script from the project root directory${NC}"
    exit 1
fi

# Function to display help
show_help() {
    echo "Usage: ./bin/merge-starters.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --dry-run        Show what would be updated without making changes"
    echo "  --tall-only      Only check/merge updates from TALL starter"
    echo "  --official-only  Only check/merge updates from Laravel official"
    echo "  --force          Skip confirmation prompts"
    echo "  --help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./bin/merge-starters.sh --dry-run"
    echo "  ./bin/merge-starters.sh --tall-only"
    echo ""
}

# Parse command line arguments
DRY_RUN=false
TALL_ONLY=false
OFFICIAL_ONLY=false
FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --tall-only)
            TALL_ONLY=true
            shift
            ;;
        --official-only)
            OFFICIAL_ONLY=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Function to read current versions
read_current_versions() {
    if [ -f "$CONFIG_FILE" ]; then
        CURRENT_TALL_COMMIT=$(jq -r '.sources.tall_starter.current_version.commit_hash' "$CONFIG_FILE")
        CURRENT_LARAVEL_VERSION=$(jq -r '.sources.laravel_official_livewire.current_version.laravel_version' "$CONFIG_FILE")
        echo -e "${GREEN}✓ Current versions loaded from $CONFIG_FILE${NC}"
        echo "  TALL Starter: $CURRENT_TALL_COMMIT"
        echo "  Laravel: $CURRENT_LARAVEL_VERSION"
    else
        echo -e "${YELLOW}Warning: $CONFIG_FILE not found${NC}"
        CURRENT_TALL_COMMIT="unknown"
        CURRENT_LARAVEL_VERSION="unknown"
    fi
}

# Function to check for TALL Starter updates
check_tall_updates() {
    echo ""
    echo -e "${BLUE}Checking TALL Starter updates...${NC}"

    # Clone TALL starter to temp directory
    mkdir -p "$WORK_DIR"
    git clone --quiet --depth=1 "$TALL_STARTER_REPO" "$WORK_DIR/tall-starter"

    LATEST_TALL_COMMIT=$(cd "$WORK_DIR/tall-starter" && git rev-parse HEAD)

    echo -e "${GREEN}✓ Latest TALL Starter commit: $LATEST_TALL_COMMIT${NC}"

    if [ "$CURRENT_TALL_COMMIT" != "$LATEST_TALL_COMMIT" ]; then
        echo -e "${YELLOW}⚠ Update available for TALL Starter${NC}"
        return 0
    else
        echo -e "${GREEN}✓ TALL Starter is up to date${NC}"
        return 1
    fi
}

# Function to check for Laravel updates
check_laravel_updates() {
    echo ""
    echo -e "${BLUE}Checking Laravel Official updates...${NC}"

    # Get latest Laravel version from Packagist
    LATEST_LARAVEL=$(curl -s "https://packagist.org/packages/laravel/framework.json" | jq -r '.package.versions | to_entries | map(select(.key | test("^v?[0-9]"))) | sort_by(.key) | reverse | .[0].key')

    echo -e "${GREEN}✓ Latest Laravel version: $LATEST_LARAVEL${NC}"

    if [ "$CURRENT_LARAVEL_VERSION" != "$LATEST_LARAVEL" ]; then
        echo -e "${YELLOW}⚠ Update available for Laravel${NC}"
        return 0
    else
        echo -e "${GREEN}✓ Laravel is up to date${NC}"
        return 1
    fi
}

# Function to generate changelog
generate_changelog() {
    echo ""
    echo -e "${BLUE}Generating changelog...${NC}"

    CHANGELOG_FILE="CHANGELOG-MERGE-$(date +%Y%m%d).md"

    cat > "$CHANGELOG_FILE" <<EOF
# Merge Changelog - $(date +%Y-%m-%d)

## Upstream Updates

### TALL Starter
- Previous: $CURRENT_TALL_COMMIT
- Latest: $LATEST_TALL_COMMIT
- Repository: $TALL_STARTER_REPO

### Laravel Official
- Previous: $CURRENT_LARAVEL_VERSION
- Latest: $LATEST_LARAVEL
- Repository: $LARAVEL_REPO

## Changes

Please review the changes in the upstream repositories:

- [TALL Starter Commits](https://github.com/mortenebak/tallstarter/compare/$CURRENT_TALL_COMMIT...$LATEST_TALL_COMMIT)
- [Laravel Releases](https://github.com/laravel/framework/releases)

## Manual Steps Required

1. Review dependency changes in composer.json
2. Check for new migrations
3. Review configuration file changes
4. Test all features
5. Update documentation if needed

EOF

    echo -e "${GREEN}✓ Changelog generated: $CHANGELOG_FILE${NC}"
}

# Main execution
echo -e "${BLUE}Step 1: Reading current versions...${NC}"
read_current_versions

UPDATES_AVAILABLE=false

if [ "$OFFICIAL_ONLY" = false ]; then
    if check_tall_updates; then
        UPDATES_AVAILABLE=true
    fi
fi

if [ "$TALL_ONLY" = false ]; then
    if check_laravel_updates; then
        UPDATES_AVAILABLE=true
    fi
fi

if [ "$UPDATES_AVAILABLE" = true ]; then
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}  Updates are available!${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    if [ "$DRY_RUN" = true ]; then
        echo -e "${BLUE}Dry run mode - no changes will be made${NC}"
        generate_changelog
    else
        echo ""
        echo "This script has detected updates but automatic merging is complex."
        echo "Please use the generated changelog and manually review the changes."
        echo ""

        if [ "$FORCE" = false ]; then
            read -p "Generate changelog? (y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                generate_changelog
            fi
        else
            generate_changelog
        fi

        echo ""
        echo -e "${BLUE}Recommended next steps:${NC}"
        echo "1. Review the changelog file"
        echo "2. Check upstream repositories for breaking changes"
        echo "3. Test updates in a separate branch"
        echo "4. Run: php artisan starter:check-updates (if available)"
        echo "5. Run: composer review (to check code quality)"
    fi
else
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  All upstream sources are up to date!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
fi

# Cleanup
if [ -d "$WORK_DIR" ]; then
    rm -rf "$WORK_DIR"
fi

echo ""
echo -e "${BLUE}Done!${NC}"
