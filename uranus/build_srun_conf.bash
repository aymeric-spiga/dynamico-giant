#!/usr/bin/bash

# 0. Inotializations
declare -i nodes
declare -i nodes_cores
declare -a -i xios_procs
declare -a -i icosa_procs
declare -i procs_start
declare -i procs_end

procs_start=0
procs_end=0

nodes=1 # number of nodes to use
nodes_cores=40 # number of cores per node
icosa_cores=39 # total number of cores for icosa
xios_cores=1 # total number of cores for xios
out_file="srun.conf"

#1. Read options and set default values
while (($# > 0))
   do
   case $1 in
     "-h") cat <<........end
    $0 [ -nodes # ] [ -cores # ] [ -type # ] [ -file #]
with:
       [ -nodes # ]       number of nodes to run on
                              (default: $nodes)
       [ -cores # ]       total number of cores to run icosa_lmdz.exe on
                              (default: $icosa_cores)
       [ -type # ]        node type (i.e. how many cores per node)
                              (default: $nodes_cores)
       [ -file # ]        output file
                              (default: $out_file)
........end
     exit ;;
     "-nodes") nodes=$2 ; shift ; shift ;;
     "-cores") icosa_cores=$2 ; shift ; shift ;;
     "-type" ) nodes_cores=$2 ; shift ; shift ;;
     "-file" ) out_file=$2 ; shift ; shift ;;
     *) echo "Error, bad argument $1   Usage:" ; $0 -h ; exit
   esac
done

echo "number of nodes to run on: $nodes"
echo "number of cores per node: $nodes_cores"
echo "total number of cores to run icosa_lmdz.exe on: $icosa_cores"
echo "output written in file: $out_file"


# check that there is at least 1 free core for xios
if (( icosa_cores >= nodes * nodes_cores )) ; then
  echo "Error: Not enough cores ! "
  exit
fi


# 2. Compute # of cores per node for icosa and xios
for (( ind=0 ; ind<nodes ; ind++ ))
do
  # start by evenly spreading icosa over all nodes
  icosa_procs[$ind]=$(( $icosa_cores / $nodes ))
  #echo "ind: $ind , ${icosa_procs[$ind]}"
done

# second round: add potential orphan icosa
(( icosa_procs_remain = $icosa_cores - ${icosa_procs[0]} * $nodes ))
#echo " icosa_procs_remain = $icosa_procs_remain"
for (( ind=0 ; ind <icosa_procs_remain ; ind++ ))
do
  icosa_procs[$ind]=$(( icosa_procs[$ind] + 1 ))
done

# third round: compute corresponding xios_procs
for (( ind=0 ; ind<nodes ; ind++ ))
do
  xios_procs[$ind]=$(( $nodes_cores - icosa_procs[$ind] ))
  #echo "ind: $ind , ${icosa_procs[$ind]} , ${xios_procs[$ind]}"
done


# 3. Write configuration file
echo "# srun configuration file" > $out_file
for (( ind=0 ; ind<nodes ; ind++))
do
  (( procs_end = $procs_start + ${icosa_procs[$ind]} - 1 ))
  echo "${procs_start}-${procs_end} icosa_lmdz.exe" >> $out_file
  (( procs_start = $procs_end + 1 ))

  (( procs_end = $procs_start + ${xios_procs[$ind]} - 1 ))
  if (( $procs_end > $procs_start )) ; then # more than 1 core needed
    echo "${procs_start}-${procs_end} xios_server.exe" >> $out_file
  else
    if (( $procs_start == $procs_end )) ; then # if only 1 core needed
      echo "${procs_end} xios_server.exe" >> $out_file
    fi
  fi
  (( procs_start = $procs_end + 1 ))
done

