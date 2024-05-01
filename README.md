# Crack_Master
An awareness based Bash script to perform cracking operations with Hashcat. This software is openly inspired by the TV Show "Mr. Robot".

![Test Image](./assets/pennybags.png)
![GitHub](https://img.shields.io/github/license/ente0v1/CrackMaster)


## Disclaimer
This program is provided without warranties of any kind. The author assumes no responsibility for any damages resulting from the use of this software. We recommend that you use it only for lawful purposes and in accordance with local laws.

## Description
This Bash script provides a simple interface to perform cracking operations using Hashcat. It offers various options such as cracking with wordlists, rules, brute-force, and hybrid wordlist + mask attacks. The program is enriched with comments in order to make it as usable and minimal as possible.

## Features
- Crack passwords using wordlists, rules, or brute-force methods.
- Perform hybrid attacks combining wordlists and masks.
- Easy-to-use menu interface for selecting cracking options.
- Supports session restoration for interrupted cracking sessions.

## Attacks
```
- [ Attack Modes ] -

  # | Mode
 ===+======
  0 | Straight
  1 | Combination
  3 | Brute-force
  6 | Hybrid Wordlist + Mask
  7 | Hybrid Mask + Wordlist
  9 | Association

- [ Basic Examples ] -

  Attack-          | Hash- |
  Mode             | Type  | Example command
 ==================+=======+==================================================================
  Wordlist         | $P$   | hashcat -a 0 -m 400 example400.hash example.dict
  Wordlist + Rules | MD5   | hashcat -a 0 -m 0 example0.hash example.dict -r rules/best64.rule
  Brute-Force      | MD5   | hashcat -a 3 -m 0 example0.hash ?a?a?a?a?a?a
  Combinator       | MD5   | hashcat -a 1 -m 0 example0.hash example.dict example.dict
  Association      | $1$   | hashcat -a 9 -m 500 example500.hash 1word.dict -r rules/best64.rule

```
from [Hashcat Wiki](https://hashcat.net/wiki/doku.php?id=hashcat)
  
![Test Image](./assets/menu.png)


## Requirements
- Linux operating system
- Hashcat installed (`sudo apt install hashcat`)
- Wordlists, rules, and masks available in the specified paths

## Installation
To begin, clone the repository using `git clone https://github.com/ente0v1/Crack_Master.git` in your $HOME directory, then navigate into the CrackMaster folder by typing `cd Crack_Master`. After that, make all scripts executable with `chmod +x *`, and proceed to move "hash.hc22000" in your repo root directory. With these steps completed, you're now ready to run the script by executing `./crackmaster.sh`.
Execution:
```
git clone https://github.com/ente0v1/Crack_Master.git
mv Crack_Master $HOME
cd $HOME/Crack_Master
chmod +x *
```

If you prefer to use wordlists and other custom parameters, in files suffixed with `crack*` on line 7, replace `define_default_parameters` with `define_my_parameters` and go change variables in function "define_my_parameters" in `functions.sh`.

## Usage
To start the script log in as non-root user and rename your hash in "hash.hc22000", move your hash into Crack_Master directory and execute: `./crackmaster.sh`

![Test Image](./assets/action.png)

## Useful one-liners for wordlist manipulation (from [wpa2-wordlists](https://github.com/kennyn510/wpa2-wordlists.git))
**Remove duplicates**
```
awk '!(count[$0]++)' old.txt > new.txt
```
**Sort by length**
```
awk '{print length, $0}' old.txt | sort -n | cut -d " " -f2- > new.txt
```

**Sort by alphabetical order**
```
sort old.txt | uniq > new.txt
```
**Merge multiple text files into one**
```
cat file1.txt file2.txt > combined.txt
```

**Remove all blank lines**
```
egrep -v "^[[:space:]]*$" old.txt > new.txt
```
## Help
If you desire to get more wordlists and resources look at [wpa2-wordlists](https://github.com/kennyn510/wpa2-wordlists.git) repo. Also if you want more information about how hashcat's attack methods work, I recommend reading the official [Hashcat Wiki](https://hashcat.net/wiki/).
