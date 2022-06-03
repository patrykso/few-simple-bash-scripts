#!/bin/bash
grep "OK DOWNLOAD" cdlinux.ftp.log | cut -d '"' -f 2,4 | grep "\.iso" | sort | uniq | grep "cdlinux" | cut -d '/' -f 6 > temp.txt 
grep "thttpd.log" cdlinux.www.log | cut -d " " -f 1,7,9 | sort | uniq | grep "cdlinux" | cut -d '/' -f 6 | grep "200" | cut -d " " -f 1 >> temp.txt 
grep ".\iso" temp.txt | sort | uniq -c | sort -r
