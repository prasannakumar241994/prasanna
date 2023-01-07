#!/bin/bash

echo -e "Prasannakumar\ndevops engineer"

Name="SSH_Academy"
course="Devops"
month="November 2022"

echo "Joined to $Name for $course training in the month of $month"

#write script for bigger number of 5 8

if [ 5 -ge 8 ]
   then
	  echo "5 is greater then 8"
  else
	  echo "8 is greater then 5"
fi

#shell script for factorial number

num= 5
fact= 1
while [ $num -gt 0 ]
    do
	    fact=`expr $fact \* $num`
	    num=`expr $num - 1`
    done
    echo " Factorial of given number 5 is $fact"


