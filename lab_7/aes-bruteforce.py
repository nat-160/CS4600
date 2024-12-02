#!/usr/bin/env python3
import argparse
parser = argparse.ArgumentParser()
parser.add_argument('wordsList')
parser.add_argument('cipherText')
args = parser.parse_args()
ciphertext = args.cipherText
words_file = args.wordsList

from hashlib import md5
from base64 import b64decode
from base64 import b64encode

from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes
from Crypto.Util.Padding import pad, unpad

class AESCipher:
    def __init__(self, key):
        self.key = key
        self.key = md5(key.encode('utf8')).digest()
    def encrypt(self, data):
        iv = get_random_bytes(AES.block_size)
        self.cipher = AES.new(self.key, AES.MODE_CBC, iv)
        return b64encode(iv + self.cipher.encrypt(pad(data.encode('utf-8'),
            AES.block_size)))
    def decrypt(self, data):
        raw = b64decode(data)
        self.cipher = AES.new(self.key, AES.MODE_CBC, raw[:AES.block_size])
        return unpad(self.cipher.decrypt(raw[AES.block_size:]), AES.block_size)

#with open(cipher_file, 'rb') as f:
#    cte = hexlify(f.read())

with open(words_file, 'r') as f:
    words = f.read().splitlines()

msg = "This is a top secret."

key,deciphertext = "",""
for word in words:
    key = word
    try:
        deciphertext = AESCipher(key).decrypt(ciphertext).decode('utf-8')
        break
    except:
        print("Attempted",word)

while len(key) < 16:
    key = key + "#"
print("Key:",key)
print("Message:",deciphertext)
# if __name__ == '__main__':
#     print('TESTING ENCRYPTION')
#     msg = input('Message...: ')
#     pwd = input('Password..: ')
#     print('Ciphertext:', AESCipher(pwd).encrypt(msg).decode('utf-8'))

#     print('\nTESTING DECRYPTION')
#     cte = input('Ciphertext: ')
#     pwd = input('Password..: ')
#     print('Message...:', AESCipher(pwd).decrypt(cte).decode('utf-8'))
