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
    sudo wget -q --show-progress -O "$filepath" "$url"
    echo -e "${GREEN}Saved: $filepath${NC}"
}

# Selection Menu
echo -e "${YELLOW}Select which wordlists to install:${NC}"
echo -e "1. SecLists (Comprehensive collection)"
echo -e "2. FuzzDB (Fuzzing payloads & bypasses)"
echo -e "3. RockYou (Huge password list)"
echo -e "4. All of the above (FULL SETUP)"
echo -e "5. Custom Selection"
read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        echo -e "${BLUE}Installing SecLists...${NC}"
        sudo apt install -y seclists
        ;;
    2)
        echo -e "${BLUE}Installing FuzzDB...${NC}"
        git clone https://github.com/fuzzdb-project/fuzzdb.git "$WORDLIST_DIR/fuzzdb"
        ;;
    3)
        echo -e "${BLUE}Downloading RockYou...${NC}"
        sudo apt install -y wordlists
        sudo gunzip -k /usr/share/wordlists/rockyou.txt.gz
        sudo cp /usr/share/wordlists/rockyou.txt "$WORDLIST_DIR/rockyou.txt"
        ;;
    4)
        echo -e "${BLUE}Installing EVERYTHING...${NC}"
        sudo apt install -y seclists wordlists
        sudo gunzip -k /usr/share/wordlists/rockyou.txt.gz
        sudo cp /usr/share/wordlists/rockyou.txt "$WORDLIST_DIR/rockyou.txt"
        git clone https://github.com/fuzzdb-project/fuzzdb.git "$WORDLIST_DIR/fuzzdb"
        ;;
    5)
        echo -e "${BLUE}Custom selection! Let's go!${NC}"
        read -p "Do you want SecLists? (yes/no): " seclists_choice
        if [[ "$seclists_choice" =~ ^[Yy]$ ]]; then
            sudo apt install -y seclists
        fi

        read -p "Do you want FuzzDB? (yes/no): " fuzzdb_choice
        if [[ "$fuzzdb_choice" =~ ^[Yy]$ ]]; then
            git clone https://github.com/fuzzdb-project/fuzzdb.git "$WORDLIST_DIR/fuzzdb"
        fi

        read -p "Do you want RockYou? (yes/no): " rockyou_choice
        if [[ "$rockyou_choice" =~ ^[Yy]$ ]]; then
            sudo apt install -y wordlists
            sudo gunzip -k /usr/share/wordlists/rockyou.txt.gz
            sudo cp /usr/share/wordlists/rockyou.txt "$WORDLIST_DIR/rockyou.txt"
        fi
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
fi

echo -e "${GREEN}Wordlist setup complete!${NC}"
echo -e "${YELLOW}Wordlists are stored in: $WORDLIST_DIR${NC}"
echo -e "${YELLOW}You can access them using: cd ~/wordlists${NC}"
echo
