#!/usr/bin/env bash
set -euo pipefail

# 1. sysdev → MKHUGE
printf "login sysdev\r\nsystem\r\nRUNCOM MKHUGE\r\nlogout\r\n" | telnet 0 7094

# 2. slip → MAKE
until nc -z -w1 localhost 7094; do sleep 1; done
printf "login slip\r\nslip\r\nRUNCOM MAKE\r\nlogout\r\n" | telnet 0 7094

# 3. eliza → MAKE
until nc -z -w1 localhost 7094; do sleep 1; done
printf "login eliza\r\neliza\r\nRUNCOM MAKE\r\nlogout\r\n" | telnet 0 7094

# 4. eliza → R ELIZA
until nc -z -w1 localhost 7094; do sleep 1; done
printf "login eliza\r\neliza\r\nR ELIZA\r\nlogout\r\n" | telnet 0 7094

# 5. Send script number 100
printf "100\r\n" | telnet 0 7094
