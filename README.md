Compile and run Joseph Weizenbaum's original 1965 code for
[ELIZA](https://sites.google.com/view/elizaarchaeology/home) on
[CTSS](https://en.wikipedia.org/wiki/Compatible_Time-Sharing_System),
using the s709 IBM 7094 emulator.

* [elizagen.org blog
  post](https://sites.google.com/view/elizagen-org/blog/eliza-reanimated)
* [Video demo](https://youtu.be/j5Tw-XVcsRE)

## Prerequisites

You will need a Unix like environment that can compile C code and run
Python and shell scripts. This has been tested on

* Arch Linux
* Debian
* MacOS

but may work on other Unix/Linux flavours.

You will also need the `telnet` command line program or a GUI telnet
client.

## Quickstart

If you just want to try ELIZA, follow the below steps to bring up CTSS
and get ELIZA compiled and running. If you'd like to find out more
about each step, see [`HACKING.md`](HACKING.md).

1. Fetch this repo and set up the environment.

```
$ git clone https://github.com/rupertl/eliza-ctss.git
$ cd eliza-ctss
$ source env.sh
$ make-binaries
$ make-disks
```

2. The next two commands will prompt you to press Enter a number of
times and then `q` to quit.

```
$ format-disks
$ install-disk-loader
```

3. Continue installing CTSS and the ELIZA source.

```
$ installctss
$ add-eliza-users
$ upload-all
```

4. Start CTSS by typing `runctss`
5. Open another window and ensure you have a telnet client - eg via
   `sudo apt install telnet` on Debian/Ubuntu or `brew install telnet`
   on MacOS.
6. Type `telnet 0 7094`
7. Type `login slip` and give the password `slip`
8. The screen should now look something like

```
$ telnet 0 7094
Trying 0.0.0.0...
Connected to 0.
Escape character is '^]'.
s709 2.4.1 COMM tty0 (KSR-37) from 127.0.0.1

MIT8C0: 1 USER AT 12/22/14 1326.3, MAX = 30
READY.

login slip
W 1326.3
Password
 M1416    11 LOGGED IN  12/22/14 1326.3 FROM 700000
 LAST LOGOUT WAS  12/22/14 1100.6 FROM 700000
 HOME FILE DIRECTORY IS M1416 SLIP

THIS IS A RECONSTRUCTED CTSS SYSTEM.
IT IS A DEBUG AND NOT FULLY FUNCTIONAL VERSION.

 CTSS BEING USED IS: MIT8C0
R .050+.000
```
9. Type `runcom make`
10. A long series of compile messages should follow, ending with it
    printing `MAKE HAS BEEN RUN `
11. Type `login eliza` and give the password `eliza`
12. Type `runcom make` again and wait for the `MAKE HAS BEEN RUN`
    message.
13. Type `r eliza`
14. Give the answer `200` to the prompt of which script to use
15. ELIZA will print a greeting and you can now interact with her.
    Keep your responses below 72 characters and press Enter twice to
    submit. This is how your screen could look after a first response.

```
r eliza
W 1331.5
EXECUTION.
WHICH SCRIPT DO YOU WISH TO PLAY
200
HOW DO YOU DO . PLEASE TELL ME YOUR PROBLEM
INPUT
Men are all alike.

IN WHAT WAY
INPUT
```

16. When you are finished, press `Control-\ ` (backslash) to interrupt and then
    type `logout`.
18. Shut down CTSS cleanly. You will need to switch back to the 
    *main emulator window* you started earlier - this cannot be done 
    from the telnet session.

Execute the following, pressing Enter after each non Control-C line.

* Press Control-C
* Type `ek 40017`
* Type `st`
* Press Control-C
* Type `ek 0`
* Type `st`
* Press Control-C
* Type `ek 40032`
* Type `st`
* Type `q` and Enter to exit.

19. If you want to run ELIZA again, do `runctss` and then telnet in as
user `ELIZA` and `r eliza` like before.

For more details on any of these steps, and to find out how to make
changes to the source code, see [`HACKING.md`](HACKING.md).

## Known bugs and issues

The goal of this repository is to get ELIZA running in its original
form with as few modifications as possible. There are missing features
and bugs from the original code: see
[`KNOWN-ISSUES.md`](KNOWN-ISSUES.md) for details.

## Sources and licences

The ELIZA and SLIP library code under `eliza/` is from the source code
[printout](https://sites.google.com/view/elizagen-org/original-eliza)
which was found among Weizenbaum's papers at MIT by Jeff Shrager and
the MIT archivists, and
[transcribed](https://github.com/jeffshrager/elizagen.org/tree/master/1965_Weizenbaum_MAD-SLIP)
by Anthony Hay and Arthur Schwarz respectively. Weizenbaum's estate
has kindly agreed for this to be open sourced under a [Creative
Commons CC0 public domain
license](https://creativecommons.org/publicdomain/zero/1.0/). About 4%
of the SLIP library were missing in the original printout; these were
re-implemented by Anthony, Arthur and Rupert Lane and are found in
`eliza/src/SLIP/SLIP-reconstructed` with tests in `SLIP-tests`. This
newer work is also licenses as CC0.

The s709 emulator, ctss-kit and utilities under `ctss/` are from Dave
Pitts' [IBM 7090/7094 page](https://cozx.com/dpitts/ibm7090.html),
based on previous work on s709 by Paul Pierce, with minor
modifications by Rupert. This uses the MIT license, see
[LICENSE.txt](ctss/LICENSE.txt).

CTSS environment set up, upload and runcom scripts are by Rupert,
licensed as CC0.

The ELIZA script
[`eliza/src/ELIZA/tape.200`](eliza/src/ELIZA/tape.200) is adapted from
Weizenbaum's article for the _Communications of the ACM_ in 1966.

## Acknowledgements

Thanks to everyone on [Team
ELIZA](https://sites.google.com/view/elizaarchaeology/team?authuser=0)
for their help and advice,

## Questions, bugs etc

Please raise an issue/pull request if you see any problems, or email
me at rupert@timereshared.com
