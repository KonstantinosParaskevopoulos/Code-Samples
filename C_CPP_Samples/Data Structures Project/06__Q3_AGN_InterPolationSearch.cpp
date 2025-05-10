#include <iostream>
#include "InputFile.h"
#include <fstream>
 using namespace std;
 bool found = false;
// If x is present in arr[0..n-1], then returns
// index of it, else returns -1.
int interpolationSearch(struct metoxh arr[], int lo, int hi, long int date)
{

    int pos;
    // Since array is sorted, an element present
    // in array must be in range defined by corner
    if (lo <= hi && date >= arr[lo].Date && date <= arr[hi].Date) {
        // Probing the position with keeping
        // uniform distribution in mind.
        pos = lo + ((((double)(hi - lo) *(date - arr[lo].Date))/ (arr[hi].Date - arr[lo].Date)));
		//cout<<"Current Position: "<<pos<<endl;
        // Condition of target found
        if (arr[pos].Date == date){
        cout << "H hmeromhnia poy pliktrologisate breuhke sth thesh " << pos;
		cout<<"\nVolume of this date:"<< arr[pos].Volume;
		found = true;
		//cout<<"\n\n\t"<<found<<endl;
            return pos;
        
        }
        
        // If x is larger, x is in right sub array
        else if (arr[pos].Date < date){
		//cout<<"Right"<<endl;
		interpolationSearch(arr, pos+1, hi, date);
 		}
        // If x is smaller, x is in left sub array


        else //(arr[pos].Date > date)
        {
		//cout<<"Left"<<endl;
		interpolationSearch(arr, lo, pos-1, date);
		}
    }
    

}

 
// Driver Code
int main()
{
    // Array of items on which search will
    // be conducted.
    struct metoxh InterPolationArray[AGN_SIZE];
    int left = 0;
    int right = AGN_SIZE-1;
    //getDatefromKeyboard();
    ifstream fin("agn.us.txt");
ReadValuesfromFile(fin, InterPolationArray);  
long int fulldate;
fulldate = getDatefromKeyboard();
cout<<"Full date: "<<fulldate<<endl;
    interpolationSearch(InterPolationArray,  left,  right,  fulldate);
 	if (!found){
  	cout << "\nDate Not Found!!!"<<endl;
	}
    return 0;
}
