// Counting sort in C++ programming

#include <iostream>
#include"InputFile.h"
using namespace std;

void countSort(struct metoxh StocksArray[], int size) {
  // The size of count must be at least the (max+1) but
  // we cannot assign declare it as int count(max+1) in C++ as
  // it does not support dynamic memory allocation.
  // So, its size is provided statically.
  
  struct metoxh output[3500];
  int count[3500];
  float max = StocksArray[0].Close;
  //cout<<"OK_4\n";
  // Find the largest element of the array
  for (int i = 1; i < size; i++) {
    if (StocksArray[i].Close > max)
      max = StocksArray[i].Close;
  }
  //cout<<"OK_5\n";
  // Initialize count array with all zeros.
  for (int i = 0; i <= max; ++i) {
    count[i] = 0;
  }
//	cout<<"OK_6\n";
  // Store the count of each element
  for (int i = 0; i < size; i++) {
    count[(int)StocksArray[i].Close]++;
  }
//	cout<<"OK_7\n";
  // Store the cummulative count of each array
  for (int i = 1; i <= max; i++) {
    count[i] += count[i - 1];
  }
//	cout<<"OK_8\n";
  // Find the index of each element of the original array in count array, and
  // place the elements in output array
  for (int i = size - 1; i >= 0; i--) {
    StructAssignTo(StocksArray[i], output[count[(int)StocksArray[i].Close] - 1]);//output[count[StocksArray[i]] - 1] = StocksArray[i];
    count[(int)StocksArray[i].Close]--;
  }
//	cout<<"OK_9\n";
  // Copy the sorted elements into original array
  for (int i = 0; i < size; i++) {
    StocksArray[i] = output[i];
  }
//  cout<<"OK_10\n";
}

// Function to print an array
/*void printArray(int array[], int size) {
  for (int i = 0; i < size; i++)
    cout << array[i] << " ";
  cout << endl;
}*/

// Driver code
int main() {
  
    ifstream infile("agn.us.txt");
 //   cout<<"OK_1\n";
	struct metoxh Stocks[AGN_SIZE];
//	cout<<"OK_2\n";
    ReadValuesfromFile(infile, Stocks);
 //	cout<<"OK_3\n";
    countSort(Stocks, AGN_SIZE);
 //	cout<<"OK_\n";
    cout << "Sorted array is \n";
 //   cout<<"OK_\n";
    PrintArray(Stocks, AGN_SIZE);
 //   cout<<"OK_\n";

}
