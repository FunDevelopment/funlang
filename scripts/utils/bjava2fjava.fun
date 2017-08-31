/--
 --  bjava2fjava.fun
 --
 --  Replaces headers of Java source files from the Bento version to
 --  to the Fun version
 --
 --  Walks the Java source tree and does the following for each file:
 --    
 --    * opens xxx.java and loads lines
 --    * if lines begin with new header, skip to next file
 --    * renames file from xxx.java to xxx.java.old
 --    * creates new file called xxx.java
 --    * writes new header to xxx.java
 --    * writes lines from old file to new file except for header lines
 --    * close file
 --/
 
 script bjava2fjava {
 
     public main(args[]) {
         src_path = args[0]
     
         if (args.count < 2) {
             "Usage: bjava2fjava <path>\n";
              exit(1);
         } else {
             "Called with path: ";
             src_path;
         }
         
         walk(src_path);
         exit(0);
     }
     
     walk(path) {
         files[] = dir_tree(path)
         
         for f in files {
             " * ";
             f;
             newline;
         }
     }
     
     
     
     convert(bentofile) {
         funfile = ends_with(bentofile, ".bento") ? replace(bentofile, ".bento", ".fun") : (bentofile + ".fun") 
         bento_lines[] = lines_from_file(bentofile)
         fun_lines[] = []
         
         for line in lines {
             log(line);
         }
     }
 }
 
 
 
 