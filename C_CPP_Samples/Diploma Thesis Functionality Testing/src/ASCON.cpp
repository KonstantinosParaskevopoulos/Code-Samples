#include <stdio.h>
#include <fstream>
#include <bitset>
#include <iostream>
#include <stdexcept>
using namespace std;

typedef unsigned __int64 bit64;

bit64 state[5] = { 0 }, t[5] = { 0 };
bit64 constants[16] = {0xf0, 0xe1, 0xd2, 0xc3, 0xb4, 0xa5, 0x96, 0x87, 0x78, 0x69, 0x5a, 0x4b, 0x3c, 0x2d, 0x1e, 0x0f};

bit64 print_state(bit64 state[5]){
   for(int i = 0; i < 5; i++){
      printf("%016I64x\n", state[i]);
   } 
}

bit64 rotate(bit64 x, int l) {
   bit64 temp;
   temp = (x >> l) ^ (x << (64 - l));
   return temp;
}

void add_constant(bit64 state[5], int i, int a) {
   state[2] = state[2] ^ constants[12 - a + i];
}
void sbox(bit64 x[5]) {
   x[0] ^= x[4]; x[4] ^= x[3]; x[2] ^= x[1];
   t[0] = x[0]; t[1] = x[1]; t[2] = x[2]; t[3] = x[3]; t[4] = x[4];
   t[0] =~ t[0]; t[1] =~ t[1]; t[2] =~ t[2]; t[3] =~ t[3]; t[4] =~ t[4];
   t[0] &= x[1]; t[1] &= x[2]; t[2] &= x[3]; t[3] &= x[4]; t[4] &= x[0];
   x[0] ^= t[1]; x[1] ^= t[2]; x[2] ^= t[3]; x[3] ^= t[4]; x[4] ^= t[0];
   x[1] ^= x[0]; x[0] ^= x[4]; x[3] ^= x[2]; x[2] =~ x[2];
}
void linear(bit64 state[5]) {
   bit64 temp0, temp1;
   temp0 = rotate(state[0], 19);
   temp1 = rotate(state[0], 28);
   state[0] ^= temp0 ^ temp1;
   temp0 = rotate(state[1], 61);
   temp1 = rotate(state[1], 39);
   state[1] ^= temp0 ^ temp1;
   temp0 = rotate(state[2], 1);
   temp1 = rotate(state[2], 6);
   state[2] ^= temp0 ^ temp1;
   temp0 = rotate(state[3], 10);
   temp1 = rotate(state[3], 17);
   state[3] ^= temp0 ^ temp1;
   temp0 = rotate(state[4], 7);
   temp1 = rotate(state[4], 41);
   state[4] ^= temp0 ^ temp1;
}

void p(bit64 state[5], int a){
   for (int i = 0; i < a; i++){
      add_constant(state, i, a);
      sbox(state);
      linear(state);
   }
}

void initialization(bit64 state[5], bit64 key[2]) {
   p(state, 12);
   state[3] ^= key[0];
   state[4] ^= key[1];
}

void associated_data(bit64 state[5], int length, bit64 associated_data_text[]) {
   for (int i = 0; i < length; i++){
      state[0] = associated_data_text[i] ^ state[0];
      p(state, 6);
      //printf("A_Data Round %d\n", i);
      //print_state(state);
      //printf("----------------------------\n");
   }
   //printf("Before: %016I64x\n", state[4]);
   state[4] = state[4] ^ 0x0000000000000001;
   //printf("After: %016I64x\n", state[4]);
   //printf("A_Data Round After XOR\n");
      //print_state(state);
      //printf("----------------------------\n");
}

void finalization(bit64 state[5], bit64 key[2]) {
   state[1] ^= key[0];
   state[2] ^= key[1];
   p(state, 12);
   state[3] ^= key[0];
   state[4] ^= key[1];

}

void encrypt(bit64 state[5], int length, bit64 plaintext[], bit64 ciphertext[]) {
   ciphertext[0] = plaintext[0] ^ state[0];
   state[0] = ciphertext[0];
   //printf("----------------------------\n");
   //printf("Round 0\n");
   //print_state(state);
   //printf("----------------------------\n");
   for (int i = 1; i < length; i++){
      p(state, 6);
      ciphertext[i] = plaintext[i] ^ state[0];
      state[0] = ciphertext[i];
      //printf("Round %d\n", i);
      //print_state(state);
      //printf("----------------------------\n");
   }
}

void decrypt(bit64 state[5], int length, bit64 plaintext[], bit64 ciphertext[]){
   plaintext[0] = ciphertext[0] ^ state[0];
   state[0] = ciphertext[0];
   for (int i = 1; i < length; i++){
      p(state, 6);
      plaintext[i] = ciphertext[i] ^ state[0];
      state[0] = ciphertext[i];
   }
}

////////////////////////////////////////////////////////////////////////////////////////////
void ReadValuesfromFiles (ifstream &fin0, ifstream &fin1, ifstream &fin2, ifstream &fin3, ifstream &fin4, bit64 input_arr[], bit64 enc_arr[], bit64 dec_arr[], bit64 key_nonce_arr[], bit64 data_arr[])
{
	int i = 0;
	int j = 0;
	int k = 0;
	int l = 0;
	int m = 0;
	
	int error = 0;
	if (fin0.good())//Reading Input Values
    {
	while(fin0 >> hex >> input_arr[i])
    {
		//cout<<hex<<"input_arr: "<<input_arr[i]<<endl;		
		i++;	
    }
	fin0.close();
	}
	else
	{
		cout<<"File Corrupted or doesn't Exist!"<<endl;
	}
	
	if (fin1.good())//Reading Encoding Result -> ciphertxt from Hardware
    {
	while(fin1 >> hex >> enc_arr[j])
    {
		//cout<<hex<<"enc_arr: "<<enc_arr[j]<<endl;		
		j++;	
    }
	fin1.close();
	}
	else
	{
		cout<<"File Corrupted or doesn't Exist!"<<endl;
	}
	
	if (fin2.good())//Reading Decoding result < dec(enc(x)) > must be the same as input_arr
    {
	while(fin2 >> hex >> dec_arr[k])
    {
		if(dec_arr[k]!=input_arr[k]){
			error++;
		}
		//cout<<hex<<"dec_arr: "<<dec_arr[k]<<endl;		
		k++;	
    }
	fin2.close();
	}
	else
	{
		cout<<"File Corrupted or doesn't Exist!"<<endl;
	}
	if(error>0){ cout<<"Error! Dec(Enc(x)) is NOT the same as the Input\nNumber of Errors: "<<error<<"\n----------------------------------------------------------------\n\n"<<endl; }
	else { cout<<"No Errors Dec(Enc(x)) is THE same as the Input\nNumber of Errors: "<<error<<"\n----------------------------------------------------------------\n\n"<<endl; }
	
	if (fin3.good())
    {
	while(fin3 >> hex >> key_nonce_arr[l])
    {
		//cout<<hex<<"key_nonce_arr: "<<key_nonce_arr[l]<<endl;		
		l++;	
    }
	fin3.close();
	}
	else
	{
		cout<<"File Corrupted or doesn't Exist!"<<endl;
	}
	
	if (fin4.good())
    {
	while(fin4 >> hex >> data_arr[m])
    {
		//cout<<hex<<"data_arr: "<<data_arr[m]<<endl;		
		m++;	
    }
	fin4.close();
	}
	else
	{
		cout<<"File Corrupted or doesn't Exist!"<<endl;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////
int main() {
	int encrypt_errors = 0;
	ifstream infile0("ASCON_Data_MemFiles/ASCON_128/Encode_input.txt");
	ifstream infile1("ASCON_Data_MemFiles/ASCON_128/Encode_output_LP.txt");
	ifstream infile2("ASCON_Data_MemFiles/ASCON_128/Decode_output_LP.txt");
	ifstream infile3("ASCON_Data_MemFiles/ASCON_128/Key_Nonce.txt");
	ifstream infile4("ASCON_Data_MemFiles/ASCON_128/Assoc_Data.txt");
	bit64 input_arr[4];
	bit64 enc_arr[4];
	bit64 dec_arr[4];
	bit64 key_nonce_arr[4];
	bit64 data_arr[3];
	   
	
	cout<<"Reading Files...\n\n"<<endl;
    ReadValuesfromFiles (infile0, infile1, infile2, infile3, infile4, input_arr, enc_arr, dec_arr, key_nonce_arr, data_arr);
    cout<<"End"<<endl;
   
   // initialize nonce, key and IV
   bit64 nonce[2] = { key_nonce_arr[2], key_nonce_arr[3] };
   bit64 key[2] = {  key_nonce_arr[0], key_nonce_arr[1] };
   bit64 IV = 0x80400c0600000000;
   bit64 plaintext[] = {input_arr[0], input_arr[1], input_arr[2], input_arr[3]};

   bit64 ciphertext[4] = { 0 };
   bit64 associated_data_text[] = { data_arr[0], data_arr[1], data_arr[2]};
   
   //encryption
   //initialize state
   state[0] = IV;
   state[1] = key[0];
   state[2] = key[1];
   state[3] = nonce[0];
   state[4] = nonce[1];
   initialization(state,key);
   associated_data(state, 3, associated_data_text);
   //print_state(state);
   encrypt(state, 4, plaintext, ciphertext);
   printf("\nciphertext: %016I64x %016I64x %016I64x %016I64x\n", ciphertext[0], ciphertext[1], ciphertext[2], ciphertext[3]);
   finalization(state, key);
   printf("tag: %016I64x %016I64x\n", state[3], state[4]);

   printf("-------------------------------------------------------------------------------\n");
	
   for(int i =0; i < 4; i++){
   		if(enc_arr[i]!=ciphertext[i]){
   			encrypt_errors++;
		}
   }
   if(encrypt_errors>0){ cout<<"Error! Hardware_Enc(x) is NOT the same as Software_Enc(x) \nNumber of Errors: "<<encrypt_errors<<"\n----------------------------------------------------------------\n\n"<<endl; }
   else{ cout<<"Hardware_Enc(x) is THE same as Software_Enc(x) \nNumber of Errors: "<<encrypt_errors<<"\n----------------------------------------------------------------\n\n"<<endl; }
   //decryption
        
   bit64 ciphertextdecrypt[4] = {0};
   for(int i = 0; i < 4; i++){
      ciphertextdecrypt[i] = ciphertext[i];
   }
   bit64 plaintextdecrypt[10] = { 0 };

   //initialize state
   state[0] = IV;
   state[1] = key[0];
   state[2] = key[1];
   state[3] = nonce[0];
   state[4] = nonce[1];

   initialization(state,key);
   //print_state(state);
   associated_data(state, 3, associated_data_text);
   decrypt(state, 4, plaintextdecrypt, ciphertextdecrypt);
   printf("\nplaintext: %016I64x %016I64x %016I64x %016I64x\n", plaintextdecrypt[0], plaintextdecrypt[1], plaintextdecrypt[2], plaintextdecrypt[3]);
   finalization(state, key);
   printf("tag: %016I64x %016I64x\n", state[3], state[4]);
      system("PAUSE");
}
