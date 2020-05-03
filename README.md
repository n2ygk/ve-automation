# VE Automation tools

Here are just a few (one?) tools for automating our VE Session:

## CSCE.sh

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



