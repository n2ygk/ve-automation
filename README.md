# VE Automation tools

Here are just a few (one?) tools for automating our VE Session:

## pdfcat

This is just a simple shell script that invokes Ghostscript to concatenate multiple PDF files.

Example usage:

```text
$ ./pdfcat package.pdf report-20200527.pdf session-20200527.pdf VE-20200527.pdf CSCE-JohnDoe-4.pdf  605-JohnDoer-4.pdf answers-JohnDoe.pdf answers-JohnPublic.pdf CSCE-JaneDoe-4.pdf 605-JaneDoe-4.pdf answers-JaneDoe.pdf
GPL Ghostscript 9.52 (2020-03-19)
Copyright (C) 2020 Artifex Software, Inc.  All rights reserved.
This software is supplied under the GNU AGPLv3 and comes with NO WARRANTY:
see the file COPYING for details.
Processing pages 1 through 1.
Page 1
...
$
```

## CSCE.sh

**N.B.** As of 5/26/20 we are using Examtools v2 which incorporates form signing into the app. This is no
longer needed.

![alt-text](./CSCE_sample.png "Sample filled-in CSCE form")

Uses [Ghostscript](https://www.ghostscript.com/) to annotate an ARRL/VEC CSCE PDF form,
adding the following fields which are filled in from these environment variables:

* SITE: Test site
* DATE  Test session date
* VE1: Volunteer Examiner
* VE2: Volunteer Examiner
* VE3: Volunteer Examiner
* CALL: Candidate callsign or NONE
* FIRST: First name
* MIDDLE: Middle initial
* LAST: Last name
* SUFFIX: Suffix (Jr, III, etc.)
* ADDR: Street address
* CITY: City
* STATE: 2-digit state (NY)
* ZIP: zip code
* EARNED: T|G|E for Tech, General, Extra
* PASS2: X if passed element 2
* PASS3: X if passed element 3
* PASS4: X if passed element 4
* CRED: X if credit for element 3
* CRED: X if credit for element 4

Any blank values need not be set.

The generated CSCE is named CSCE-_firstlast_-1.pdf

See testscript.sh for an example invocation.

```text
$ ./testscript.sh 
CSCE-JohnDoe-1.pdf
```

### How it works

1. Obtain an official ARRL/VEC CSCE PDF form from the VEC.
2. Use pdf2ps to convert (back) to PostScript.
3. Sets the EPSF2Write flag to False so that the annotations get added on the same page.
4. Annotates with some simple PostScript tacked on to the end of the file:
   ```
   gsave
   0 0 255 setrgbcolor
   /Helvetica findfont 14 scalefont setfont
   newpath
   100 325 moveto ($SITE) show
   ...
   grestore
   ```

