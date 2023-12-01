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
                           add 1 to CHARINDEX
                       end-if
                   end-perform.
                   
                   perform until CHARINDEX=CHARCOUNT
                       set CURRENTCHAR to CURRENT-LINE(CHARINDEX:1)
                       if CURRENTCHAR numeric
                           set LASTD to CURRENTCHAR
                       end-if
                       add 1 to CHARINDEX
                   end-perform.
                   
                   string FIRSTD, LASTD into LINEVALUE.
                   add LINEVALUE to TOTAL.
                   