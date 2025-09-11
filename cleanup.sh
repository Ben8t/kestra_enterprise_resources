#!/bin/bash

# Kestra Environment Cleanup Script
# This script helps clean up Terraform artifacts and Docker volumes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --terraform     Remove Terraform artifacts (.terraform/, terraform.tfstate*, .terraform.lock.hcl)"
    echo "  --docker        Remove Docker volumes (postgres-data, kestra-data)"
    echo "  --all           Remove both Terraform artifacts and Docker volumes"
    echo "  --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 --terraform    # Remove only Terraform artifacts"
    echo "  $0 --docker       # Remove only Docker volumes"
    echo "  $0 --all          # Remove everything"
}

# Function to remove Terraform artifacts
cleanup_terraform() {
    print_status "Cleaning up Terraform artifacts..."
    
    local removed_items=()
    local terraform_dir="terraform"
    
    # Check if terraform directory exists
    if [ ! -d "$terraform_dir" ]; then
        print_warning "Terraform directory not found"
        return 0
    fi
    
    # Remove .terraform directory
    if [ -d "$terraform_dir/.terraform" ]; then
        rm -rf "$terraform_dir/.terraform"
        removed_items+=("$terraform_dir/.terraform/")
    fi
    
    # Remove terraform state files
    for file in terraform.tfstate terraform.tfstate.backup; do
        if [ -f "$terraform_dir/$file" ]; then
            rm -f "$terraform_dir/$file"
            removed_items+=("$terraform_dir/$file")
        fi
    done
    
    # Remove terraform state files with environment suffixes
    for file in "$terraform_dir"/terraform.tfstate.*; do
        if [ -f "$file" ]; then
            rm -f "$file"
            removed_items+=("$file")
        fi
    done
    
    # Remove .terraform.lock.hcl
    if [ -f "$terraform_dir/.terraform.lock.hcl" ]; then
        rm -f "$terraform_dir/.terraform.lock.hcl"
        removed_items+=("$terraform_dir/.terraform.lock.hcl")
    fi
    
    if [ ${#removed_items[@]} -eq 0 ]; then
        print_warning "No Terraform artifacts found to remove"
    else
        print_success "Removed Terraform artifacts:"
        for item in "${removed_items[@]}"; do
            echo "  - $item"
        done
    fi
}

# Function to remove Docker volumes
cleanup_docker() {
    print_status "Cleaning up Docker volumes..."
    
    # Check if docker-compose.yml exists
    if [ ! -f "docker-compose.yml" ]; then
        print_error "docker-compose.yml not found in current directory"
        return 1
    fi
    
    # Stop and remove containers first
    print_status "Stopping and removing containers..."
    docker-compose down --remove-orphans 2>/dev/null || true
    
    # Get the project name (directory name)
    local project_name=$(basename "$(pwd)")
    
    # Remove volumes defined in docker-compose.yml
    # Docker Compose prefixes volumes with project name
    local volumes=("${project_name}_postgres-data" "${project_name}_kestra-data")
    local removed_volumes=()
    
    for volume in "${volumes[@]}"; do
        if docker volume ls -q | grep -q "^${volume}$"; then
            print_status "Removing volume: $volume"
            docker volume rm "$volume" 2>/dev/null || {
                print_warning "Failed to remove volume $volume (might be in use)"
                continue
            }
            removed_volumes+=("$volume")
        else
            print_warning "Volume $volume not found"
        fi
    done
    
    if [ ${#removed_volumes[@]} -eq 0 ]; then
        print_warning "No Docker volumes found to remove"
    else
        print_success "Removed Docker volumes:"
        for volume in "${removed_volumes[@]}"; do
            echo "  - $volume"
        done
    fi
}

# Function to confirm action
confirm_action() {
    local action="$1"
    echo ""
    print_warning "This will $action"
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Operation cancelled"
        exit 0
    fi
}

# Main script logic
main() {
    # Check if no arguments provided
    if [ $# -eq 0 ]; then
        show_usage
        exit 1
    fi
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --terraform)
                TERRAFORM_CLEANUP=true
                shift
                ;;
            --docker)
                DOCKER_CLEANUP=true
                shift
                ;;
            --all)
                TERRAFORM_CLEANUP=true
                DOCKER_CLEANUP=true
                shift
                ;;
            --help)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Execute cleanup operations
    if [ "$TERRAFORM_CLEANUP" = true ] && [ "$DOCKER_CLEANUP" = true ]; then
        confirm_action "remove all Terraform artifacts and Docker volumes"
        cleanup_terraform
        echo ""
        cleanup_docker
    elif [ "$TERRAFORM_CLEANUP" = true ]; then
        confirm_action "remove all Terraform artifacts"
        cleanup_terraform
    elif [ "$DOCKER_CLEANUP" = true ]; then
        confirm_action "remove all Docker volumes"
        cleanup_docker
    fi
    
    echo ""
    print_success "Cleanup completed!"
}

# Run main function with all arguments
main "$@"
