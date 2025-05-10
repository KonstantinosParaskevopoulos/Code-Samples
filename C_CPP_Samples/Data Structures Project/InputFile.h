#ifndef _INPUTFILE_H
#define _INPUTFILE_H

#include<iostream>
#include<fstream>
#define AGN_SIZE 3239
#define AINV_SIZE 3201
#define ALE_SIZE 3201
#define TEST_SIZE 7
using namespace std;

/*
Dhmiourgia struct metoxhs me ola ta paidia pou periexontai se kathe grammh twn arxeiwn
*/

int getDatefromKeyboard(){
	int y = 0;
	int m = 0;
	int d = 0;
	int fulldate;
	start: cout<<"Give Wanted Date (With Spaces or Not between the numbers)\nFormat(yyyy mm dd) ";
	
	cout<<"Date: ";
	
	cin>>y;
 if(y>3000){
		fulldate = y;
	}
	else{
	cin>>m>>d;
	
	fulldate = 10000*y+100*m+d;
}	
	if (fulldate>30000000){
		goto start;
	}
	return fulldate;
}



struct metoxh{
	long int Date;
	float Open;
	float High;
	float Low;
	long int Volume;
	float OpenInt;
	float Close;
	//Date,Open,High,Low,Close,Volume,OpenInt
	
};

void StructAssignTo(struct metoxh &s1, struct metoxh &s2){ //StructAssignTo(s1[i], R[n])---->R[n]=s1[i] ,,,,,,,,,,,,,,,,,,,,,,s2=s1     
	s2.Date=s1.Date;
	s2.Open=s1.Open;
	s2.High=s1.High;
	s2.Low=s1.Low;
	s2.OpenInt=s1.OpenInt;
	s2.Volume=s1.Volume;
	s2.Close=s1.Close;
}

/*
ReadValuesfromFile(ifstream &fin, struct metoxh testarray) 
;****************************************************************************************************;
1o orisma arxeio typou ifstream p.x. ifstream finput("agn.us.txt"); opou finput mpainei ws orisma kai 
2o orisma typou pinaka apo structs typou "metoxh"
*/

void ReadValuesfromFile(ifstream &fin, struct metoxh StocksArray[]){
	int i=0;
	if (fin.good()){
	
	while(fin >> StocksArray[i].Date >> StocksArray[i].Open >> StocksArray[i].High >> StocksArray[i].Low >> StocksArray[i].Close >> StocksArray[i].Volume >> StocksArray[i].OpenInt){
		//cout <<"Date: "<< StocksArray[i].Date <<" Open: "<< StocksArray[i].Open <<" High: "<< StocksArray[i].High <<" Low: "<< StocksArray[i].Low <<" Close: "<< StocksArray[i].Close <<" Volume: "<< StocksArray[i].Volume <<" OpenInt: "<< StocksArray[i].OpenInt<<endl;
		//emfanish sto terminal olwn twn periexomenwn tou kathe pinaka
		
		i++;
		}
		
		//cout<<"\n\nLast input: "<<i;   
		//Ean thelete na deite to megethos twn pinakwn vgalte apo ta sxolia thn grammh kwdika apo panw
		
	fin.close();
	}
	else{
		cout<<"File Corrupted or doesn't Exist!"<<endl;
	}
}

void PrintValuesfromFile(ifstream &fin, struct metoxh StocksArray[]){
	int i=0;
	if (fin.good()){
	
	while(fin >> StocksArray[i].Date >> StocksArray[i].Open >> StocksArray[i].High >> StocksArray[i].Low >> StocksArray[i].Close >> StocksArray[i].Volume >> StocksArray[i].OpenInt){
		cout <<"Date: "<< StocksArray[i].Date <<" Open: "<< StocksArray[i].Open <<" High: "<< StocksArray[i].High <<" Low: "<< StocksArray[i].Low <<" Close: "<< StocksArray[i].Close <<" Volume: "<< StocksArray[i].Volume <<" OpenInt: "<< StocksArray[i].OpenInt<<endl;
		//emfanish sto terminal olwn twn periexomenwn tou kathe pinaka
		
		i++;
		}
		
		//cout<<"\n\nLast input: "<<i;   
		//Ean thelete na deite to megethos twn pinakwn vgalte apo ta sxolia thn grammh kwdika apo panw
		
	fin.close();
	}
	else{
		cout<<"File Corrupted or doesn't Exist!"<<endl;
	}
}

int CountValuesfromFile(ifstream &fin, struct metoxh StocksArray[]){
	int i=0;
	if (fin.good()){
	
	while(fin >> StocksArray[i].Date >> StocksArray[i].Open >> StocksArray[i].High >> StocksArray[i].Low >> StocksArray[i].Close >> StocksArray[i].Volume >> StocksArray[i].OpenInt){
		//cout <<"Date: "<< StocksArray[i].Date <<" Open: "<< StocksArray[i].Open <<" High: "<< StocksArray[i].High <<" Low: "<< StocksArray[i].Low <<" Close: "<< StocksArray[i].Close <<" Volume: "<< StocksArray[i].Volume <<" OpenInt: "<< StocksArray[i].OpenInt<<endl;
		//emfanish sto terminal olwn twn periexomenwn tou kathe pinaka
		
		i++;
		}
		
		cout<<"\n\nLast input: "<<i<<endl;   
		//Ean thelete na deite to megethos twn pinakwn vgalte apo ta sxolia thn grammh kwdika apo panw
		
	fin.close();
	}
	else{
		cout<<"File Corrupted or doesn't Exist!"<<endl;
	}
	return i;
}


void swapStructs(struct metoxh &s1, struct metoxh &s2){
	struct metoxh temp;
	temp.Date=s1.Date;
	temp.Open=s1.Open;
	temp.High=s1.High;
	temp.Low=s1.Low;
	temp.OpenInt=s1.OpenInt;
	temp.Volume=s1.Volume;
	temp.Close=s1.Close;
	s1.Date=s2.Date;
	s1.Open=s2.Open;
	s1.High=s2.High;
	s1.Low=s2.Low;
	s1.OpenInt=s2.OpenInt;
	s1.Volume=s2.Volume;
	s1.Close=s2.Close;
	s2.Date=temp.Date;
	s2.Open=temp.Open;
	s2.High=temp.High;
	s2.Low=temp.Low;
	s2.OpenInt=temp.OpenInt;
	s2.Volume=temp.Volume;
	s2.Close=temp.Close;
	
}

void mergedifferent(struct metoxh arr[], int left, int mid, int right)
{
    int i, j, k;
    int n1 = mid - left + 1;
    int n2 = right - mid;
 
  
    /* create temp arrays */
    struct metoxh L[n1], R[n2];
 
    /* Copy data to temp arrays L[] and R[], xorizo sti mesi ton pinaka arr */ 
    //while(g=1){
	
	for (i = 0; i < n1; i++)
        StructAssignTo(arr[left+i], L[i]);		//L[i] = arr[l + i];
    for (j = 0; j < n2; j++)
        StructAssignTo(arr[mid + 1 + j],R[j]);//R[j] = arr[m + 1 + j];
    //}
 
    /* Merge the temp arrays back into arr[l..r]* , ftiaxno tous neous pinakes L kai R */
    i = 0; // Initial index of first subarray
    j = 0; // Initial index of second subarray
    k = left; // Initial index of merged subarray
    while (i < n1 && j < n2) {
        if (L[i].Date <= R[j].Date) {
            StructAssignTo( L[i], arr[k] ); //arr[k] = L[i]
            i++;
        }
        else {
            StructAssignTo( R[j],arr[k] );//arr[k] = R[j];
            j++;
        }
        k++;
    }
 
    /* Copy the remaining elements of L[], if there
    are any */
    while (i < n1) {
        StructAssignTo( L[i],arr[k] );//arr[k] = L[i];
        i++;
        k++;
    }
 
    /* Copy the remaining elements of R[], if there
    are any */
    while (j < n2) {
        StructAssignTo( R[j],arr[k] );//arr[k] = R[j];
        j++;
        k++;
    }
}
 
/* l is for left index and r is right index of the
sub-array of arr to be sorted */

void mergeSortdifferent(struct metoxh met[], int left, int right)
{
    if (left >= right) {
    return;
	}
		// Same as (l+r)/2, but avoids overflow for
        // large l and h
        int mid = left + (right - left) / 2;
 
        // Sort first and second halves
        mergeSortdifferent(met, left, mid);
        mergeSortdifferent(met, mid + 1, right);
 
        mergedifferent(met, left, mid, right);
        //cout<<"Done"<<endl;  //Debug Help
    }
    
void PrintArray(struct metoxh StocksArray[], int size){
		for(int i = 0; i < size; i++){
					cout <<"Date: "<< StocksArray[i].Date <<" Open: "<< StocksArray[i].Open <<" High: "<< StocksArray[i].High <<" Low: "<< StocksArray[i].Low <<" Close: "<< StocksArray[i].Close <<" Volume: "<< StocksArray[i].Volume <<" OpenInt: "<< StocksArray[i].OpenInt<<endl;
		}
}

#endif



