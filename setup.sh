#!/bin/bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    INSTALL_DIR="/usr/local/bin"
elif [[ -f /etc/debian_version ]] || [[ -f /etc/lsb-release ]]; then
    OS="linux"
    INSTALL_DIR="/usr/local/bin"
else
    echo -e "${RED}Unsupported operating system${NC}"
    exit 1
fi

INSTALLED_SCRIPT="$INSTALL_DIR/plex"

# Check if we need sudo
if [[ ! -w "$INSTALL_DIR" ]]; then
    SUDO="sudo"
else
    SUDO=""
fi

# Function to install
install_plex() {
    echo -e "${BLUE}Plex on the Go - Setup Script${NC}"
    echo "================================"
    echo "Detected OS: $OS"
    echo "Install directory: $INSTALL_DIR"
    echo

    # Get the directory where this script is located
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    SOURCE_SCRIPT="$SCRIPT_DIR/plex"

    # Check if source script exists
    if [[ ! -f "$SOURCE_SCRIPT" ]]; then
        echo -e "${RED}Error: plex script not found at $SOURCE_SCRIPT${NC}"
        exit 1
    fi

    # Check if already installed
    if [[ -f "$INSTALLED_SCRIPT" ]]; then
        echo -e "${YELLOW}Warning: plex is already installed at $INSTALLED_SCRIPT${NC}"
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled."
            exit 0
        fi
    fi

    if [[ ! -w "$INSTALL_DIR" ]]; then
        echo "Administrator privileges required to install to $INSTALL_DIR"
    fi

    # Copy the script
    echo -e "${BLUE}Installing plex script...${NC}"
    $SUDO cp "$SOURCE_SCRIPT" "$INSTALLED_SCRIPT"
    $SUDO chmod +x "$INSTALLED_SCRIPT"

    # Verify installation
    if command -v plex &> /dev/null; then
        echo -e "${GREEN}✓ Installation successful!${NC}"
        echo
        echo "The 'plex' command is now available system-wide."
        echo
        echo "Usage:"
        echo "  plex start   - Start Plex server"
        echo "  plex stop    - Stop Plex server"
        echo "  plex restart - Restart Plex server"
        echo "  plex logs    - View Plex logs"
        echo "  plex status  - Show Plex status"
        echo
        echo "To uninstall, run: ./setup.sh uninstall"
    else
        echo -e "${RED}✗ Installation failed${NC}"
        echo "The plex command is not available in PATH."
        echo "You may need to restart your terminal or add $INSTALL_DIR to your PATH manually."
        exit 1
    fi
}

# Function to uninstall
uninstall_plex() {
    echo -e "${BLUE}Plex on the Go - Uninstall Script${NC}"
    echo "=================================="
    echo

    if [[ ! -f "$INSTALLED_SCRIPT" ]]; then
        echo -e "${YELLOW}plex is not installed at $INSTALLED_SCRIPT${NC}"
        exit 0
    fi

    if [[ ! -w "$INSTALL_DIR" ]]; then
        echo "Administrator privileges required to uninstall from $INSTALL_DIR"
    fi

    echo -e "${RED}Removing plex script...${NC}"
    $SUDO rm "$INSTALLED_SCRIPT"

    if [[ ! -f "$INSTALLED_SCRIPT" ]]; then
        echo -e "${GREEN}✓ Uninstallation successful!${NC}"
        echo "The 'plex' command has been removed from your system."
    else
        echo -e "${RED}✗ Uninstallation failed${NC}"
        exit 1
    fi
}

# Main script logic
case "${1:-install}" in
    install)
        install_plex
        ;;
    uninstall)
        uninstall_plex
        ;;
    *)
        echo "Usage: $0 {install|uninstall}"
        echo
        echo "Commands:"
        echo "  install   - Install the plex script to $INSTALL_DIR (default)"
        echo "  uninstall - Remove the plex script from $INSTALL_DIR"
        exit 1
        ;;
esac
