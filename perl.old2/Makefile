BASE=/home/richard/tmp/wa/
WW2=/home/richard/tmp/v2/

all:
	perl weball.pl --input=test.js --outdir=$(BASE) --htmldir=$(BASE)/html/ --lib=$(BASE)/lib/ --dbname=ww2game_dev --u=root --p=TrisP2 --lang=php,sql
	
v2:
	perl weball.pl --input=ww2.js --outdir=$(WW2) --htmldir=$(WW2)/html/ --lib=$(WW2)/lib/ --dbname=ww2game_dev --u=root --p=TrisP2 --lang=php,sql

