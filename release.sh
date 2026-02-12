#!/bin/bash

# RailsMap Release Script
# This script builds, pushes the gem to RubyGems, and cleans up old gem files

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ ${NC}$1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Get the current version from version.rb
VERSION=$(ruby -r ./lib/rails_map/version.rb -e "puts RailsMap::VERSION")
GEM_NAME="rails_map"
GEM_FILE="${GEM_NAME}-${VERSION}.gem"

echo ""
print_info "═══════════════════════════════════════════════════════"
print_info "  RailsMap Release Script v${VERSION}"
print_info "═══════════════════════════════════════════════════════"
echo ""

# Pre-flight checks
print_info "Running pre-flight checks..."

# Check if version.rb exists
if [ ! -f "lib/rails_map/version.rb" ]; then
    print_error "lib/rails_map/version.rb not found!"
    exit 1
fi

# Check if gemspec exists
if [ ! -f "${GEM_NAME}.gemspec" ]; then
    print_error "${GEM_NAME}.gemspec not found!"
    exit 1
fi

# Check if CHANGELOG.md has the current version
if ! grep -q "\[${VERSION}\]" CHANGELOG.md; then
    print_warning "CHANGELOG.md doesn't contain version ${VERSION}"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Release cancelled"
        exit 1
    fi
fi

print_success "Pre-flight checks passed"
echo ""

# Step 1: Show current status
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
print_info "Current branch: ${CURRENT_BRANCH}"
print_info "Version to release: ${VERSION}"
echo ""

# Step 2: Check for uncommitted changes
if [[ -n $(git status -s 2>/dev/null) ]]; then
    print_warning "You have uncommitted changes:"
    git status -s
    echo ""
    read -p "Continue with uncommitted changes? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Release cancelled"
        print_info "Please commit your changes first"
        exit 1
    fi
fi

# Step 3: Run tests (if available)
if [ -f "Rakefile" ]; then
    print_info "Running tests..."
    if bundle exec rake spec 2>/dev/null; then
        print_success "Tests passed"
    else
        print_warning "Tests failed or not configured"
        read -p "Continue anyway? (y/n) " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Release cancelled"
            exit 1
        fi
    fi
    echo ""
fi

# Step 4: Delete old gem files
print_info "Cleaning up old gem files..."
OLD_GEMS=$(ls ${GEM_NAME}-*.gem 2>/dev/null || true)
if [ -n "$OLD_GEMS" ]; then
    for gem_file in $OLD_GEMS; do
        rm -f "$gem_file"
        print_success "Deleted: $gem_file"
    done
else
    print_info "No old gem files found"
fi
echo ""

# Step 5: Build the gem
print_info "Building gem: ${GEM_FILE}..."
echo ""
if gem build ${GEM_NAME}.gemspec; then
    echo ""
    print_success "Gem built successfully: ${GEM_FILE}"
else
    echo ""
    print_error "Failed to build gem"
    exit 1
fi
echo ""

# Step 6: Verify the gem file exists
if [ ! -f "$GEM_FILE" ]; then
    print_error "Gem file not found: ${GEM_FILE}"
    exit 1
fi

# Step 7: Show gem size
GEM_SIZE=$(ls -lh "$GEM_FILE" | awk '{print $5}')
print_info "Gem size: ${GEM_SIZE}"
echo ""

# Step 8: Final confirmation before pushing
print_warning "═══════════════════════════════════════════════════════"
print_warning "  READY TO PUSH TO RUBYGEMS"
print_warning "═══════════════════════════════════════════════════════"
print_info "Gem: ${GEM_NAME}"
print_info "Version: ${VERSION}"
print_info "File: ${GEM_FILE}"
print_info "Size: ${GEM_SIZE}"
echo ""
print_warning "This will publish the gem to RubyGems.org"
read -p "Are you sure you want to continue? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_error "Release cancelled"
    print_info "Gem file ${GEM_FILE} has been built but not pushed"
    print_info "You can manually push it later with: gem push ${GEM_FILE}"
    exit 0
fi
echo ""

# Step 9: Push to RubyGems
print_info "Pushing gem to RubyGems..."
if gem push $GEM_FILE; then
    echo ""
    print_success "Gem pushed successfully to RubyGems!"
else
    echo ""
    print_error "Failed to push gem to RubyGems"
    print_info "Gem file ${GEM_FILE} is still available locally"
    print_info "You can try pushing manually with: gem push ${GEM_FILE}"
    exit 1
fi
echo ""

# Step 10: Create git tag
TAG_NAME="v${VERSION}"
print_info "Git tag: ${TAG_NAME}"
read -p "Create and push git tag? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if git tag -a "$TAG_NAME" -m "Release version ${VERSION}" 2>/dev/null; then
        print_success "Tag created: ${TAG_NAME}"
        
        read -p "Push tag to remote? (y/n) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if git push origin "$TAG_NAME" 2>/dev/null; then
                print_success "Tag pushed to remote"
            else
                print_warning "Failed to push tag (may need to set remote)"
            fi
        fi
    else
        print_warning "Tag already exists or failed to create"
    fi
    echo ""
fi

# Step 11: Clean up gem file
print_info "Local gem file: ${GEM_FILE}"
read -p "Delete local gem file? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -f "$GEM_FILE"
    print_success "Deleted: ${GEM_FILE}"
else
    print_info "Keeping: ${GEM_FILE}"
fi
echo ""

# Step 12: Success summary
print_success "═══════════════════════════════════════════════════════"
print_success "  RELEASE COMPLETED SUCCESSFULLY! 🎉"
print_success "═══════════════════════════════════════════════════════"
echo ""
print_info "Gem: ${GEM_NAME} v${VERSION}"
print_info "RubyGems: https://rubygems.org/gems/${GEM_NAME}"
print_info "Install: gem install ${GEM_NAME}"
echo ""
print_info "Next steps:"
echo "  1. ✓ Gem published to RubyGems"
echo "  2. → Commit and push any remaining changes"
echo "  3. → Create a GitHub release"
echo "  4. → Announce the release"
echo "  5. → Update documentation if needed"
echo ""
print_success "Great work! 🚀"
echo ""
