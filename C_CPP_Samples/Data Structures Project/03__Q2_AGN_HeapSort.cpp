#include<cstdlib>
#include<iostream>
#include<fstream>

#include"InputFile.h"

using namespace std;
 
// To heapify a subtree rooted with node i which is
// an index in arr[]. n is size of heap
void heapify(struct metoxh StocksArray[], int n, int i)
{
    int largest = i; // Initialize largest as root
    int l = 2 * i + 1; // left = 2*i + 1
    int r = 2 * i + 2; // right = 2*i + 2
 
    // If left child is larger than root
    if (l < n && StocksArray[l].Close > StocksArray[largest].Close)
        largest = l;
 
    // If right child is larger than largest so far
    if (r < n && StocksArray[r].Close > StocksArray[largest].Close)
        largest = r;
 
    // If largest is not root
    if (largest != i) {
        swap(StocksArray[i], StocksArray[largest]);
 
        // Recursively heapify the affected sub-tree
        heapify(StocksArray, n, largest);
    }
}
 
// main function to do heap sort
void heapSort(struct metoxh StocksArray[], int n)
{
    // Build heap (rearrange array)
    for (int i = n / 2 - 1; i >= 0; i--)
        heapify(StocksArray, n, i);
 
    // One by one extract an element from heap
    for (int i = n - 1; i > 0; i--) {
        // Move current root to end
        swapStructs(StocksArray[0], StocksArray[i]);
 
        // call max heapify on the reduced heap
        heapify(StocksArray, i, 0);
    }
}
 
/* A utility function to print array of size n */
void printArray(struct metoxh StocksArray[], int n)
{
    for (int i = 0; i < n; ++i)
        cout <<"Date: "<< StocksArray[i].Date <<" Open: "<< StocksArray[i].Open <<" High: "<< StocksArray[i].High <<" Low: "<< StocksArray[i].Low <<" Close: "<< StocksArray[i].Close <<" Volume: "<< StocksArray[i].Volume <<" OpenInt: "<< StocksArray[i].OpenInt<<endl;
}
 
// Driver code
int main()
{
    ifstream infile("agn.us.txt");
	struct metoxh Stocks[AGN_SIZE];
    ReadValuesfromFile(infile, Stocks);
	int n = sizeof(Stocks) / sizeof(Stocks[0]);
 
    heapSort(Stocks, n);
 
    cout << "Sorted array is \n";
    printArray(Stocks, n);
}
