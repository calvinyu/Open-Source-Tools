#!/bin/bash

[ -d ~/.question ] || mkdir ~/.question;
[ -d ~/.question/questions ] || mkdir ~/.question/questions;
[ -d ~/.question/answers ] || mkdir ~/.question/answers;
[ -d ~/.question/votes ] || mkdir ~/.question/votes;

if [ $# -lt 1 ]; then
    echo "no option is given"
    exit 1
fi

case $1 in
  create)
     #validate argument #
     if [ $# -lt 2 ]; then echo "option create: too few argument"; exit 1; fi
     if [ $# -gt 3 ]; then echo "option create: too many argument"; exit 1; fi

     qroot=~/.question/questions
     qname=$2
     question=$3
     [ $# -lt 3 ] && read question;
     if [ ! -n "$question" ] || [[ $question == *====* ]]
     then
          echo "invalid question: $question";
          exit 1; 
     fi   
         
     if [ -f "$qroot/$qname" ]
     then echo "quesion already exist: $qname";
              exit 1;
     else 
        # touch ~/.question/questions/$2;
         echo $question > ~/.question/questions/$2;
         exit 1;
     fi
     ;;
  answer)
       ansroot=~/.question/answers

       #validate question_id 
       if [[ ! $2 == */* ]]
       then echo "invalid question_id: $2";
            exit 1; 
       fi
       que_user=`echo $2 | cut -d/ -f1`
       que_name=`echo $2 | cut -d/ -f2`

       #validate que_name
       if [[ $2 == */*/* ]]; then echo "invalid quesion_id: $2"; exit 1; fi

       answer_name=$3
       answer=$4
       que_root=/home/$que_user/.question/questions

       #validate answer name
       if [[ $answer_name == */* ]]; then echo "invalid answer_name: $answer_name"; exit 1; fi

       ## validate answer and read
       [ $# -lt 4 ] && read answer;
       if [ ! -n "$answer" ] || [[ $answer == *====* ]]
       then
            echo "invalid answer";
            exit 1;
       fi

     #  echo $que_user;
     #  echo $que_name;
     #  echo $answer_name
     #  echo $answer;

      ## first check if question exist
       if [ ! -f $que_root/$que_name ]
       then echo "no such question: $que_user/$que_name";
            exit 1;
       fi


       [ -d $ansroot/$que_user ] || mkdir $ansroot/$que_user;
       [ -d $ansroot/$que_user/$que_name ] || mkdir $ansroot/$que_user/$que_name;
       if [ -f "$ansroot/$que_user/$que_name/$answer_name" ]
       then echo "answer_name already esixt: $answer_name";
            exit 1;
       else
            echo $answer > $ansroot/$que_user/$que_name/$answer_name;
            exit 0;
       fi
       ;;
  list)
       if [ $# -gt 2 ]; then echo "too many argument"; exit 1; fi
       if [ ! -n "$2" ] 
       then
 
       all_user=/home/unixtool/data/question/users;
            for u in $(cat $all_user); do
                que_path=/home/$u/.question/questions;
                for q in $(ls $que_path); do
                    echo "$u/$q"; done
            done
       else
            if [ ! -d /home/$2 ];then 
               echo "no such user: $2"
               exit 1
            fi
            que_path=/home/$2/.question/questions;
            for q in $(ls $que_path);
            do
                echo "$2/$q"
	    done
       fi
       ;;

  vote)
       #validate question_id
       if [[ ! $3 == */* ]] || [[ $3 == */*/* ]]
       then echo "wrong question_id: $3";
            exit 1; 
       fi
       que_user=`echo $3 | cut -d/ -f1`
       que_name=`echo $3 | cut -d/ -f2`
       que_root=/home/$que_user/.question/questions

       ## first check if question exist
       if [ ! -f $que_root/$que_name ]
       then echo "no such question: $que_user/$que_name";
            exit 1;
       fi
      
       # create dir and file if not exist
       vote_root=~/.question/votes
        [ -d $vote_root/$que_user ] || mkdir $vote_root/$que_user;
        [ -f $vote_root/$que_user/$que_name ] || touch $vote_root/$que_user/$que_name;
 
       # handle whether answer_id exist
       if [ ! "$4" == "" ]; then
          # validate answer_id
          if [[ ! $4 == */* ]] || [[ $4 == */*/* ]]
             then echo "wrong answer_id: $4";
             exit 1; 
          fi
          ans_user=`echo $4 | cut -d/ -f1`
          ans_name=`echo $4 | cut -d/ -f2`
          ansroot=/home/$ans_user/.question/answers

          #validate answer name
             if [[ $answer_name == */* ]]; then
                echo "wrong answer_name: $answer_name"; exit 1;
             fi
          # check if the answer_id exist   
             if [ ! -f "$ansroot/$que_user/$que_name/$ans_name" ]
                then echo "answer_id not esixt: $4";
                exit 1;
             fi
       fi 

     
       # validate and process vote cammand
       file=$vote_root/$que_user/$que_name 

       if [ "$2" == "up" ]; then 
	  if [ "$4" == "" ]; then
           #  sed -i '/^up$/d' $file
	   #  sed -i '/^down$/d' $file
             echo "up" >> $file
          else
          #   sed -i "/$ans_user\/$ans_name/d" $file
             echo "up $4" >> $file 

          fi             

       elif [ "$2" == "down" ]; then
          if [ "$4" == "" ]; then
          #   sed -i '/^up$/d' $file
	  #   sed -i '/^down$/d' $file
             echo "down" >> $file
          else
          #   sed -i "/$ans_user\/$ans_name/d" $file
             echo "down $4" >> $file 
          fi

       else echo " wrong option(up|down): $2"; exit 1; 
       fi

       ;;
  view)
       all_user=/home/unixtool/data/question/users;

       if [ $# -lt 2 ]; then
          echo "too few argument # given to option";
          exit 1;
       fi
       if [ $# -gt 3 ]; then
          echo "too many argument # given to option";
          exit 1
       fi

       for arg in ${@:2}; do
           #validate question_id
           if [[ ! $arg == */* ]] || [[ $arg == */*/* ]]
              then echo "wrong question_id: $arg";
              exit 1; 
           fi
           que_user=`echo $arg | cut -d/ -f1`
           que_name=`echo $arg | cut -d/ -f2`
           que_root=/home/$que_user/.question/questions

           ## first check if question exist
           if [ ! -f $que_root/$que_name ]
              then echo "no such question: $que_user/$que_name";
              exit 1;
           fi
           que_vote=0;

	   tmpfile=~/.question/tmp
           for usr in $(cat $all_user); do
               vote_file=/home/$usr/.question/votes/$que_user/$que_name
              [ -f "$vote_file" ] &&  usr_que_vote=$(cat $vote_file | egrep "^up$|^down$" | tail -1)
              if [ -z != $usr_que_vote ];then
               if [ $usr_que_vote == "up" ]; then
                  que_vote=$((que_vote+1));
               elif [ $usr_que_vote == "down" ]; then
                  que_vote=$((que_vote-1));
               fi
              fi

             #  cat $vote_file
           done 
           arg_usr_que=$(cat /home/$que_user/.question/questions/$que_name)
           echo $que_vote
           echo $arg_usr_que
           echo "===="
            
           [ -f "$tmpfile" ] && rm $tmpfile
           for usr in $(cat $all_user); do
               vote_file=/home/$usr/.question/votes/$que_user/$que_name
            [ -f "$vote_file" ] && awk -v tmp="$tmpfile" '
                   {if (NF == 2){
	      	      if ($1 =="up") { ans_vote[$2] = 1;}
                      else if ($1 == "down") { ans_vote[$2] = -1; }
	           }
		  }
                   END{
		       for (name in ans_vote){ print ans_vote[name],name >> tmp}
		   }
               ' $vote_file
           done
        
           tmpfile2=~/.question/tmp2
           [ -f "$tmpfile2" ] && rm $tmpfile2
           awk -v tmp2="$tmpfile2" '
               {ans_vote_count[$2] = ans_vote_count[$2] + $1;}
               END { for (name in ans_vote_count){
                         print ans_vote_count[name],name >> tmp2}
               }
               ' $tmpfile
           [ -f "$tmpfile" ] && rm $tmpfile

           while read line
           do 
              a_urs=$(echo $line | cut -d\  -f2 | cut -d/ -f1)
              a_aname=$(echo $line | cut -d\  -f2 | cut -d/ -f2)
              answer=$(cat /home/$a_urs/.question/answers/$que_user/$que_name/$a_aname)
              echo $line
              echo $answer
              echo "===="
           done <$tmpfile2

           [ -f "$tmpfile2" ] && rm $tmpfile2

       done   

       ;;



  *)
     echo "no such option exists (create|answer|vote|list|view): $1"
     ;;

esac





