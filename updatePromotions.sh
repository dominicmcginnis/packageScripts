#!/usr/bin/expect

set MODE [lindex $argv 0]
set REMOTE_HOST [lindex $argv 1]
set USER [lindex $argv 2]
set PASS [lindex $argv 3]
set FILE [lindex $argv 4]
set PUSHDIR [lindex $argv 5]

cd tmp;

### Copy down files
if { $MODE == "pull" } {
	spawn scp $USER@$REMOTE_HOST:$FILE .
	expect {
		password: { send "$PASS\r"; exp_continue}
	}
} 

### Push up files
if { $MODE == "push" } {
	spawn scp $FILE $USER@$REMOTE_HOST:/$PUSHDIR/.
	expect {
		password: { send "$PASS\r"; exp_continue}
	}
} 

