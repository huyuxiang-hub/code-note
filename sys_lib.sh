#!/bin/bash

function rm(){
  
    local suffix=$( date "+%Y-%m-%d-%H:%M:%S" ) 
    local File=$1
    local file

    for file in $File
    do

    if [ -d /scratchfs/juno/huyuxiang/Trash ] 
    then
         echo "/scratchfs/juno/huyuxiang/Trash exist."
    else 
        mkdir /scratchfs/juno/huyuxiang/Trash
      
    fi
    
   
    if [ -f $file ]
    then
         mv $file   /scratchfs/juno/huyuxiang/Trash/${file}-${suffix}
    fi
    
    if [ -d $file ]
    then
         mkdir /scratchfs/juno/huyuxiang/Trash/${file}-${suffix}
         mv ${file}/   /scratchfs/juno/huyuxiang/Trash/${file}-${suffix}/
    fi  
    echo "delete $file sucessfully!! you can recover it at /scratchfs/juno/huyuxiang/Trash/ !!"
    done

}

 
 function create_alg(){
  
   local alg_name=$1
   local cur_dir=$( pwd )
   echo "$alg_name"
     
   cp /junofs/users/huyuxiang/juno_centos7_v2/offline/Examples/FirstAlg $cur_dir/${alg_name} -r
   
   cd $cur_dir/${alg_name}/cmt
   sed "s/FirstAlg/${alg_name}/g"  requirements > requirements_tmp
   rm requirements
   mv requirements_tmp requirements

   cd $cur_dir/${alg_name}/python
   cp ./FirstAlg  ./${alg_name}  -r
   rm FirstAlg
  
   cd $cur_dir/${alg_name}/python/${alg_name}
   sed "s/FirstAlg/${alg_name}/g" __init__.py > __init__.py_tmp
   rm __init__.py
   mv __init__.py_tmp  __init__.py
  
   cd $cur_dir/${alg_name}/share/
   sed "s/FirstAlg/${alg_name}/g ; s/task.asTop()/ /g ; s/Sniper.Task/Sniper.TopTask/g" run.py > run.py_tmp
   rm run.py
   mv run.py_tmp run.py
   
   cd $cur_dir/${alg_name}/src/
   sed "s/FirstAlg/${alg_name}/g"  FirstAlg.cc > ${alg_name}.cc
   sed "s/FirstAlg/${alg_name}/g ; s/FIST_ALG/${alg_name}/g" FirstAlg.h > ${alg_name}.h
   rm FirstAlg.cc
   rm FirstAlg.h
  

   cd $cur_dir/${alg_name}/cmt
   cmt make clean
   cmt config
   cmt make
   
   cd $cur_dir/${alg_name}/share/
   python run.py
   
   cd $cur_dir/
   echo "${alg_name} is created successfully!!"



}

function data_ana(){

 local file=$1
 
 col=$( head -n1 $file | awk   -F  ' '  '{print NF}' )
  
 awk -v num=$col 'BEGIN{ for(i=1;i<=num;i++){sum[i]=0;ave[i]=0;} total=0;} {for(i=1;i<=num;i++){ sum[i]+=$i;} total+=1} END{for(i=1;i<=num;i++){ave[i]=sum[i]/total;print "the "i" columns: Sum      average   \n" "           "sum[i] "   " ave[i]"  \n" ;}}' $file
 



}




