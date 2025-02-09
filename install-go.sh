#!/bin/bash

# Exit on errors
set -e

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No color

echo -e "${BLUE}----------------------------------------------${NC}"
echo -e "${BLUE}        Go Environment Setup Script          ${NC}"
echo -e "${BLUE}----------------------------------------------${NC}"
echo

# Function to remove existing Go installation
remove_go() {
    echo
    echo -e "${RED}Removing existing Go installation...${NC}"
    sudo rm -rf /usr/local/go
    read -p "Do you want to remove your Go workspace ($HOME/go)? (yes/no): " confirm
    if [[ "$confirm" =~ ^[Yy] ]]; then
        rm -rf $HOME/go
        echo -e "${GREEN}Go workspace removed.${NC}"
    fi
    sed -i '/export GOPATH=/d' ~/.bashrc
    sed -i '/export PATH=.*go/d' ~/.bashrc
    echo -e "${GREEN}Go has been removed.${NC}"
    echo
}

# Function to configure Go environment
configure_go() {
    echo
    echo -e "${BLUE}Configuring Go environment...${NC}"

    # Define GOPATH explicitly before using it
    GOPATH="$HOME/go"

    # Set environment variables if not already set
    if ! grep -q "export GOPATH=" ~/.bashrc; then
        echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    fi
    if ! grep -q "export PATH=" ~/.bashrc; then
        echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.bashrc
    fi
    if ! grep -q "export GO111MODULE=" ~/.bashrc; then
        echo 'export GO111MODULE=on' >> ~/.bashrc
    fi

    # Create Go workspace directories
    mkdir -p "$GOPATH/bin" "$GOPATH/src" "$GOPATH/pkg"

    echo -e "${GREEN}Go environment configuration is complete.${NC}"
    echo -e "${YELLOW}Please restart your terminal or run: source ~/.bashrc${NC}"
    echo
}

# Check if Go is installed
if command -v go &> /dev/null; then
    echo -e "${YELLOW}Go is already installed.${NC}"
    read -p "Do you want to remove and reinstall it? (yes/no): " choice

    if [[ "$choice" =~ ^[Yy] ]]; then
        remove_go
        install_go=true
    else
        read -p "Do you want to just reconfigure the environment? (yes/no): " reconfig_choice
        if [[ "$reconfig_choice" =~ ^[Yy] ]]; then
            configure_go
            exit 0
        else
            echo -e "${YELLOW}No changes were made.${NC}"
            exit 0
        fi
    fi
else
    install_go=true
fi

# Install Go only if needed
if [[ "$install_go" == true ]]; then
    echo
    echo -e "${BLUE}Downloading and installing Go...${NC}"

    GO_VERSION="1.22.0"
    wget https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
    rm go$GO_VERSION.linux-amd64.tar.gz

    # Always configure after a fresh install
    configure_go
fi

# Verify installation if Go was installed
if [[ "$install_go" == true ]]; then
    echo
    echo -e "${BLUE}Verifying Go installation...${NC}"
    if go version; then
        echo -e "${GREEN}Go installation successful!${NC}"
    else
        echo -e "${RED}Go installation failed.${NC}"
        exit 1
    fi
fi

echo
echo -e "${GREEN}Go setup is complete.${NC}"
echo -e "${YELLOW}Restart your terminal or run 'source ~/.bashrc' to apply changes.${NC}"
echo
