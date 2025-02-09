#!/bin/bash
# Exit on errors
set -e

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No color

# Default wordlist directory
DEFAULT_DIR="/usr/share/wordlists"

# Welcome Banner
echo -e "${BLUE}----------------------------------------------${NC}"
echo -e "${BLUE}        Ultimate Wordlist Setup Script       ${NC}"
echo -e "${BLUE}----------------------------------------------${NC}"
echo

# Ask user for storage directory
read -p "Enter directory to store wordlists (default: $DEFAULT_DIR): " WORDLIST_DIR
WORDLIST_DIR=${WORDLIST_DIR:-$DEFAULT_DIR}

# Create the directory if it doesn't exist
if [[ ! -d "$WORDLIST_DIR" ]]; then
    echo -e "${YELLOW}Creating directory: $WORDLIST_DIR${NC}"
    sudo mkdir -p "$WORDLIST_DIR"
    sudo chmod -R 755 "$WORDLIST_DIR"
fi

echo -e "${GREEN}Wordlists will be stored in: $WORDLIST_DIR${NC}"
echo

# Function to download wordlists
download_wordlist() {
    local url=$1
    local filename=$2
    local filepath="$WORDLIST_DIR/$filename"

    if [[ -f "$filepath" ]]; then
        read -p "${YELLOW}$filename already exists. Do you want to update it? (yes/no): ${NC}" choice
        if [[ ! "$choice" =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Skipping $filename${NC}"
            return
        fi
    fi

    echo -e "${BLUE}Downloading: $filename${NC}"
    wget -q --show-progress -O "$filepath" "$url"
    echo -e "${GREEN}Saved: $filepath${NC}"
}

# Check if wget and git are installed
if ! command -v wget &> /dev/null; then
    echo -e "${RED}wget is not installed. Please install it manually.${NC}"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo -e "${RED}git is not installed. Please install it manually.${NC}"
    exit 1
fi

# Selection Menu
echo -e "${YELLOW}Select which wordlists to install:${NC}"
echo -e "1. SecLists (Comprehensive collection)"
echo -e "2. FuzzDB (Fuzzing payloads & bypasses)"
echo -e "3. CrackStation (Massive password database)"
echo -e "4. Assetnote 2M Subdomains"
echo -e "5. All of the above (FULL SETUP)"
read -p "Enter your choice (1-7): " choice

case $choice in
    1)
        echo -e "${BLUE}Installing SecLists...${NC}"
        git clone https://github.com/danielmiessler/SecLists.git "$WORDLIST_DIR/SecLists"
        ;;
    2)
        echo -e "${BLUE}Installing FuzzDB...${NC}"
        git clone https://github.com/fuzzdb-project/fuzzdb.git "$WORDLIST_DIR/fuzzdb"
        ;;
    3)
        echo -e "${BLUE}Downloading CrackStation wordlist...${NC}"
        download_wordlist "https://crackstation.net/files/crackstation.txt.gz" "crackstation.txt.gz"
        gunzip -f "$WORDLIST_DIR/crackstation.txt.gz"
        ;;
    4)
        echo -e "${BLUE}Downloading Assetnote 2M Subdomains...${NC}"
        download_wordlist "https://wordlists-cdn.assetnote.io/data/automated/httparchive_subdomains_2024_05_28.txt" "2m-subdomains.txt"
        ;;
    5)
        echo -e "${BLUE}Installing EVERYTHING...${NC}"
        git clone https://github.com/danielmiessler/SecLists.git "$WORDLIST_DIR/SecLists"
        git clone https://github.com/fuzzdb-project/fuzzdb.git "$WORDLIST_DIR/fuzzdb"
        download_wordlist "https://crackstation.net/files/crackstation.txt.gz" "crackstation.txt.gz"
        gunzip -f "$WORDLIST_DIR/crackstation.txt.gz"
        download_wordlist "https://wordlists.assetnote.io/data/manual/2m-subdomains.txt" "2m-subdomains.txt"
        ;;
    *)
        echo -e "${RED}Invalid choice! Exiting...${NC}"
        exit 1
        ;;
esac

# Creating a symbolic link for easy access
if [[ ! -L "$HOME/wordlists" ]]; then
    echo -e "${BLUE}Creating a symbolic link at ~/wordlists for easy access...${NC}"
    ln -s "$WORDLIST_DIR" "$HOME/wordlists"
elif [[ "$(readlink -f "$HOME/wordlists")" != "$(readlink -f "$WORDLIST_DIR")" ]]; then
    echo -e "${YELLOW}Symbolic link ~/wordlists already exists but points to a different directory.${NC}"
    echo -e "${YELLOW}You might want to remove it and create a new one.${NC}"
fi

echo -e "${GREEN}Wordlist setup complete!${NC}"
echo -e "${YELLOW}Wordlists are stored in: $WORDLIST_DIR${NC}"
echo -e "${YELLOW}You can access them using: cd ~/wordlists${NC}"
echo
