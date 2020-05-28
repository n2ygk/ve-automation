#!/bin/sh
# Ths script "fills in" the ARRL/VEC CSCE PDF which was supplied to you by the VEC:
TEMPLATE="CSCE_2020_Fully Interactive.pdf"

# These variables are used to fill in the form. If they are missing, nothing shows up.
# N.B. There is no error checking for missing variables.
# get these from environment:
# SITE="New York, NY"
# DATE="5/4/2020"
# VE1="W2RTC"
# VE2="N2YGN"
# VE3="KD2HLE"
# CALL="NONE"
# FIRST="John"
# MIDDLE="Q"
# LAST="Doe"
# SUFFIX="Jr"
# ADDR="123 Main St"
# CITY="Brooklyn"
# STATE="NY"
# ZIP="12345"
# EARNED="T" # T|G|E for Tech, General, Extra
# either an X for passed/earned or blank:
# PASS2="X"
# PASS3=""
# PASS4=""
# CRED3=""
# CRED4=""

# squeeze out extra spaces if no middle initial, for example.
NAME=`echo $FIRST $MIDDLE $LAST $SUFFIX`
FILENAME=`echo CSCE-${FIRST}${LAST}-1.pdf`

if [ -z "$DATE" ]; then
    echo >&2 Fill in the date.
    exit 1
fi

# now some logic to check off and cross things out
CLOBBER="==========="
case $EARNED in
    T)
	TECH="X"
	GCLOBBER=$CLOBBER
	ECLOBBER=$CLOBBER
	;;
    G)
	GEN="X"
	TCLOBBER=$CLOBBER
	ECLOBBER=$CLOBBER
	;;
    E)
	EXTRA="X"
	TCLOBBER=$CLOBBER
	GCLOBBER=$CLOBBER
	;;
    *)
	echo >&2 EARNED must be one of T, G, or E
	exit 1
	;;
esac
if [ -z "$PASS2" ]; then
    CLOBBER2=$CLOBBER
fi
if [ -z "$PASS3" ]; then
    CLOBBER3=$CLOBBER
fi
if [ -z "$PASS4" ]; then
    CLOBBER4=$CLOBBER
fi
if [ -z "$CRED3" ]; then
    CRED3CLOBBER=$CLOBBER
fi
if [ -z "$CRED4" ]; then
    CRED4CLOBBER=$CLOBBER
fi

# some more sanity checking: can't have earned a license without passing an element or having had element credit.
if [ -z "${PASS2}${PASS3}${PASS4}${CRED3}${CRED4}" ]; then
    echo >&2 'They must have passed something or come in with credit!'
    exit 1
fi

# Cache a copy of the converted PDF file.
# Tweak the EPSFlag to false so we can tack on our postscript at the end and have it render on top of the CSCE form.
if [ ! -f CSCE_template.ps ]; then
    pdf2ps "$TEMPLATE" - | sed -e 's:^/EPS2Write false def:/EPS2Write true def:' > CSCE_template.ps 
fi

# Replace this at the end of the .ps file:
#   %%Trailer
#   end
#   %%EOF
# with this:
( sed -ne '1,/^%%Trailer/p' CSCE_template.ps
  cat <<EOF
gsave
0 0 255 setrgbcolor
/Helvetica findfont 14 scalefont setfont
newpath
100 325 moveto ($SITE) show
280 325 moveto ($DATE) show
280 120 moveto ($CALL) show
110 95 moveto ($NAME) show
80 68 moveto ($ADDR) show
80 40 moveto ($CITY) show
270 40 moveto ($STATE) show
310 40 moveto ($ZIP) show
565 272 moveto ($PASS2) show
488 271 moveto ($CLOBBER2) show
565 258 moveto ($PASS3) show
488 257 moveto ($CLOBBER3) show
565 244 moveto ($PASS4) show
488 244 moveto ($CLOBBER4) show
565 220 moveto ($TECH) show
488 220 moveto ($TCLOBBER) show
565 208 moveto ($GEN) show
488 208 moveto ($GCLOBBER) show
565 196 moveto ($EXTRA) show
488 196 moveto ($ECLOBBER) show
488 184 moveto ($CLOBBER) show
510 120 moveto ($VE1) show
510 90 moveto ($VE2) show
510 60 moveto ($VE3) show
% element credit
/Helvetica findfont 10 scalefont setfont
555 302 moveto ($CRED3) show
488 302 moveto ($CRED3CLOBBER) show
555 296 moveto ($CRED4) show
488 296 moveto ($CRED4CLOBBER) show
grestore
end
%%EOF
EOF
) | ps2pdf - "$FILENAME"
echo >&2 $FILENAME

