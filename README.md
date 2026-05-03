Compile and run Joseph Weizenbaum's original 1965 code for
[ELIZA](https://sites.google.com/view/elizaarchaeology/home) on
[CTSS](https://en.wikipedia.org/wiki/Compatible_Time-Sharing_System),
using the s709 IBM 7094 emulator.

* [elizagen.org blog post](https://sites.google.com/view/elizagen-org/blog/eliza-reanimated)
* [Video demo](https://youtu.be/j5Tw-XVcsRE)
* [Paper](http://arxiv.org/abs/2501.06707)

See the Prerequisites and Quickstart section below to begin.

Alternative ways to get ELIZA:

* [Automated setup](docker/DOCKER-README.md) using Docker.
* Add to an existing CTSS installation via a [virtual tape file](https://timereshared.com/files/ctss/eliza/).

Updating from an older version? See [`UPDATING.md`](UPDATING.md).  
*Note: the new Quickstart includes a step where you need to log in as `sysdev`.*

## Prerequisites

You will need a Unix‑like environment that can compile C code and run
Python and shell scripts. This has been tested on

* Arch Linux
* Debian
* MacOS

but may work on other Unix/Linux flavours.

You will also need the `telnet` command‑line program or a GUI telnet
client. The command‑line program can be installed by `sudo apt install telnet`
on Debian/Ubuntu or `brew install telnet` on MacOS.

## Quickstart

**You can get everything set up with one of the two auto‑install
scripts.**

### macOS / Linux

```sh
git clone https://github.com/rupertl/eliza-ctss.git
cd eliza-ctss

chmod +x auto-install.sh
./auto-install.sh
```

The script will:

* create an `env.sh` that matches the shipped file,
* create the required directories (`dasd`, `output`, `tmp`),
* (optionally) download and unpack the s709 emulator, ctss‑kit, and utilities if they are missing,
* print a short “next‑steps” guide.

After that run:

```sh
source env.sh
make-binaries
make-disks
```

### Windows (PowerShell)

```powershell
git clone https://github.com/rupertl/eliza-ctss.git
cd eliza-ctss

Set-ExecutionPolicy RemoteSigned -Scope Process   # run once per PowerShell session

.\auto-install.ps1
```

The PowerShell script does the same work as the Bash one, it creates
`env.ps1`, the directories, and pulls in the emulator & kit if needed.
After that run:

```powershell
.\env.ps1
make-binaries
make-disks
```

### The rest of the manual

If you prefer to stay in the manual‑style steps, keep reading the
original “Quickstart” that follows – it explains how to format disks,
install CTSS, add users, upload source, start CTSS, telnet in, run ELIZA,
and shut down cleanly.  
All of that remains unchanged; the only difference is the short
`auto‑install` helper you just ran.

## Where to go next

If you would like to try different personality scripts for ELIZA, read
[`SCRIPTS.md`](SCRIPTS.md).

To learn more about compiling ELIZA, and how to make your own changes
to the source code, see [`HACKING.md`](HACKING.md).

If you would like to read more about the process of reconstructing the
code from the printouts, see
[`RECONSTRUCTION-CARD.md`](RECONSTRUCTION-CARD.md).

To find out more about CTSS, see my blog post series at
[timereshared.com](https://timereshared.com/ctss/).

## Known bugs and issues

The goal of this repository is to get ELIZA running in its original
form with as few modifications as possible. There are missing features
and bugs from the original code: see
[`KNOWN-ISSUES.md`](KNOWN-ISSUES.md) for details.

## Sources and licences

The ELIZA and SLIP library code under `eliza/` is from the source code [printout](https://sites.google.com/view/elizagen-org/original-eliza) which was found among Weizenbaum's papers at MIT by Jeff Shrager and the MIT archivists, and [transcribed](https://github.com/jeffshrager/elizagen.org/tree/master/1965_Weizenbaum_MAD-SLIP) by Anthony Hay and Arthur Schwarz respectively. Weizenbaum's estate has kindly agreed for this to be open sourced under a [Creative Commons CC0 public domain license](https://creativecommons.org/publicdomain/zero/1.0/). About 4% of the SLIP library were missing in the original printout; these were re-implemented by Anthony, Arthur and Rupert Lane and are found in `eliza/src/SLIP/SLIP-reconstructed` with tests in `SLIP-tests`. This newer work is also licenses as CC0.

The s709 emulator, ctss-kit and utilities under `ctss/` are from Dave Pitts' [IBM 7090/7094 page](https://cozx.com/dpitts/ibm7090.html), based on previous work on s709 by Paul Pierce, with minor modifications by Rupert. This uses the MIT license, see [LICENSE.txt](ctss/LICENSE.txt).

CTSS environment set up, upload and runcom scripts are by Rupert, licensed as CC0.

The ELIZA script [`eliza/src/ELIZA/tape.200`](eliza/src/ELIZA/tape.200) is adapted from Weizenbaum's article for the _Communications of the ACM_ in 1966.

The [Docker automation](docker/DOCKER-README.md) was contributed by [@MarquisdeGeek](https://github.com/MarquisdeGeek)

## Acknowledgements

Thanks to everyone on [Team ELIZA](https://sites.google.com/view/elizaarchaeology/team?authuser=0) for their help and advice,

## Questions, bugs etc

Please raise an issue/pull request if you see any problems, or email me at rupert@timereshared.com