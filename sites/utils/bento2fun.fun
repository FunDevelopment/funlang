/--
 --  bento2fun.fun
 --
 --  Converts bento source files to fun source files
 --
 --  Works as follows:
 --
 --    * launch a BentoParser
 --    * get a bento AST
 --    * walk the tree and generate fun code 
 --
 --
 --/
 
 script bento2fun {
 
     public main(args[]) {
         bentofile = args[0]
         funfile = args[1] ? args[1] : replace(bentofile, ".bento", ".fun")
     
         if (args.count < 1) {
             "Usage: bento2fun bentofile [funfile]\n";
         } else {
             "Called with bento file: ";
             bentofile;
         }
     }
 
 
 
 }
 
 
 
 