#!/bin/bash

#old starting position
a=09
#latest finished run and new starting positiion
b=10
#new run
c=11

#update input file in batch file
#sed -i "s/npt${b}/npt${c}/g" gS*/nam*

#update namd input file
cd ./gS5

cp npt${b}.inp npt${c}.inp
sed -i "s/npt${b}/npt${c}/g" npt${c}.inp nam* 
sed -i "s/npt${a}/npt${b}/g" npt${c}.inp
mv *out log/
mv *err error/
sbatch nam*

cd ../

#copy namd input to other dir, edit and submit job 
cd gS3

cp ../gS5/npt${c}.inp ../gS5/nam* .
sed -i "s/gS5/gS3/g" nam* *inp
sed -i "s/gS_5/gS3/g" *inp
sed -i "s/gS-5/gS3/g" *inp
mv *out log/
mv *err error/
sbatch nam*

cd ../gS7

cp ../gS3/npt${c}.inp ../gS3/nam* . 
sed -i "s/gS3/gS7/g" *inp nam*
mv *out log/
mv *err error/
sbatch nam*

cd ../gS9A

cp ../gS3/npt${c}.inp ../gS3/nam* . 
sed -i "s/gS3/gS9A/g" *inp nam* 
mv *out log/
mv *err error/
sbatch nam*

cd ../gS9B

cp ../gS3/npt${c}.inp ../gS3/nam* . 
sed -i "s/gS3/gS9B/g" *inp nam** 
sbatch nam*

