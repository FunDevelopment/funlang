/-----------------------------------------------------------------------------
 --  core_platform_java.fun                                               --
 --                                                                         --
 --  platform-dependent core definitions                                    --
 --  Java version                                                           --
 --                                                                         --
 --  Copyright (c) 2002-2016 by fundev.org.  All rights reserved.         --
 --                                                                         --
 -----------------------------------------------------------------------------/

core {

    extern java java.**
    extern java javax.**
    extern java fun.**

    /------ Redirection ------/
    
    dynamic redirection = fun.lang.Redirection

    /------ Concurrent execution control ------/
    
    dynamic sleep(int millis) = fun.runtime.Utils.sleep(millis)

    /------ Reflection ------/

    dynamic definition definition_of(x) [&]

    /------ Processor and Domain ------/

    /** The fun_processor which created the current fun_domain. **/
    global fun_processor this_processor [&]

    /** The fun_server responsible for the current context, if running on a
     *  fun_server, else null.  If it is not null, it will generally be the 
     *  same as the fun_processor.
     **/
    global fun_server this_server [&]

    /** The fun_domain in which objects in the current context are being constructed. **/
    global fun_domain this_domain [&]
    
    /** convenience function to get the local context **/
    dynamic fun_context this_context = this_domain.context

	/-- file_base = this_server.file_base
	boolean files_first = this_server.files_first --/

    /** the name of the site owning the current context. **/
	dynamic site_name = this_context.site_name


    /------ Collection access ------/

    array = fun.runtime.Array;
    table = fun.runtime.Table;
    
    dynamic string[] sorted_array(string[] ary) = fun.runtime.Utils.sortedArray(ary)
    dynamic string{} sorted_table(string{} tbl) = fun.runtime.Utils.sortedTable(tbl) 

    /------ Database objects ------/

    database_interface db_impl(driver, url, user, password) = fun.runtime.Database(driver, url, user, password)

    java.sql.ResultSet result_set [/]

    string{} db_row(result_set results, int row) = fun.runtime.DatabaseRow(results, row)

    /------ Math ------/
    

    /------ Useful types ------/

    static java.text.DateFormat date_format [/]
    dynamic date_format simple_date_format = java.text.SimpleDateFormat("MMMMMM dd, yyyy")
    dynamic date_format numeric_date_format = java.text.SimpleDateFormat("yyyyMMdd")
    dynamic date_format simple_time_format = java.text.SimpleDateFormat("HH:mm")
    java.util.Date date [/]

    dynamic date today {
        simple_date_format.format(super);
    }

    dynamic date now {
        simple_time_format.format(super);
    }

    dynamic date numeric_today {
        numeric_date_format.format(super);
    }

    long time [/]
    dynamic time current_time = java.lang.System.currentTimeMillis
    dynamic long current_minutes = current_time / 60000
    dynamic long current_seconds = current_time / 1000

    static char path_sep = ':'
    static char file_sep = '/'

    /------ Text utilities ------/
    
    dynamic chr$(int n) = fun.runtime.Utils.chr$(n)

    dynamic hex(int n) = fun.runtime.Utils.hex(n)

	/** Returns the length of str. **/
	dynamic int strlen(str) = fun.runtime.Utils.strlen(str)

    /** Coverts a string to lower case. **/
    dynamic to_lower(str) = fun.runtime.Utils.toLower(str)

    /** Coverts a string to upper case. **/
    dynamic to_upper(str) = fun.runtime.Utils.toUpper(str)

    /** Returns true if str begins with substr. **/
    dynamic boolean starts_with(str, substr) = fun.runtime.Utils.startsWith(str, substr)

    /** Returns true if str ends with substr. **/
    dynamic boolean ends_with(str, substr) = fun.runtime.Utils.endsWith(str, substr)
    
    /** Returns index of substr in str, or -1 if not found.  If the ix parameter is supplied,
      * the search begins at that offset in the string.
      **/
    dynamic int index_of(str, substr), (str, substr, int ix) { 
        with (ix) {
            fun.runtime.Utils.indexOf(str, substr, ix);
        } else {
            fun.runtime.Utils.indexOf(str, substr);
        }
    }

    /** Returns index of substr in str, searching from the end of the string
     *  back, or -1 if not found.  If the ix parameter is supplied, the 
     *  search begins at that offset in the string.
     **/
    dynamic int last_index_of(str, substr), (str, substr, int ix) { 
        with (ix) {
            fun.runtime.Utils.lastIndexOf(str, substr, ix);
        } else {
            fun.runtime.Utils.lastIndexOf(str, substr);
        }
    }

    /** Returns a portion of the passed string, starting at position start_ix and ending
     *  just before position end_ix, or, if end_ix is not provided, to the end of string.
     **/
    dynamic substring(str, int start_ix), (str, int start_ix, int end_ix) {
        with (end_ix) {
            fun.runtime.Utils.substring(str, start_ix, end_ix);
        } else {
            fun.runtime.Utils.substring(str, start_ix);
        }
    }
    
    /** Removes leading and trailing spaces, or characters of a specified value **/
    dynamic trim(str),(str, char c) = c ? fun.runtime.Utils.trim(str, c) : fun.runtime.Utils.trim(str)
    
    /** If c is provided: removes all leading instances of c. 
     *
     *  If substr is non-null: if str begins with substr, returns the the portion of str following 
     *  substr, otherwise returns str.
     *
     *  If substr is null or not provided: removes leading whitespace.
     **/
    dynamic trim_leading(str, char c),(str, substr) = (c ? fun.runtime.Utils.trimLeading(str, c) : (substr ? fun.runtime.Utils.trimLeading(str, substr) : fun.runtime.Utils.trimLeading(str)))

    /** If c is provided: removes all trailing instances of c. 
     *
     *  If substr is non-null: if str ends with substr, returns the the portion of str preceding
     *  substr, otherwise returns str.
     *
     *  If substr is null or not provided: removes trailing whitespace.
     **/
    dynamic trim_trailing(str, char c),(str, substr) = (c ? fun.runtime.Utils.trimTrailing(str, c) : (substr ? fun.runtime.Utils.trimTrailing(str, substr) : fun.runtime.Utils.trimTrailing(str)))

    /** Returns the substring of str that begins after the first instance of c in
     *  str.  If str does not contain c, returns null.
     **/
    dynamic trim_through_first(str, char c) = fun.runtime.Utils.trimThroughFirst(str, c)

    /** Returns the substring of str that ends just before the first instance of c
     *  in str.  If str does not contain c, returns str.
     **/
    dynamic trim_from_last(str, char c) = fun.runtime.Utils.trimFromLast(str, c)

	/** Returns the ixth character in str. **/
    dynamic char char_at(str, int ix) = fun.runtime.Utils.charAt(str, ix)

    /** Returns the first character in str. **/
    dynamic char first_char(str) = fun.runtime.Utils.charAt(str, 0)

    /** Returns the first printable (non-whitespace) character in str. **/
    dynamic char first_printable_char(str) = first_char(trim_leading(str))

    /** Returns the last character in str. **/
    dynamic char last_char(str) = fun.runtime.Utils.charAt(str, strlen(str) - 1)

    /** Returns the last printable (non-whitespace) character in str. **/
    dynamic char last_printable_char(str) = last_char(trim_trailing(str))

	/** Insterts a string into a string at the ixth character. **/
    dynamic insert_at(str, int ix, substr) = fun.runtime.Utils.insertAt(str, ix, substr)

	/** Returns a string equal to str with every occurrence of oldstr replaced
	 *  by newstr.
	 */ 
    dynamic replace(str, oldstr, newstr) = fun.runtime.Utils.replaceOccurrences(str, oldstr, newstr)

    dynamic replace_all(str, strmap[]) = fun.runtime.Utils.replaceAllOccurrences(str, strmap)

    dynamic concat(str1, str2),(strs[]) = (strs ? fun.runtime.Utils.concat(strs) : fun.runtime.Utils.concat(str1, str2)) 

    dynamic split(str, regex) = fun.runtime.Utils.split(str, regex)

    /** Splits a string into an array of substrings **/
    dynamic string[] tokenize(str),(str, delims, boolean return_delims) = fun.runtime.Utils.tokenize(str, delims, return_delims)

    /** Splits a string into an array of lines **/
    dynamic string[] lines(str) = fun.runtime.Utils.lines(str)

    /** Splits a string into an array of paragraphs, delimited by empty lines. **/
    dynamic string[] paragraphs(str) = fun.runtime.Utils.paragraphs(str)

    dynamic lead_paragraph(str, int minlength, int maxlength) = fun.runtime.Utils.getFirstHTMLParagraph(str, minlength, maxlength)
    
	/** Returns str with every instance of < replaced by &lt; **/
	dynamic html_encode(str) = fun.runtime.Utils.htmlEncode(str)
	
	/** Returns str with unsafe characters escaped **/
	dynamic url_encode(str) = fun.runtime.Utils.urlEncode(str)
	

    /------ File Utilities ------/

    static path_separator = java.lang.File.pathSeparator

    dynamic include_file(path) = fun.runtime.Utils.includeFile(path)
    dynamic include_url(path) = fun.runtime.Utils.includeURL(path)
    dynamic encode_url(path) = fun.runtime.Utils.encodeURL(path)
    
    dynamic string[] dir(path) = fun.runtime.Utils.dir(path)

    file_interface file_impl(file_interface fbase, path),(base, path),(base) = fun.runtime.Utils.getFunFile(fbase, base, path)
    
    dynamic file_impl(*) file(file_interface fbase, path),(base, path),(base) [/]

    file_interface {
        name [&]
        absolute_path [&]
        canonical_path [&]
        boolean exists [&]
        boolean readable [&]
        boolean writeable [&]
        boolean is_file [&]
        boolean is_dir [&]
        boolean is_hidden [&]
        long length [&]
        long modified [&]
        string[] list = [&]
        file[] files = [&]
        contents [&]
        dynamic boolean append(x) [&]
        dynamic boolean overwrite(x) [&]
        dynamic boolean delete [&]
        dynamic boolean mkdir [&]
        dynamic boolean mkdirs [&]
    }

    persistent_cache = fun.runtime.FunFileCache(cache_path)

    dynamic string[] safe_lines_from_file(filename, basedir) = fun.runtime.Utils.safeLinesFromFile(filename, basedir)  


    /----- Run a System Command -----/ 

    exec_interface {
        dynamic boolean is_running [?]
        dynamic int exit_val [?]
        dynamic exception [?]
        dynamic boolean has_out [?] 
        dynamic out [?]
        dynamic boolean has_err [?]
        dynamic err [?]
        dynamic read_in(str) [?]
    }
    
    exec_interface exec(cmd), (cmd, string{} env), (cmd, string{} env, file run_dir) = fun.runtime.Exec.execFactory(cmd, env, run_dir);
    

	/----- System Information -----/

	/** Accesses an environment variable, or null if not available. **/
	dynamic $(env_var) = fun.runtime.Utils.getenv(env_var)	
	
	
    /------ Logging ------/

    /** sends a string to log file/console **/
    dynamic log(str) = fun.runtime.SiteBuilder.log(str)

    /** sends a string to log file/console if Fun is running in
     *  verbose mode.
     **/
    dynamic vlog(str) = fun.runtime.SiteBuilder.vlog(str)
    
    /** sends a string and a newline to the console, bypasses log file **/
    dynamic println(str) = java.lang.System.out.println
    
    /** sends an error message to log file/console **/
    dynamic err(str) = fun.runtime.SiteBuilder.err(str)
    
}
