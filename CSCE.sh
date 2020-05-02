#!/bin/sh
# convert the PDF to PostScript
# and tweak the EPSFlag to false so we can tack on our text at the end
# TOOD: get these from environment:
SITE="New York, NY"
DATE="5/4/2020"
VE1="W2RTC"
VE2="N2YGN"
VE3="KD2HLE"
CALL="NONE"
NAME="John Doe"
ADDR="123 Main St"
CITY="Brooklyn"
STATE="NY"
ZIP="12345"
EARNED="T" # T|G|E
PASS2="X"
PASS3=""
PASS4=""
CRED3=""
CRED4=""

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

if [ ! -f CSCE_template.ps ]; then
    pdf2ps CSCE_2020_Fully\ Interactive.pdf - \
	| sed -e 's:^/EPS2Write false def:/EPS2Write true def:' > CSCE_template.ps 
fi

# replace this at the end of the .ps file
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
) | ps2pdf - csce.pdf
