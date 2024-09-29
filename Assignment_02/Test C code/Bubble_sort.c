//====================================================//
// File Name    :   Bubble_sort.c
// Author       :   Ujjwal Chaudhary, M. Tech. ESE'25, IISc Bangalore.
// Course       :   E3 245 Processor System Design
// Assignment   :   2
// Topic        :   32-bit RISC-V Single-clcycle Processor
// ===================================================//

//--------------------------------------------DESCRIPTION---------------------------------------------//
// C program to sort an array of 10 elements in ascending order using Bubble Sort Algorithm.
//----------------------------------------------------------------------------------------------------//

#include <stdio.h>

void main(){
    int arr[10] = {53, 4, 122, 8, 6, 15, 3, 7, 127, 10};
    int i, j, temp;

    // Bubble Sort Algorithm
    for(i=0; i<10; i++){
        for(j=0; j<10-i-1; j++){
            if(arr[j] > arr[j+1]){
                temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }

}