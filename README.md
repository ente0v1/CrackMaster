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

## Requirements
- Linux operating system
- Hashcat installed (`sudo apt install hashcat`)
- Wordlists, rules, and masks available in the specified paths

## Installation
![Test Image](./assets/menu.png)

To begin, clone the repository using `git clone https://github.com/ente0v1/Crack_Master.git` in your $HOME directory, then navigate into the Crack_Master folder by typing `cd Crack_Master`. After that, make all scripts executable with `chmod +x *`, and proceed to move "hash.hc22000" in your repo root directory. With these steps completed, you're now ready to run the script by executing `./crackmaster.sh`.
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

At the end of the cracking you will see the results inside `logs`, just open `status.txt` in the session folder.

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

## Cracking Methods in-depth
```
- [ Crack Menu ] -

  Option                      | -> Action
 =============================+====================================================================================================
  1. Crack with Wordlist      | -> Execute crack-wordlist script (calls the script located at default_scripts/crack-wordlist)
  2. Crack with Rules | MD5   | -> Execute crack-rule script (calls the script located at default_scripts/crack-rule)
  3 (Crack with Brute-Force)  | -> Execute crack-bruteforce script (calls the script located at default_scripts/crack-bruteforce)
  4 (Crack with Combo)        | -> Execute crack-combo script (calls the script located at default_scripts/crack-combo)
  Q (Quit)                    | -> Save Successful Settings -> Save Logs -> Exit
  Invalid Option              | -> Display Invalid Option Message -> Show Menu again
```

**crack-bruteforce**

1. Brute-Force Attack:

- This script handles cracking passwords using a brute-force approach.
- Brute-force attempts all possible combinations of characters within a specified length range.

2. User Prompts and Inputs:

Similar to the previous code section, the script prompts the user for various inputs:
- Restore file name (optional)
- Session name (defaults to $default_session)
- Mask (used for defining character sets in the brute-force attack)
- Whether to use a status timer (prompts for "y" or "n")
- Minimum password length (defaults to $default_min_length)
- Maximum password length (defaults to $default_max_length)

3. Hashcat Command Construction:

The script constructs the hashcat command with some key differences:
- -a 3: Sets the attack mode to brute-force (mode 3)
- The wordlist option is no longer used as brute-force doesn't rely on pre-defined wordlists.
- The mask ("$mask") becomes the main input for generating password variations.

4. Conditional Hashcat Execution:

- The script checks the user's choice for a status timer.
  - If "y", it executes hashcat with --status --status-timer=2 options.
  - Otherwise, it executes hashcat without the status timer.

5. Saving Results:

- The script calls save_settings to store details about the successful cracking session (session name, mask, etc.). Notice how wordlist and wordlist path are not saved as they weren't used.
- It calls save_logs to organize and store session data and logs.
Overall, this code snippet demonstrates how the script facilitates brute-force password cracking by trying all possible combinations of characters within a defined length range.

**crack-combo**

1. Hybrid Wordlist + Mask Cracking:

- This script specifically handles cracking with a combination of a wordlist and a mask.
- The mask allows generating variations of words from the wordlist using placeholders like ?a?a?a? which represent characters.

2. User Prompts and Inputs:

- The script retrieves available sessions for potential restoration.
- It prompts the user for various inputs:
  - Restore file name (optional)
  - Session name (defaults to $default_session)
  - Wordlist path (defaults to $default_wordlists)
  - Wordlist name (defaults to $default_wordlist)
  - Mask (defaults to $default_mask)
  - Whether to use a status timer (prompts for "y" or "n")
  - Minimum password length (defaults to $default_min_length)
  - Maximum password length (defaults to $default_max_length)
  
3. Hashcat Command Construction:
  
The script constructs the hashcat command based on user inputs and default values.
Here's a breakdown of the important options:
- --session="$session": Creates or resumes a session named $session
- --increment --increment-min="$min_length" --increment-max="$max_length": Enables password length incrementing within the specified range.
- -m 22000: Specifies the hash mode (likely for a specific hash type)
- hash.hc22000: Path to the hash file containing the password hash
- -a 6: Sets the attack mode to hybrid wordlist + mask (mode 6)
- -w 4: Uses wordlists for the attack
- --outfile-format=2: Specifies output format for cracked passwords
- -o plaintext.txt: Output file for cracked passwords
- "wordlist_path/$wordlist": Path to the chosen wordlist
- "mask": The mask string to generate password variations

4. Conditional Hashcat Execution:

- The script checks the user's choice for a status timer:
  - If "y", it executes hashcat with --status --status-timer=2 options, providing real-time status updates every 2 seconds.
  - Otherwise, it executes hashcat without the status timer.

5. Saving Results:

- The script calls save_settings to store details about the successful cracking session (session name, wordlist path, wordlist name, mask, etc.).
- It calls save_logs to organize and store session data and logs.
Overall, this code snippet demonstrates how the script facilitates cracking password hashes using a combination of a wordlist and a mask, allowing for more flexibility in password guessing.

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
If you desire to get more resources take a look at:
  [wpa2-wordlists](https://github.com/kennyn510/wpa2-wordlists.git), [paroleitaliane](https://github.com/napolux/paroleitaliane), [SecLists](https://github.com/danielmiessler/SecLists), [hashcat-rules](https://github.com/Unic0rn28/hashcat-rules)
  
  Also if you want more information about how hashcat's attack methods work, I recommend reading the official [Hashcat Wiki](https://hashcat.net/wiki/), the [Radiotap introduction](https://www.radiotap.org/) and [airdump-ng guide](https://wiki.aircrack-ng.org/doku.php?id=airodump-ng).
