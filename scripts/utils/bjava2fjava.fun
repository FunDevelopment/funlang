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

    /** Header to replace old header with.  Assumes the second line will be replaced with the file name. **/
    static new_header[] = [ "/**",
                            "  *",
                            "  *",
                            "  * Copyright (c) 2017 by Fun Development",
                            "  * All rights reserved.",
                            "  **/" ]
    
 
    public main(args[]) {
        src_path = args[1]
    
        if (args.count < 2) {
            "Usage: bjava2fjava <path>\n";
             exit(1, true);
        } else {
            "Called with path: ";
            src_path;
            newline;
        }
         
        walk(src_path);
        exit(0);
    }
     
    dynamic walk(path) {
        files[] = dir_tree(path)
        
        for f in files {
            if (ends_with(f, ".java")) {
                convert(f);
            }
        }
    }
     

    dynamic boolean is_convertible(lines[]) {
        (lines.count > 0 && !("Generated" in lines[0] || "generated" in lines[0])
            && "/*" in lines[0] && "*/" in lines[8]);    
    }     
     
    dynamic convert(srcfile) {
        lines[] = lines_from_file(srcfile)
        lines_after_header[] = [ for int i from 0 and line in lines { if (i > 8) { line } } ]
        converted_lines[] = new_header + lines_after_header
        if (is_convertible(lines)) {
            "Converting source file ";
            srcfile;
            newline;
            eval(lines);
            if (rename_file(srcfile, srcfile + ".old")) {
                "lines_after_header: ";
                lines_after_header;
                newline;
                "converted_lines: ";
                converted_lines;
                newline;
                //if (!file(srcfile).overwrite(converted_lines)) {
                //   "  ...unable to convert ";
                //   srcfile;
                //   newline;
                //}
            
            } else {
               "  ...unable to rename ";
               srcfile;
               ", skipping";
               newline;
            }


        } else { 
            "  ...skipping ";
            srcfile;
            newline;
        }
     }
 }
 
 
 
 