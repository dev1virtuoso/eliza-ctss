There are missing features and bugs from the original code; we do not
intend to fix these. But feel free to fork this repo and try to make
an even better ELIZA!

## Bugs

1. Numerical input, eg prompting ELIZA with `I have 99 bugs to fix
   today` may cause ELIZA to crash or hang. It looks like ELIZA/SLIP
   reads numbers correctly from input, but does not know how to print
   them when outputting her response.

## Missing features

These are described in the 1966 CACM ELIZA paper but are not
implemented in the source code, so you will see these if you use
script 200.

1. The preliminary transformation `PRE` reassembly pattern, e.g. as used in

```
(I'M = YOU'RE
    ((0 YOU'RE 0)
        (PRE (YOU ARE 3) (=I))))
```

2. The keyword stack and the `NEWKEY` reassembly rule, as used in

```
(DREAMT 4
    ((0 YOU DREAMT 0)
        (REALLY, 4)
        (HAVE YOU EVER FANTASIED 4 WHILE YOU WERE AWAKE)
        (HAVE YOU DREAMT 4 BEFORE)
        (=DREAM)
        (NEWKEY)))
```

3. Links to other rules at the reassembly rule level. The source code supports links at the transformation rule level, e.g.

```
(HOW
    (=WHAT))
```
