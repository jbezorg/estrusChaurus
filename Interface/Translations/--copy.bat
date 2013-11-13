@echo off
setlocal enabledelayedexpansion

set  base=EstrusChaurus_

set  arrayline[0]=CHINESE.txt
set  arrayline[1]=CZECH.txt
set  arrayline[2]=FRENCH.txt
set  arrayline[3]=GERMAN.txt
set  arrayline[4]=ITALIAN.txt
set  arrayline[5]=JAPANESE.txt
set  arrayline[6]=POLISH.txt
set  arrayline[7]=RUSSIAN.txt
set  arrayline[8]=SPANISH.txt


::read it using a FOR /L statement
for /l %%n in (0,1,8) do (
  echo copy %base%ENGLISH.txt to %base%!arrayline[%%n]!
  copy %base%ENGLISH.txt %base%!arrayline[%%n]!
)
pause