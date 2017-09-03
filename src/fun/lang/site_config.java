/* Fun Compiler and Runtime Engine
 * site_config.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

/**
 * This interface corresponds to the site_config object, defined in the
 * default site_config.fun file.  It represents a website configuration --
 * name, funpath, base directory for file-based resources, and
 * network address.
 */
public interface site_config {

    /** Returns the name of the site. **/
    public String name();
    
    /** The directories and/or files containing the Fun source
     *  code for this site.
     **/
    public String funpath();
    
    /** The directories and/or files containing the Fun source
     *  code for core.
     **/
    public String corepath();
    
    /** The directories and/or files containing the Fun source
     *  code specific to this site (not including core).
     **/
    public String sitepath();

        /** If true, directories found in funpath are searched recursively
     *  for Fun source files.
     **/
    public boolean recursive();
    
    /** The base directory for file-based resources. **/
    public String filepath();

    /** The files first setting.  If true, the server should look for files 
     *  before Fun objects to satisfy a request.  If false, the server 
     *  should look for Fun objects first, and look for files only when no 
     *  suitable Fun object by the requested name exists.
     */
    public boolean files_first();
}


