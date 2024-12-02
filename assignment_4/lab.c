#include <stdio.h>
#include <string.h>
#include <openssl/bn.h>

int hex_to_int(char c){
    if (c >= 97)
        c = c - 32;
    int first = c / 16 - 3;
    int second = c % 16;
    int result = first * 10 + second;
    if (result > 9) result--;
    return result;
}

int hex_to_ascii(const char c, const char d){
	int high = hex_to_int(c) * 16;
	int low = hex_to_int(d);
	return high+low;
}

void printHX(const char* st){
	int length = strlen(st);
	if (length % 2 != 0) {
		printf("%s\n", "invalid hex length");
		return;
	}
	int i;
	char buf = 0;
	for(i = 0; i < length; i++) {
		if(i % 2 != 0)
			printf("%c", hex_to_ascii(buf, st[i]));
		else
		    buf = st[i];
	}
	printf("\n");
}

void printBN(char* msg, BIGNUM * a){
    char * number_str = BN_bn2hex(a);
    printf("%s 0x%s\n", msg, number_str);
    OPENSSL_free(number_str);
}

BIGNUM* get_rsa_priv_key(BIGNUM* p, BIGNUM* q, BIGNUM* e){
	BN_CTX *ctx = BN_CTX_new();
	BIGNUM* p_minus_one = BN_new();
	BIGNUM* q_minus_one = BN_new();
	BIGNUM* one = BN_new();
	BIGNUM* tt = BN_new();

	BN_dec2bn(&one, "1");
	BN_sub(p_minus_one, p, one);
	BN_sub(q_minus_one, q, one);
	BN_mul(tt, p_minus_one, q_minus_one, ctx);

	BIGNUM* res = BN_new();
	BN_mod_inverse(res, e, tt, ctx);
	BN_CTX_free(ctx);
	return res;
}

BIGNUM* rsa_encrypt(BIGNUM* message, BIGNUM* mod, BIGNUM* pub_key){
	BN_CTX *ctx = BN_CTX_new();
	BIGNUM* enc = BN_new();
	BN_mod_exp(enc, message, mod, pub_key, ctx);
	BN_CTX_free(ctx);
	return enc;
}

BIGNUM* rsa_decrypt(BIGNUM* enc, BIGNUM* priv_key, BIGNUM* pub_key){
	BN_CTX *ctx = BN_CTX_new();
	BIGNUM* dec = BN_new();
	BN_mod_exp(dec, enc, priv_key, pub_key, ctx);
	BN_CTX_free(ctx);
	return dec;
}

int main (){
	// Task1
	BIGNUM *p = BN_new();
	BIGNUM *q = BN_new();
	BIGNUM *e = BN_new();
	BN_hex2bn(&p, "F7E75FDC469067FFDC4E847C51F452DF");
	BN_hex2bn(&q, "E85CED54AF57E53E092113E62F436F4F");
	BN_hex2bn(&e, "0D88C3");
	BIGNUM* priv_key1 = get_rsa_priv_key(p, q, e);
	printBN("Task 1: ", priv_key1);
	BIGNUM* enc = BN_new();
	BIGNUM* dec = BN_new();
	printf("\n");
	
	//Task 2
	BIGNUM* priv_key = BN_new();
	BN_hex2bn(&priv_key, "74D806F9F3A62BAE331FFE3F0A68AFE35B3D2E4794148AACBC26AA381CD7D30D");
	BIGNUM* pub_key = BN_new();
	BN_hex2bn(&pub_key, "DCBFFE3E51F62E09CE7032E2677A78946A849DC4CDDE3A4D0CB81629242FB1A5");
	BIGNUM* mod = BN_new();
	BN_hex2bn(&mod, "010001");
	BIGNUM* message = BN_new();
	BN_hex2bn(&message, "4120746f702073656372657421");
	enc = rsa_encrypt(message, mod, pub_key);
	printBN("Task 2: ", enc);
	dec = rsa_decrypt(enc, priv_key, pub_key);
	printf("\n");
	
	// Task 3
	BIGNUM* task3_enc = BN_new();
	BN_hex2bn(&task3_enc, "8C0F971DF2F3672B28811407E2DABBE1DA0FEBBBDFC7DCB67396567EA1E2493F");
	dec = rsa_decrypt(task3_enc, priv_key, pub_key);
	printf("Task 3: ");
	printHX(BN_bn2hex(dec));
	printf("\n");

	// Task 4
	BIGNUM* BN_task4 = BN_new();
	BN_hex2bn(&BN_task4, "49206f776520796f75202433303030");
	enc = rsa_encrypt(BN_task4, priv_key, pub_key);
	printBN("Task 4: ", enc);
	dec = rsa_decrypt(enc, mod, pub_key);
	printf("\n");

	// Task 5
	BIGNUM* BN_task5 = BN_new();
	BIGNUM* S = BN_new();
	BN_hex2bn(&BN_task5, "4c61756e63682061206d6973736c652e");
	BN_hex2bn(&pub_key, "AE1CD4DC432798D933779FBD46C6E1247F0CF1233595113AA51B450F18116115");
	BN_hex2bn(&S, "643D6F34902D9C7EC90CB0B2BCA36C47FA37165C0005CAB026C0542CBDB6802F");
	dec = rsa_decrypt(S, mod, pub_key);
	printf("Task 5: ");
	printHX(BN_bn2hex(dec));
	printf("\n");
}
