#include <iostream>
#include "InputFile.h"
#include <math.h>
 using namespace std;
 bool found = false;
// If x is present in arr[0..n-1], then returns
// index of it, else returns -1.
int BinaryInterpolationSearch(struct metoxh arr[], int left, int right, long int date)
{

int size  = right-left+1;
int root = sqrt(sqrt(size));
int next = ((size * ((double)date-arr[left].Date))/(arr[right].Date-arr[left].Date))+1;
cout<<"Size: "<<size<<"\nNext: "<<next<<"\nRoot: "<<root<<endl;
while(date != arr[next].Date){
	int i=0;
	size = right - left +1;
	//cout<<"New Size: "<<size<<endl;
	//cout<<"OK_01"<<endl;
//	if(size<=3){
//		//DirectSearch();
//	}
	if (date>=arr[next].Date){
		while(date>arr[next-(i*root)+1].Date){
			cout<<"ARR INDEX: "<<next-(i*root)+1<<"\nOK_"<<i<<"\nARR: "<<arr[next-(i*root)+1].Date<<endl;
			i++;
		}
		right = next + (i* root);
		cout<<"OK_Right: "<<right<<endl;
		left = next +((i-1) *root);
		cout<<"OK_Left: "<<left<<endl;
		root = sqrt(right-left);
	}
	else if(date<arr[next].Date){
		while(date<arr[next-(i*root)+1].Date){
			cout<<"OK_"<<i<<"\nARR: "<<arr[next-(i*root)+1].Date<<endl;
			i++;
		}
		left = next - (i* root);
		cout<<"OK_Left: "<<left<<endl;
		right = next -((i-1) *root);
		cout<<"OK_Right: "<<right<<endl;
		root = sqrt(right-left);
	}
	next = left+((right-left+1)*(((double)date-arr[left].Date)/(arr[right].Date-arr[left].Date)))-1;
	cout<<"NEXT= "<<next<<endl;
}
if(date==arr[next].Date){
	//Success
	cout << "H hmeromhnia poy pliktrologisate breuhke sth thesh " << next;
	cout<<"\nVolume of this date:"<< arr[next].Volume;
	return next;
}
else{
	cout<<"Date not Found"<<endl;	
}
return -1;
}

 
// Driver Code
int main()
{
    // Array of items on which search will
    // be conducted.
    struct metoxh BinaryInterPolationArray[AGN_SIZE];
    int left =0;
    int right = AGN_SIZE-1;
    //getDatefromKeyboard();
    ifstream fin("agn.us.txt");
ReadValuesfromFile(fin, BinaryInterPolationArray);  
long int fulldate;
fulldate = getDatefromKeyboard();
cout<<"Full date: "<<fulldate<<endl;
    BinaryInterpolationSearch(BinaryInterPolationArray,  left,  right, fulldate);


    return 0;
}

