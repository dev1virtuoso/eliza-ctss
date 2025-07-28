#!/usr/bin/expect
spawn bash
send "runctss\r"
expect "s709" { send "\x03" } ;# Control-C
expect "s709>" { send "ek 40017\r" }
expect "s709>" { send "st\r" }
expect "s709>" { send "\x03" }
expect "s709>" { send "ek 0\r" }
expect "s709>" { send "st\r" }
expect "s709>" { send "\x03" }
expect "s709>" { send "ek 40032\r" }
expect "s709>" { send "st\r" }
expect "s709>" { send "q\r" }
expect eof
