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



