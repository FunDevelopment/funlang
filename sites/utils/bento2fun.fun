/--
 --  bento2fun.fun
 --
 --  Converts bento source files to fun source files
 --
 --  Works as follows:
 --
 --    * open Bento file and read past header
 --    * create new Fun file and write new header
 --    * read Bento file a line at a time 
 --    * process each line and write to Fun file
 --    * swap [| and |] with [/ and /], and vice versa
 --    * keep track of entering and exiting data blocks
 --    * swap [= and =] with { and } outside of data blocks
 --    * swap [= and =] with {= and =} inside of data blocks
 --/
 
 script bento2fun {
 
     public main(args[]) {
         bentofile = args[0]
         funfile = args[1] ? args[1] : replace(bentofile, ".bento", ".fun")
     
         if (args.count < 2) {
             "Usage: bento2fun bentofile [funfile]\n";
             exit(1);
         } else {
             "Called with bento file: ";
             bentofile;
         }
         convert(bentofile, funfile);
         exit(0);
     }
     
     convert(bentofile, funfile) {
         lines[] = lines_from_file(bentofile)
         for line in lines {
             log(line);
         }
     }
 }
 
 
 
 