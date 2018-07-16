Words in common in two sentences

This uses FCMP subroutive on the end of message.
The FCMP pops the first word off a sentence and removes the first word from input string..

WPS does not support FCMP yet.

INPUT
=====

 SD1.HAVE total obs=2

  STR1                                          STR2

  to be or not to be                            2 b or not 2 b
  every good deed results in a better person    good better best never let it rest
                                                until good is better and better is best


EXAMPLE OUTPUT  (Intersecting or common words)
-----------------------------------------------

 WORK.WANT total obs=2 (Words in common between str1 and str2)

    INTERSECT           CNTWRDS

    or not                 2
    good better best       3


PROCESS
=======

   data want;

    length pop1st intersect $200 ;
    call missing(pop1st,intersect);

    set sd1.have;

    do wrds=1 to countw(str1);
      call utl_pop(str1,pop1st,"first");
      if indexw(str2,pop1st)>0 then intersect=catx(' ',intersect,pop1st);
    end;

    cntWrds=countw(intersect);
    keep intersect cntWrds;

   run;quit;


OUTPUT
======

 WORK.WANT total obs=2

   INTERSECT

   or not
   good better

*                _               _       _
 _ __ ___   __ _| | _____     __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \   / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/  | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|   \__,_|\__,_|\__\__,_|

;

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
   length str1 str2 $200;
   str1="to be or not to be";
   str2="2 b or not 2 b";
   output;
   str1="every good deed results in a better or best person";
   str2="good better best never let it rest until good is better and better is best";
   output;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

see process


* __
 / _| ___ _ __ ___  _ __    _ __   ___  _ __
| |_ / __| '_ ` _ \| '_ \  | '_ \ / _ \| '_ \
|  _| (__| | | | | | |_) | | |_) | (_) | |_) |
|_|  \___|_| |_| |_| .__/  | .__/ \___/| .__/
                   |_|     |_|         |_|
;


options cmplib=work.funcs;
proc fcmp outlib=work.funcs.temp;
Subroutine utl_pop(string $,word $,action $);
    outargs word, string;
    length word $200;
    select (upcase(action));
      when ("LAST") do;
        call scan(string,-1,_action,_length,' ');
        word=substr(string,_action,_length);
        string=substr(string,1,_action-1);
      end;

      when ("FIRST") do;
        call scan(string,1,_action,_length,' ');
        word=substr(string,_action,_length);
        string=substr(string,_action + _length);
      end;

      otherwise put "ERROR: Invalid action";

    end;
endsub;
run;quit;

