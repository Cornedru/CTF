#!/bin/bash

# Quick test script to verify CTF environment setup

echo -e "\n\033[1;34m╔════════════════════════════════════════╗\033[0m"
echo -e "\033[1;34m║   SANDEVISTAN CTF - System Check      ║\033[0m"
echo -e "\033[1;34m╚════════════════════════════════════════╝\033[0m\n"

check_tool() {
    if command -v "$1" &> /dev/null; then
        echo -e "  \033[1;32m✓\033[0m $1"
        return 0
    else
        echo -e "  \033[1;31m✗\033[0m $1 \033[0;33m(not installed)\033[0m"
        return 1
    fi
}

check_file() {
    if [ -f "$1" ] || [ -d "$1" ]; then
        echo -e "  \033[1;32m✓\033[0m $2"
        return 0
    else
        echo -e "  \033[1;31m✗\033[0m $2 \033[0;33m(not found)\033[0m"
        return 1
    fi
}

total=0
passed=0

echo -e "\033[1;36m[1] Core Tools\033[0m"
for tool in nmap gobuster dirb sqlmap nikto john hashcat hydra; do
    check_tool "$tool" && ((passed++))
    ((total++))
done

echo -e "\n\033[1;36m[2] Python Tools\033[0m"
for tool in python3 pip3; do
    check_tool "$tool" && ((passed++))
    ((total++))
done

echo -e "\n\033[1;36m[3] Network Tools\033[0m"
for tool in nc netstat curl wget; do
    check_tool "$tool" && ((passed++))
    ((total++))
done

echo -e "\n\033[1;36m[4] Wordlists\033[0m"
check_file "/usr/share/wordlists/rockyou.txt" "rockyou.txt" && ((passed++))
((total++))
check_file "$HOME/tools/SecLists" "SecLists" && ((passed++))
((total++))

echo -e "\n\033[1;36m[5] GitHub Tools\033[0m"
check_file "$HOME/tools/PEASS-ng" "LinPEAS" && ((passed++))
((total++))
check_file "$HOME/tools/PayloadsAllTheThings" "PayloadsAllTheThings" && ((passed++))
((total++))

echo -e "\n\033[1;36m[6] Workspace\033[0m"
check_file "$HOME/ctf_workspace" "CTF Workspace" && ((passed++))
((total++))

echo -e "\n\033[1;36m[7] Scripts\033[0m"
check_file "$(pwd)/sandevistan_ctf_enhanced.sh" "Main Script" && ((passed++))
((total++))

# Results
echo -e "\n\033[1;34m════════════════════════════════════════\033[0m"
percentage=$((passed * 100 / total))

if [ $percentage -ge 90 ]; then
    echo -e "\033[1;32m✓ SYSTEM READY: $passed/$total ($percentage%)\033[0m"
    echo -e "\033[1;32m  You're all set for the CTF!\033[0m"
elif [ $percentage -ge 70 ]; then
    echo -e "\033[1;33m⚠ MOSTLY READY: $passed/$total ($percentage%)\033[0m"
    echo -e "\033[1;33m  Some tools missing, but you can start\033[0m"
else
    echo -e "\033[1;31m✗ NOT READY: $passed/$total ($percentage%)\033[0m"
    echo -e "\033[1;31m  Run setup_ctf_environment.sh first!\033[0m"
fi

echo -e "\033[1;34m════════════════════════════════════════\033[0m\n"

if [ $percentage -lt 90 ]; then
    echo -e "\033[1;33mTo fix:\033[0m"
    echo -e "  ./setup_ctf_environment.sh"
    echo -e "  source ~/.bashrc\n"
fi
