# kaliconfig
This repository is used to store scripts or notes that can come in handy. 

###### newkaliconfig.txt
This is a custom configuration I perform every time a reinstall is needed of Kali.

###### dedupe.sh
This is a simple bash script built around the `awk '!seen[$0]++'` command that can be used to easily remove duplicates from a file. It was written specifically for removing duplicates from lists of cleartext passwords obtained from hashes.org. Since these lists can get quite large, a single such command will consume all available memory and also slow down as each comparison takes more and more time. This script will split the target file into chunks 160 MB in size to consume no more than 3.5 GB memory at a time and also be as fast as possible, then remove duplicates. Note that each chunk may have duplicates in other chunks, but I think this is an acceptable trade-off versus a simple sort.

Non-comment code is meant for the experimental option, which would attempt to limit overall duplicates by creating larger chunks based on total available memory. However, it is not complete and not implemented.

###### myfu.txt
Keyword searching for useful information. Inspired by [this](https://rmccurdy.com/scripts/fu.txt).
