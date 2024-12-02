#!/usr/bin/env python3
import argparse
parser = argparse.ArgumentParser()
parser.add_argument('key')
parser.add_argument('plain')
parser.add_argument('-autokey', action='store_true')
args = parser.parse_args()
key = args.key.upper()
plain = args.plain.upper()

if args.autokey:
    key = key + plain
else:
    while len(key) < len(plain):
        key = key + args.key.upper()

def caesar(char, offset):
    x = ord(char) + ord(offset) - 65
    if x > 90: x = x - 26
    return chr(x)

cipher = ""
for i in range(len(plain)):
    if plain[i].isalpha() and key[i].isalpha():
        cipher = cipher + caesar(plain[i], key[i])
    else:
        cipher = cipher + plain[i]

def dcaesar(char, offset):
    x = ord(char) - ord(offset) + 65
    if x < 65: x = x + 26
    return chr(x)

result = ""
for i in range(len(cipher)):
    if cipher[i].isalpha() and key[i].isalpha():
        result = result + dcaesar(cipher[i], key[i])
    else:
        result = result + cipher[i]

print("Key:   ", key)
print("Plain: ", plain)
print("Cipher:", cipher)
print("Result:", result)
