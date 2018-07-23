#!/bin/bash

# Author: Yosef Kerzner
# Date: 2/27/18
# Version 0.0.1

# Main function that does all the work
deduper() {

start_time="$(date -u +%s)"
#totalMemory=`awk '/MemTotal/{print $2}' /proc/meminfo`

#totalMemory=`free -m | grep -oP "Mem:\s+\d+" | grep -oP "\d+"`

# totalMemory * (10^6 for split command / (the number to play with e.g. 40))

#fileSize=$(( totalMemory * 13500 ))

#printf "\nSplit target into pieces of $fileSize bytes"
printf "\nSplit target into pieces of 160 MB\n"

# Assign the filename it to a variable from the $1 input
directory=$(basename $1)
# Now make it be the filename without the extension (txt etc)
directory="${directory%.*}"
# Make a directory of the input file and switch to it
# Unless it's already there in which case we delete it

# If the directory exists already, such as from a previous abort, then delete it
if [[ -d $directory ]]
then
	rm -R $directory
fi

mkdir $directory
cd $directory

printf "\nSplitting the file into pieces..."
# Since we are in a lower directory,
# the $1 file is one level higher (../).
# split -d assigns numeric suffixes but this
# isn't really necessary

#split -d -b $fileSize ../$1
split -d -b 160000000 ../$1

#to get number of files in directory
count=`ls | wc -l`

printf "\nProcessing $count pieces, please wait...\n"

# iterate over each file in the directory
FILES=*
for f in $FILES
do
	awk '!seen[$0]++' $f > $f"_uniq.part"
	printf "\nPart $f is complete"
done

# Concatenate all .part files back to one uniq'd file
# in ../ directory

cat *.part > ../$directory"_uniq.txt"
cd ..
rm -R $directory

end_time="$(date -u +%s)"
duration="$(($end_time-$start_time))"

printf "\nDeduping took $duration seconds."
printf "\nAll done!\n"

}


case "$1" in
	"")
	  printf "Usage: $0 [--help|-h] [--experimental|-e] [--file|-f] <input_file>\n"
	  RETVAL=1
	  ;;
	--help|-h)
	  printf "\nThis script dedupes wordlists, or really anything you give it.      "
	  printf "\nIt does so by splitting the given file into 160-MB files, finding   "
	  printf "\njust the uniq ones, saving them in new files, then concatenating    "
	  printf "\nall the new files together. There's a lot extra in the script in case I   "
	  printf "\ndecide to switch back to a processing file size based on the total  "
	  printf "\namount of RAM available on the system on which it is run, however   "
	  printf "\n160 MB seems like a reasonable compromise that prevents more than   "
	  printf "\n3 GB of RAM from being used at any time.                            "
	  printf "\n\nYour new file will be the original filename plus '_uniq' appended.\n"
	  RETVAL=1
	  ;;
	--experimental|-e)
	  printf "\nNot implemented yet\n"
	  RETVAL=1
	  ;;
	--file|-f)
	  # if filename is not provided
	  if [ -z $2 ]
	  then
	  	echo "Need filename"
	  	RETVAL=1
	  # if filename is not valid
	  elif [[ ! -f $2 ]]
	  then
	  	echo "File provided does not exist"
	  	RETVAL=1
	  else
	    deduper $2
	  fi
esac

exit $RETVAL