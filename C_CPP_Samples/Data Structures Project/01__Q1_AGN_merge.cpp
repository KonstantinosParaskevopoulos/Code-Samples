#include"InputFile.h"
#include<cstdlib>
#include<string>
#include <iostream>

 
using namespace std;





void merge(struct metoxh arr[], int left, int mid, int right)
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
        if (L[i].Open <= R[j].Open) {
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

void mergeSort(struct metoxh met[], int left, int right)
{
    if (left >= right) {
    return;
	}
		// Same as (l+r)/2, but avoids overflow for
        // large l and h
        int mid = left + (right - left) / 2;
 
        // Sort first and second halves
        mergeSort(met, left, mid);
        mergeSort(met, mid + 1, right);
 
        merge(met, left, mid, right);
        //cout<<"Done"<<endl;  //Debug Help
    }

 
void printArray(struct metoxh arr[], int size)
{
    int i;
    int j=1;
    for (i = 0; i < size; i++){
        cout<<arr[i].Date<<"||"<<arr[i].Open<<endl;
}
}
 
int main()
{
struct metoxh test[AGN_SIZE];
ifstream file1("agn.us.txt");
ReadValuesfromFile(file1, test);

 
    mergeSort(test, 0, AGN_SIZE - 1);
 	cout<<"\nSorted array is \n";
    printArray(test, AGN_SIZE);
    return 0;
}
