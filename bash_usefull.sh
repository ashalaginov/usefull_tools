### Fast count of the huge number of files in a directory (more than 100K files or so). This can be achieved by disabling sorting in ls (-f) and excluding first two directories (. and ..):
ls -fA | wc -l

###Pprint only PE32 files in a directory:
file * | grep PE32 | awk '{print $1}' | awk '{gsub(/:$/,""); print}'

### Move file renamed to its MD to a folder:
md5sum examples.desktop | awk '{print $2  " folder/" $1}'

### Move all files from folder, but not subfolders
find ~/Downloads/ -maxdepth 1 -type f -print0 | xargs -0 mv -t ~/Videos

### Find top 20 directorie with largest size
 for i in G M K; do du -xh | grep [0-9]$i | sort -nr -k 1; done | head -n 20
 
 ### Total size of files excluding some extensions (*.txt) in a directory
find . -type f -not -name '*.txt' -exec du -ch {} + | grep total$

### Look for a file location by its md5sum_given
find /folder -type f -exec md5sum {} + | grep '^md5sum_given'

### Fetch all files following their URLs listed in urlfile file
cat urlfile | parallel --gnu "wget {}"

### Append all *.txt files in a folder without their headers except the first one.
awk 'FNR==1 && NR!=1 { while (/^[a-z]/) getline; } 1 {print} ' file*.txt >file_all.txt

### Find all files in the directory 
find $PWD -maxdepth 1 -type f

### Show only desciption from 'file' output
file file.sh | awk '{print substr($0, index($0, $2))}'

### Print every 3-th line of the file
awk 'NR == 1 || NR % 3 == 0' file.txt

### Elapsed time for the VirtualBox machine to finish loading
ps -p $(ps aux | grep virtualbox| grep  VBoxHeadless | awk '{print $2}') -o etimes=

### Speech recognitition from video (lectures etc in English)
#Download: https://sourceforge.net/projects/cmusphinx/files/Acoustic%20and%20Language%20Models/US%20English/ newest cmusphinx-en-us-....tar.gz and en-70k-....lm.gz
ffmpeg -i book.mp3 -ar 16000 -ac 1 book.wav
pocketsphinx_continuous -infile book.wav -hmm cmusphinx-en-us-8khz-5.2 -lm en-70k-0.2.lm     2>pocketsphinx.log >book.txt

### Fast export / import of large MySQL databases / tables using mysqldump:
mydumper -B DB -T TABLE -u root -p -t 4 -r 1000000 -d folder/
myloader -B DB -u root -p -t 4 -q 1000000  -d export
/usr/local/bin/mydumper -B DB -u root -p -t 4 -r 1000000 -c -L mydumper.log -d folder/

### Print only sections sizes from PE32 header without the first line
size file.exe awk '{if(NR>1)print $1, " ", $2, " ", $3, " ", $4}' | awk '{if(NR>1)print $1, " ", $2, " ", $3, " ", $4}'

### Convert big PDF to small PDF
convert -density 150x150 -quality 60 -compress jpeg big.pdf small.pdf

### Find all files in current/sub-folders and remove spaces in the file names
find . -maxdepth 10 -type f  | rename 's/ /_/g' -f

### Process all files in  current/sub-folders and copy renamed md5 files to a specific directory with forced replacement if exists. Running in parallel with 4 threads
for i in $(find $PWD -maxdepth 10 -type f); do
    md5sum  "$i"   | awk '{print  $2  " ../'$(echo "${PWD##*/}")'_md5/" $1}' | xargs -P 4  --no-run-if-empty cp -rf
done

### Filter specific PE32 files and copy them to a specific directory with replacement if needed. Running in parallel with 4 threads
#!/bin/sh
dir=malware1;
pattern1="PE32 executable (GUI) Intel 80386, for MS Windows"
pattern2="PE32 executable (DLL) (GUI) Intel 80386, for MS Windows"
pattern3="PE32 executable (native) Intel 80386, for MS Windows"
pattern4="PE32 executable (console) Intel 80386, for MS Windows";
pattern5="PE32 executable (DLL) (console) Intel 80386, for MS Windows"
cd $dir'_md5';
for i in $(find $PWD  -type f); do
    filename=$(basename "$i")
    file $i | grep  -e "$pattern1" -e "$pattern2"  -e "$pattern3" -e "$pattern4" -e "$pattern5" | awk '{print $1}' | awk '{gsub(/:$/,""); print $filename  " ../'$dir'_PE32/'$filename'" }' | xargs -P 4  --no-run-if-empty cp -rf



### Move all PE32 files to one folder and other files to another folder. Works well when the number of files is too big >100K in the folder.
#!/bin/sh
cd unsorted;
counter=0;
for i in *; do
    counter=$((counter+1));
    echo "$counter";
    VAR="file $i | grep PE32 " ;
    VAR1=$(eval "$VAR") ;
    len1=${#VAR1};
    if [ -n "$VAR1" ] && [ "$len1" -gt "1" ] ;
    then
    	 echo "$VAR1" | awk '{print $1}' | awk '{gsub(/:$/,""); print $1 " ../PE/" $1}'| xargs mv -f  ;
    else
    	echo "other";
    	file $i | awk '{print $1}' | awk '{gsub(/:$/,""); print $1 " ../other/" $1}' | xargs mv -f ;
    fi
done

## Download content of a website recursively with all files
wget --recursive --no-clobber --page-requisites --html-extension --convert-links --restrict-file-names=windows --no-parent website.com

## Delete directories with content older than 45 days
find /var/log/nginx  -type d -mtime +45| while read line; do
    rm -rf $line;
done;

## Delete files older than 60 days
find  /usr/reports -type f -mtime +60 | while read line; do
    rm -rf $line;
done;


## Check if 1min loads are greater than 3 and inform through email
d=`date '+%Y%m%d'`
h="Hostname"
m="EMAIL@domain"
load=$(/usr/bin/uptime |  awk -F'averages:' '{print $2}' | awk -F ',' '{print $1}' | awk -F '.' '{print $1}' | tr -d " ")
if [ "$load" -gt "3" ];
then
    echo "LOADS! 1 min = $load " | /usr/bin/mail -s "System status $h $d" $m
fi;

## Check if tempereature is greater than +80C and inform though email
temp=$(/sbin/sysctl -a | grep tempe |  awk -F':' '{print $2}' | tail -n 1 | tr -d "C\n" | tr -d " " | awk -F'.' '{print $1}')
if [ "$temp" -gt "80" ];
then
    echo "TEMPERATURE! $temp C" | /usr/bin/mail -s "System status $h $d" $m
fi;

## Export MySQL table and use maximal compression
date=`/bin/date +%Y.%m.%d_%H:%M`
/usr/local/bin/mysqldump DB --user=root  --force --password=PASSWORD > /usr/backup/${date}/DB_${date}.sql --default-character-set=utf8
/usr/bin/gzip -9 /usr/backup/${date}/DB_${data}.sql
