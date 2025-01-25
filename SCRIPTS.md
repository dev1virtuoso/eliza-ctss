At run time, ELIZA reads in a script identified by a number. These
contain definitions of what keywords ELIZA recognises and how she
should respond, representing a personality. These are text files using
s-expressions, for example the start of one such file looks like:

```
(HOW DO YOU DO.  I AM THE DOCTOR.  PLEASE SIT DOWN AT THE TYPEWRITER
AND TELL ME YOUR PROBLEM.)

(IF 3
    ((0 IF 0)
        (DO YOU THINK ITS LIKELY THAT 3)
        (DO YOU WISH THAT 3)
        (WHAT DO YOU THINK ABOUT 3)
        (REALLY, 2 3)))

(HOW
    (=WHAT))
```

There are several such files in existence - we chose two to include in
this reconstruction.

- `.TAPE. 100` from the ELIZA printout.
- The CACM paper example which we named `.TAPE. 200`

100 is from the same time frame as the code, so everything should work
as expected. We believe 200 was developed a little later, and hence
does not match exactly what the source code expects. See
[`etc/running-eliza.txt`](etc/running-eliza.txt) for a comparison and
[`KNOWN-ISSUES.md`](KNOWN-ISSUES.md) for an analysis of some of the
missing features.

See also Anthony Hay's [blog
post](https://sites.google.com/view/elizaarchaeology/blog/8-the-doctor-script-a-work-in-progress?authuser=0)
analysing script 100 in more detail, and the
[collection](https://github.com/anthay/ELIZA/blob/master/scripts/scripts.md)
of scripts he has put together.
