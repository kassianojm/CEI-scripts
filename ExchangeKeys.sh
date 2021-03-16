#!/bin/bash


if [ -z "$1" ]; 
then
       	echo "Set a user to exchange keys! The user need to be the same for every node" 
	exit
fi


update-local-key () {
  user=$2
  nodefile=$1
  echo "updating keys from local node to the allocated ones"
  for i in `cat $nodefile`;
  do	
  	echo "CMD: ssh-keygen -f "/home/$USER/.ssh/known_hosts" -R $i"
	ssh-keygen -f "/home/$USER/.ssh/known_hosts" -R $i 
  done
}

exchange-keys(){
  nodefile=$1
  user=$2

  update-local-key $nodefile $user
  #creating folder for the key
  if [ ! -d "key" ];then
	mkdir -p key
  fi
  
  for i in `cat $nodefile`;
  do
	
	#creating keys overall nodes
	ssh $user@$i "if [ -f ~/.ssh/id_rsa ]; then mv ~/.ssh/id_rsa ~/.ssh/id_rsa_old; ssh-keygen -N '' -t rsa -f ~/.ssh/id_rsa; else ssh-keygen -N '' -t rsa -f ~/.ssh/id_rsa; fi"
  	ssh $user@$i "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys;chmod og-wx ~/.ssh/authorized_keys"
  done


  for i in `cat $nodefile`;
  do
    CNode=$i
    cat ssh_config | ssh $user@$i "cat >> ~/.ssh/config"
    for probe in `cat $nodefile`;
    do
	rm -rf key/*
	#excluding current node from itsel key copy
	if [ "$probe" != "$CNode" ]; then
		echo "Copying key from $CNode to $probe"
		scp -r $user@$CNode:~/.ssh/id_rsa.pub key/
		cat key/id_rsa.pub | ssh $user@$probe "cat >> ~/.ssh/authorized_keys"
	fi
    done
  done
  rm -rf key/

}


echo "Full script to exchange keys starting..."

update-local-key nodefile $1
exchange-keys nodefile $1



