This is the README that is included in the generated archive file
eliza-tape
==========

This archive contains a virtual tape file of Eliza source which can be
used to compile, build and run Eliza on an existing s709 install of
CTSS.

It is intended for existing experienced users of s709. If you are new to this
and want a quick way to set everything up, see https://github.com/rupertl/eliza-ctss .

Prerequisites
-------------

Ensure you have s709, utilities and ctss-kit from
https://cozx.com/dpitts/ibm7090.html built and working successfully,
ie you are able to start CTSS and login.

Installation
------------

1. Set up a new user account to hold the files. 

$ adduserctss eliza 10 eliza

2. Load the files into CTSS

$ setupctss eliza.img

3. Start CTSS with runctss

4. If you have not done so before, ensure the huge loader L has been
   created. Login to CTSS as user sysdev password system and run
   RUNCOM MKHUGE.

5. Login as user eliza password eliza

6. Execute RUNCOM MAKE

Eliza has now been compiled and saved as file ELIZA SAVED.

Running
-------

1. Start Eliza with R ELIZA and give the value 100 to the script
   prompt

2. You can now enter responses to Eliza's prompts. Keep within 72
   columns, but you can type multiple lines, pressing Enter to go to
   the next line. Press Enter at the start of a new line to send to
   Eliza.

3. When you are finished, type Control-\ to exit

License
-------

All code in this tape is license under the Creative Commons CC0 public domain
license: https://creativecommons.org/publicdomain/zero/1.0/.

Support and questions
---------------------

There is additional information about the reconstruction, use and
known bugs of Eliza at
https://github.com/rupertl/eliza-ctss/blob/main/README.md

For any problems, please raise an issue at
https://github.com/rupertl/eliza-ctss/issues (mentioning you are using
the eliza-tape version) or email rupert@timereshared.com

Version
-------

This tape corresponds to revision <HASH> of https://github.com/rupertl/eliza-ctss dated <DATE>.
