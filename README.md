# utl_words_in_common_in_two_sentences
Words in common in two sentences.  Keywords: sas sql join merge big data analytics macros oracle teradata mysql sas communities stackoverflow statistics artificial inteligence AI Python R Java Javascript WPS Matlab SPSS Scala Perl C C# Excel MS Access JSON graphics maps NLP natural language processing machine learning igraph DOSUBL DOW loop stackoverflow SAS community.

    Words in common in two sentences

    This uses FCMP subroutive on the end of message.
    The FCMP pops the first word off a sentence and removes the first word from input string..

    WPS does not support FCMP yet.
    
    see nice hash solution in end by
    Bartosz Jablonski's profile photo
    yabwon@gmail.com

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
    
    


    *____             _
    | __ )  __ _ _ __| |_
    |  _ \ / _` | '__| __|
    | |_) | (_| | |  | |_
    |____/ \__,_|_|   \__|

    ;

    Roger,

    If I may, one more solution, the hash way.

    all the best
    Bart

    /* the code */

    data have;
       length str1 str2 $200;
       str1="to be or not to be";
       str2="2 b or not 2 b";
       output;
       str1="every good deed results in a better or best person";
       str2="good better best never let it rest until good is better and better is best";
       output;
    run;quit;


    data want;

    dcl hash h () ;
      h.definekey ("word") ;
      h.definedata ("word", "count") ;
      h.definedone ();

    do until(eof);
    h.clear();

    set have end = eof;

    count = 0;
    do i=1 to countw(str1);
     word = scan(str1, i);
     if h.find() then h.add();
    end;

    do i=1 to countw(str2);
     word = scan(str2, i);
     if h.find() = 0 then do; count = 1; h.replace(); end;
    end;


    declare hiter ih('h');
    count_of_common=0; length common_words $ 200; common_words = "";

    _rc_ = ih.first();
    do while(_rc_ = 0);
        if count then do;
                        common_words = catx(" ", common_words, word);
                        count_of_common +1;
                      end;
        _rc_ = ih.next();
    end;
    output;
    /*
    h.output(dataset: "d"!!strip(put(_N_, best.))!!"(where=(count))" );
    _N_+1;
    */
    end;

    stop; keep str1 str2 common_words count_of_common;
    run;




