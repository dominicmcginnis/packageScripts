#!/usr/bin/expect

set MODE [lindex $argv 0]
set REMOTE_HOST [lindex $argv 1]
set USER [lindex $argv 2]
set PASS [lindex $argv 3]
set FILE [lindex $argv 4]
set PUSHDIR [lindex $argv 5]

proc do_exit {msg} {
    puts stderr $msg
    exit 1
}


### Copy down files
if { $MODE == "pull" } {
	cd tmp;

	spawn scp $USER@$REMOTE_HOST:$FILE .
	expect {
		password: { 
			send "$PASS\r"; 
			exp_continue
		}
        "Permission denied, please try again." {
            do_exit "incorrect password"
        }
        timeout {do_exit "timed out waiting for prompt"}
    }
} 

### Push up files
if { $MODE == "push" } {
	spawn scp $FILE $USER@$REMOTE_HOST:/$PUSHDIR/.
	expect {
		password: { 
			send "$PASS\r"; 
			exp_continue
		}
        "Permission denied, please try again." {
            do_exit "incorrect password"
        }
        timeout {do_exit "timed out waiting for prompt"}
    }
} 

