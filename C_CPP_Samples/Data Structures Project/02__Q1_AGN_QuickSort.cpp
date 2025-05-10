#include <iostream>
#include"InputFile.h"
using namespace std;


/* This function takes last element as pivot, places
the pivot element at its correct position in sorted
array, and places all smaller (smaller than pivot)
to left of pivot and all greater elements to right
of pivot */
int partition (struct metoxh arr[], int low, int high)
{
	int pivot = arr[high].Open; // pivot
	int i = (low - 1); // Index of smaller element and indicates the right position of pivot found so far

	for (int j = low; j <= high - 1; j++)
	{
		// If current element is smaller than the pivot
		if (arr[j].Open < pivot)
		{
			i++; // increment index of smaller element
			swapStructs(arr[i], arr[j]);
		}
	}
	swapStructs(arr[i + 1], arr[high]);
	return (i + 1);
}

/* The main function that implements QuickSort
arr[] --> Array to be sorted,
low --> Starting index,
high --> Ending index */
void quickSort(struct metoxh arr[], int low, int high)
{
	if (low < high)
	{
		/* pi is partitioning index, arr[p] is now
		at right place */
		int pi = partition(arr, low, high);

		// Separately sort elements before
		// partition and after partition
		quickSort(arr, low, pi - 1);
		quickSort(arr, pi + 1, high);
	}
}

int main()
{
	ifstream infile("agn.us.txt");
	struct metoxh Stocks[AGN_SIZE];
    ReadValuesfromFile(infile, Stocks);

	quickSort(Stocks, 0, AGN_SIZE - 1);
	cout << "Sorted array: \n";
	PrintArray(Stocks, AGN_SIZE);//From InputFile.h
	return 0;
}


