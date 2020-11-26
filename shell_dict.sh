#!/bin/bash

declare -A model
declare -A QE
declare -A LS_length

event=2000

model=([new]=" --absreemit --scintsimple "  [old]="  ")
QE=([normalqe]=" " [flatqe]=" --enableFlatQE ") 
LS_length=([LAB]=0 [new_abs]=1 [old_abs]=2)

for key_model in $( echo ${!model[*]})
   do
      for key_QE in $( echo ${!QE[*]})
        do
          for key_LS in $( echo ${!LS_length[*]})
             do
                name="${key_model}-${key_QE}-${key_LS}"
                 
                cat>"${name}.sh"<<EOF
#!/bin/bash
. /junofs/users/huyuxiang/juno_centos7/bashrc
python ~/workfs/tut_detsim_optical.py --evtmax $event  --GdLSAbsLengthMode ${LS_length[${key_LS}]}  ${QE[${key_QE}]} ${model[${key_model}]}   --no-cerenkov   --output ${name}.root  --user-output ${name}_user.root gun >& ${name}.log
EOF
               chmod +x "${name}.sh"

               hep_sub "${name}.sh"  -mem 8000 -wn bws0768.ihep.ac.cn  
             #  rm -rf "${name}.sh"
            done

      done

done


echo ${LS_length[new_abs]}


:<<BL
event=2000

cat>"optical_new_flatqe.sh"<<EOF
#!/bin/bash
. /junofs/users/huyuxiang/juno_centos7/bashrc
python ~/workfs/tut_detsim_optical.py --evtmax $event  --GdLSAbsLengthMode 0 --enableFlatQE --absreemit --scintsimple   --output optical_new_flatqe.root  --user-output optical_new_flatqe_user.root gun >& optical_new_flatqe.log
EOF

chmod +x "optical_new_flatqe.sh"
hep_sub optical_new_flatqe.sh  -mem 8000 -wn bws0768.ihep.ac.cn


cat>"optical_old.sh"<<EOF
#!/bin/bash

. /junofs/users/huyuxiang/juno_centos7/bashrc
python ~/workfs/tut_detsim_optical.py --evtmax $event  --GdLSAbsLengthMode 2  --output optical_old.root  --user-output optical_old_user.root gun >& optical_old.log
EOF
chmod +x "optical_old.sh"
hep_sub optical_old.sh  -mem 8000 -wn bws0768.ihep.ac.cn



cat>"optical_old_flatqe.sh"<<EOF
#!/bin/bash

. /junofs/users/huyuxiang/juno_centos7/bashrc
python ~/workfs/tut_detsim_optical.py --evtmax $event  --GdLSAbsLengthMode 2 --enableFlatQE  --output optical_old_flatqe.root  --user-output optical_old_flatqe_user.root gun >& optical_old_flatqe.log
EOF
chmod +x optical_old_flatqe.sh
hep_sub optical_old_flatqe.sh  -mem 8000 -wn bws0768.ihep.ac.cn


cat>"optical_old_flatqe_updateLS.sh"<<EOF
#!/bin/bash

. /junofs/users/huyuxiang/juno_centos7/bashrc
python ~/workfs/tut_detsim_optical.py --evtmax $event  --GdLSAbsLengthMode 1 --enableFlatQE  --output old_optical_flatqe_updateLS.root  --user-output old_optical_flatqe_updateLS_user.root gun > optical_old_flatqe_updateLS.log
EOF
chmod +x optical_old_flatqe_updateLS.sh
hep_sub optical_old_flatqe_updateLS.sh  -mem 8000 -wn bws0768.ihep.ac.cn


hep_sub optical_old.sh -mem 8000 -wn bws0768.ihep.ac.cn

BL

