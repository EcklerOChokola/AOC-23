           * To run online on 
           * https://www.jdoodle.com/execute-cobol-online/
           * modify the filename at line 14 from 
           * 'input.txt' to '/uploads/input.txt'
           * and upload the input.txt file
           identification division.
               program-id. first.
               author. eckler.
               date-written. 01/12/2023.

           environment division.
               input-output section.
                   file-control.
                   select INPUTFILE assign to 'input.txt'
                   organization is line sequential. 
           
           data division.
               file section.
               fd INPUTFILE.
               01 INPUT-FILE   pic X(64).

               working-storage section.
               01 CURRENT-LINE pic X(64).
               01 CHARINDEX    pic 9(2).
               01 CHARCOUNT    pic 9(2).
               01 CURRENTCHAR  pic X.
               01 CURRENTBUF   pic X(10).
               01 FIRSTD       pic 9.
               01 LASTD        pic 9.
               01 LINEVALUE    pic 9(2).
               01 TOTAL        pic 9(5).
               01 FIRSTREACHED pic A.
               01 EOLREACHED   pic A.
               01 EOFREACHED   pic A.
           
           procedure division.
               open input INPUTFILE.
                   perform until EOFREACHED='T'
                       read INPUTFILE into CURRENT-LINE
                           AT END move 'T' to EOFREACHED
                           NOT AT END perform READ-LINE
                       END-READ
                   END-PERFORM.
               close INPUTFILE.
               display "TOTAL : "TOTAL.
               stop run.

               READ-LINE.
                   move 0 to CHARCOUNT.
                   inspect CURRENT-LINE TALLYING CHARCOUNT
                       for characters
                       before X"00".
                   set CHARINDEX to 1.
                   set EOLREACHED to 'F'.
                   set FIRSTREACHED to 'F'.
                   perform until CHARINDEX=CHARCOUNT or FIRSTREACHED='T'
                       set CURRENTCHAR to CURRENT-LINE(CHARINDEX:1)
                       if CURRENTCHAR numeric
                           set FIRSTD to CURRENTCHAR
                           set FIRSTREACHED to 'T'
                       else
                       if CURRENT-LINE(CHARINDEX:3)="one"
                           set FIRSTD to 1
                           set FIRSTREACHED to 'T'
                       else
                       if CURRENT-LINE(CHARINDEX:3)="two"
                           set FIRSTD to 2
                           set FIRSTREACHED to 'T'
                       else
                       if CURRENT-LINE(CHARINDEX:5)="three"
                           set FIRSTD to 3
                           set FIRSTREACHED to 'T'
                       else
                       if CURRENT-LINE(CHARINDEX:4)="four"
                           set FIRSTD to 4
                           set FIRSTREACHED to 'T'
                       else
                       if CURRENT-LINE(CHARINDEX:4)="five"
                           set FIRSTD to 5
                           set FIRSTREACHED to 'T'
                       else
                       if CURRENT-LINE(CHARINDEX:3)="six"
                           set FIRSTD to 6
                           set FIRSTREACHED to 'T'
                       else
                       if CURRENT-LINE(CHARINDEX:5)="seven"
                           set FIRSTD to 7
                           set FIRSTREACHED to 'T'
                       else
                       if CURRENT-LINE(CHARINDEX:5)="eight"
                           set FIRSTD to 8
                           set FIRSTREACHED to 'T'
                       else
                       if CURRENT-LINE(CHARINDEX:4)="nine"
                           set FIRSTD to 9
                           set FIRSTREACHED to 'T'
                       else
                       if CURRENT-LINE(CHARINDEX:4)="zero"
                           set FIRSTD to 0
                           set FIRSTREACHED to 'T'
                       else 
                           add 1 to CHARINDEX
                       end-if
                       end-if
                       end-if
                       end-if
                       end-if
                       end-if
                       end-if
                       end-if
                       end-if
                       end-if
                       end-if
                   end-perform.
                   
                   perform until CHARINDEX=CHARCOUNT
                       set CURRENTCHAR to CURRENT-LINE(CHARINDEX:1)
                       if CURRENTCHAR numeric
                           set LASTD to CURRENTCHAR
                       end-if
                       if CURRENT-LINE(CHARINDEX:3)="one"
                           set LASTD to 1
                       end-if
                       if CURRENT-LINE(CHARINDEX:3)="two"
                           set LASTD to 2
                       end-if
                       if CURRENT-LINE(CHARINDEX:5)="three"
                           set LASTD to 3
                       end-if
                       if CURRENT-LINE(CHARINDEX:4)="four"
                           set LASTD to 4
                       end-if
                       if CURRENT-LINE(CHARINDEX:4)="five"
                           set LASTD to 5
                       end-if
                       if CURRENT-LINE(CHARINDEX:3)="six"
                           set LASTD to 6
                       end-if
                       if CURRENT-LINE(CHARINDEX:5)="seven"
                           set LASTD to 7
                       end-if
                       if CURRENT-LINE(CHARINDEX:5)="eight"
                           set LASTD to 8
                       end-if
                       if CURRENT-LINE(CHARINDEX:4)="nine"
                           set LASTD to 9
                       end-if
                       if CURRENT-LINE(CHARINDEX:4)="zero"
                           set LASTD to 0
                       end-if
                       add 1 to CHARINDEX
                   end-perform.
                   
                   string FIRSTD, LASTD into LINEVALUE.
                   add LINEVALUE to TOTAL.
                   