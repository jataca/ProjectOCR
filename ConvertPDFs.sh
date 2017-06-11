#!/bin/bash

#assignment
STR=$1

echo "$STR"

abstractID=$1  #Grab the parameter abstract id
abstractPDF=$2 #Name of the pdf
firstPage=$3   #First Page to work with
lastPage=$4    #Last Page to work with 
var300="$abstractID-300.tiff"
var325="$abstractID-325.tiff"
var350="$abstractID-350.tiff"
var375="$abstractID-375.tiff"
var400="$abstractID-400.tiff"

#CONVERT PDF TO TIFF
gs -sDEVICE=tiff48nc -dNOPAUSE -dBATCH -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -dDISKFONTS -r300 -dFirstPage=$firstPage -dLastPage=$lastPage -o $var300 $abstractPDF
gs -sDEVICE=tiff48nc -dNOPAUSE -dBATCH -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -dDISKFONTS -r325 -dFirstPage=$firstPage -dLastPage=$lastPage -o $var325 $abstractPDF
gs -sDEVICE=tiff48nc -dNOPAUSE -dBATCH -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -dDISKFONTS -r350 -dFirstPage=$firstPage -dLastPage=$lastPage -o $var350 $abstractPDF
gs -sDEVICE=tiff48nc -dNOPAUSE -dBATCH -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -dDISKFONTS -r375 -dFirstPage=$firstPage -dLastPage=$lastPage -o $var375 $abstractPDF
gs -sDEVICE=tiff48nc -dNOPAUSE -dBATCH -dTextAlphaBits=4 -dGraphicsAlphaBits=4 -dDISKFONTS -r400 -dFirstPage=$firstPage -dLastPage=$lastPage -o $var400 $abstractPDF


tess300="$abstractID-300"
tess325="$abstractID-325"
tess350="$abstractID-350"
tess375="$abstractID-375"
tess400="$abstractID-400"

#CONVERT TIFF TO TXT
tesseract $var300 $tess300
tesseract $var325 $tess325
tesseract $var350 $tess350
tesseract $var375 $tess375
tesseract $var400 $tess400

final300="$abstractID-300final.txt"
final325="$abstractID-325final.txt"
final350="$abstractID-350final.txt"
final375="$abstractID-375final.txt"
final400="$abstractID-400final.txt"

#REMOVE EMPTY LINES
grep -v -e '^ *$' "$tess300.txt" > $final300 # Remove all lines
grep -v -e '^ *$' "$tess325.txt" > $final325 # Remove all lines
grep -v -e '^ *$' "$tess350.txt" > $final350 # Remove all lines
grep -v -e '^ *$' "$tess375.txt" > $final375
grep -v -e '^ *$' "$tess400.txt" > $final400 # Remove all lines

#DELETE UNNEEDED FILES
rm $var300
rm $var325
rm $var350
rm $var375
rm $var400

rm "$tess300.txt"
rm "$tess325.txt"
rm "$tess350.txt"
rm "$tess375.txt"
rm "$tess400.txt"

python GenerateEverything.py $abstractID
