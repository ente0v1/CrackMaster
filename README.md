# Crack_Master
An awareness based Bash script to perform cracking operations with Hashcat. This software is openly inspired by the TV Show "Mr. Robot"

![Test Image](./assets/pennybags.png)
![GitHub](https://img.shields.io/github/license/ente0v1/CrackMaster)


## Disclaimer
This program is provided without warranties of any kind. The author assumes no responsibility for any damages resulting from the use of this software. We recommend that you use it only for lawful purposes and in accordance with local laws.

## Description
This Bash script provides a simple interface to perform cracking operations using Hashcat. It offers various options such as cracking with wordlists, rules, brute-force, and hybrid wordlist + mask attacks. The program is enriched with comments in such a way as to make the code as usable and minimal as possible.

## Features
- Crack passwords using wordlists, rules, or brute-force methods.
- Perform hybrid attacks combining wordlists and masks.
- Easy-to-use menu interface for selecting cracking options.
- Supports session restoration for interrupted cracking sessions.


![Test Image](./assets/menu.png)


## Requirements
- Linux operating system
- Hashcat installed (`sudo apt install hashcat`)
- Wordlists, rules, and masks available in the specified paths

## Usage
1. Clone the repository to your local machine.
2. Go into the repo folder: `cd CrackMaster`
3. Make the script executable: `chmod +x *`
4. Change directory to your hash path: `cd $path`
5. Run the script: `./crackmaster.sh`
6. Follow the on-screen instructions to select the cracking method and provide necessary inputs.


![Test Image](./assets/action.png)
