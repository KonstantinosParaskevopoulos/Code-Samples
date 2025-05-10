#include<cstdlib>
#include<string>
#include"InputFile.h"
#include <bits/stdc++.h>
#include <time.h>

int main(){
	double time_taken[100];
	for(int j=0; j<100; j++){

	clock_t start, end;
    /* Recording the starting clock tick.*/
    start = clock();

	struct metoxh AGN[3250];
	struct metoxh AINV[3250];
	struct metoxh ALE[3250];
	ifstream file1("agn.us.txt");
	ifstream file2("ainv.us.txt");
	ifstream file3("ale.us.txt");
	
	ReadValuesfromFile(file1, AGN);
	ReadValuesfromFile(file2, AINV);
	ReadValuesfromFile(file3, ALE);
	end = clock();
	// Calculating total time taken by the program.
    time_taken[j] = double(end - start) / double(CLOCKS_PER_SEC);
	
	}
	double sum = 0;
	for(int z=0; z<100; z++){
		cout<<time_taken[z]<<endl;
		sum = sum + time_taken[z];
	}
	double avg;
	avg = (double)sum / 100.0;
	cout<<"****************************************\nAverage time of Execution is:"<<avg<<setprecision(10);
	return 0;
}




  
    
  
    
