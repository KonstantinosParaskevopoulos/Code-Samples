#include <iostream>
#include <cstdlib>
#include <fstream>
#include "InputFile.h"




int BinarySearch(struct metoxh array[], int first, int middle, int last, long int WantedDate){
	first = 0;
   	last = TEST_SIZE - 1;
   	middle = (first+last)/2;
   	bool found = false;
 
    while (first <= last) {
   
       	if(array[middle].Date < WantedDate)
       	{
        first = middle + 1;
        middle = (first + last)/2;
        //cout<<"Right"<<endl;
    	}
       	else if (array[middle].Date == WantedDate)
	   	{
    	cout << "H hmeromhnia poy pliktrologisate breuhke sth thesh " <<  middle;
    	cout<< "\nVolume of this date is:" << array[middle].Volume;
        found = true;
		return middle;
    	}
    	else
		{
		last = middle - 1;
   		middle = (first + last)/2;
   		//cout<<"Left"<<endl;
		}
	}

 
 	if (!found){
  	cout << "Date Not Found!!!"<<endl;
   	}
return -1;
}


int main()
{
	struct metoxh binarysearcharray[AGN_SIZE];
	ifstream fin("agn.us.txt");
	ReadValuesfromFile(fin, binarysearcharray);  
	//mergeSortdifferent(binarysearcharray, 0, TEST_SIZE - 1);
	
	
  	int first = 0;
  	int last = AGN_SIZE-1;
  	int middle = (first + last)/2;

  	long int fulldate;
	fulldate = getDatefromKeyboard();
	cout<<"Full date: "<<fulldate<<endl;

	BinarySearch(binarysearcharray , first, middle, last, fulldate);
	
 

	return 0;
}
