#!/bin/bash

directory_check=$(ls -lah $(pwd) | grep ^d  | wc -l)
commandslist=('sudo apt update' 'sudo apt upgrade -y' 'sudo apt autoremove')
mirrors=('git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git' 'git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git')
cmd_connectivity="ping google.com -c1 &> /dev/null"
cmd_single_instance="pidof -x $(basename $0) &> /dev/null"

update_ubuntu(){
	for i in "${commandslist[@]}"; do
		eval $i
		status=$?
		echo "The ubuntu update command ended with status $status at $(date)" >> log.txt
	done
}

update_mirrors(){
	for i in "${mirrors[@]}"; do
		if [ $directory_check -gt 0 ]; then
			echo "$dir is not empty"
			git init
			git pull $i
			status=$?
			echo "The mirror update command ended with status $status at $(date)" >> log.txt

		else
			echo "$dir is empty"
			git init
			git clone $i
			git pull $i
			status=$?
		echo "The mirror clone and update commands ended with status $status at $(date)" >> log.txt
		fi
	done
}

check_connectivity(){
	for i in {1..5}; do
		eval $cmd_connectivity
		status=$?
		echo "Network check command ended with status $status at $(date)" >> log.txt

	if [ $status -eq 0 ]
	then
		echo "Connectivity OK"
		return 0
	fi

	echo "Connectivity NOK($cmd_connectivity), trying to recconect($i)..."
	sleep 20
done

echo "Connectivity NOK, exiting!"
exit 1
}

check_single_instance(){
	for pid in $($cmd_single_instance); do
	if [ $pid != $$ ]; then
		echo "[$(date)] : $(basename $0): Process is already running with PID $pid"
		exit 1
	fi
	done
}
check_statuses(){
	cat log.txt | tail -6
}
check_connectivity
check_single_instance
update_ubuntu
update_mirrors
check_statuses
