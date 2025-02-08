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
echo -e "${BLUE}        Recon Tools Setup Script             ${NC}"
echo -e "${BLUE}----------------------------------------------${NC}"
echo

# Function to install a tool
install_tool() {
    local tool_name=$1
    local install_cmd=$2

    if command -v $tool_name &> /dev/null; then
        echo -e "${YELLOW}$tool_name is already installed.${NC}"
        read -p "Do you want to reinstall $tool_name? (yes/no): " choice
        if [[ "$choice" =~ ^[Yy] ]]; then
            echo -e "${RED}Reinstalling $tool_name...${NC}"
            eval "$install_cmd"
            echo -e "${GREEN}$tool_name installation complete.${NC}"
        else
            echo -e "${YELLOW}Skipping $tool_name.${NC}"
        fi
    else
        echo -e "${BLUE}Installing $tool_name...${NC}"
        eval "$install_cmd"
        echo -e "${GREEN}$tool_name installation complete.${NC}"
    fi
}

# Update system and install dependencies
echo
echo -e "${BLUE}Updating system and installing dependencies...${NC}"
sudo apt update -y
sudo apt install -y curl wget git unzip jq build-essential libssl-dev

# Install recon tools
install_tool "amass" "go install -v github.com/owasp-amass/amass/v4/...@master"
install_tool "subfinder" "go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
install_tool "assetfinder" "go install -v github.com/tomnomnom/assetfinder@latest"
install_tool "httpx" "go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest"
install_tool "nuclei" "go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"
install_tool "dnsx" "go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
install_tool "waybackurls" "go install -v github.com/tomnomnom/waybackurls@latest"
install_tool "gau" "go install -v github.com/lc/gau/v2/cmd/gau@latest"
install_tool "katana" "go install -v github.com/projectdiscovery/katana/cmd/katana@latest"
install_tool "gf" "go install -v github.com/tomnomnom/gf@latest"
install_tool "gobuster" "go install github.com/OJ/gobuster/v3@latest"
install_tool "nmap" "sudo apt install -y nmap"
# Installing additional tools
install_tool "findomain" "wget https://github.com/Findomain/Findomain/releases/latest/download/findomain-linux && chmod +x findomain-linux && sudo mv findomain-linux /usr/local/bin/findomain"
install_tool "ffuf" "go install -v github.com/ffuf/ffuf@latest"
install_tool "hakrawler" "go install -v github.com/hakluke/hakrawler@latest"

# Install masscan
if ! command -v masscan &> /dev/null; then
    echo -e "${BLUE}Installing Masscan...${NC}"
    sudo apt install -y masscan
    echo -e "${GREEN}Masscan installation complete.${NC}"
fi

# Install nuclei templates
echo
echo -e "${BLUE}Updating Nuclei templates...${NC}"
nuclei -update-templates
echo -e "${GREEN}Nuclei templates updated.${NC}"

# Verify installation of key tools
echo
echo -e "${BLUE}Verifying installations...${NC}"
for tool in amass subfinder assetfinder httpx nuclei dnsx waybackurls gau katana gf gobuster nmap findomain ffuf hakrawler masscan; do
    if command -v $tool &> /dev/null; then
        echo -e "${GREEN}$tool is installed.${NC}"
    else
        echo -e "${RED}$tool is NOT installed.${NC}"
    fi
done

echo
echo -e "${GREEN}Recon tools setup is complete!${NC}"
echo -e "${YELLOW}Restart your terminal or run 'source ~/.bashrc' to apply changes.${NC}"
echo
