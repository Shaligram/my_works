echo "Input params $1"
if [ $1 ] 
then
#  p4 open $1
  #| sed -e 's/#.*//' 
  if [ "$1" == "1" ] 
  then
    echo -e "List of local files:\n" ;
    find . -type f | grep -v class$ | p4 -x - have > /dev/null; 
    echo -e "\nList of to be added files: reconcile-n:";
    p4 reconcile -n ... ; 
    echo -e "\nList of opened files:`p4 opened ... | wc -l`\n";
    p4 opened ...
    echo -e "\nList of open & modified files:`p4 diff -f -sa ... | wc -l`\n";
  elif [ "$1" == "2" ] 
  then
    p4 diff -f -sa ...
  else
    p4 diff $1
  fi


else
  #echo -e "List of local files:\n" ;
  #find . -type f | grep -v class$ | p4 -x - have > /dev/null; 
  #echo -e "\nList of to be added files: reconcile-n:";
  #p4 reconcile -n ... ; 
  echo -e "\nList of opened files:`p4 opened ... | wc -l`\n";
  p4 opened ...
  echo -e "\nList of open & modified files:`p4 diff -f -sa ... | wc -l`\n";
  p4 diff -f -sa ...
fi
