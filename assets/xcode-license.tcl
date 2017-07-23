#!/usr/bin/expect -f
# Mac OS X has `expect` preinstalled.

# Slowly.
# Copied from autoexpect.
set force_conservative 1
if {$force_conservative} {
    set send_slow {1 .1}
    proc send {ignore arg} {
        sleep .1
        exp_send -s -- $arg
    }
}


spawn sudo xcodebuild -license

expect "Hit the Enter key"
send "\r"
# Go to end.
send -- "\[4~"
expect "[agree, print, cancel"
send "agree\r"
