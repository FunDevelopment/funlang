/--
 --  bento2fun.fun
 --
 --  Converts bento source files to fun source files
 --
 --  For each Bento file does the following:
 --
 --    * creates new Fun file
 --    * loads lines from Bento file
 --    * processes each line and writes to Fun file
 --    * swap [| and |] with [/ and /], and vice versa
 --    * keep track of entering and exiting data blocks
 --    * swap [= and =] with { and } outside of data blocks
 --    * swap [= and =] with {= and =} inside of data blocks
 --/
 
 script bento2fun {
 
     public main(args[]) {
         bentofile = args[0]
     
         if (args.count < 2) {
             "Usage: bento2fun bentofile\n";
             exit(1);
         } else {
             "Called with bento file: ";
             bentofile;
         }
         convert(bentofile);
         exit(0);
     }
     
     convert(bentofile) {
         funfile = ends_with(bentofile, ".bento") ? replace(bentofile, ".bento", ".fun") : (bentofile + ".fun") 
         bento_lines[] = lines_from_file(bentofile)
         fun_lines[] = [
             for line in lines {
                 log(line);
             }
         ]
     }
 }
 
 
 
 