/* Fun Compiler and Runtime Engine
 * fun_processor.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

import java.util.Map;

/**
 * This interface corresponds to the Fun fun_processor object, called by Fun code
 * to obtain environment information and compile Fun code at runtime.
 */
public interface fun_processor {
    /** Returns the name of this processor (generally the name of a class or
     *  interface).
     **/
    public String name();

    /** The highest Fun version number supported by this processor. **/
    public String version();

    /** Properties associated with this processor. **/
    public Map<String, Object> props();

    /** Compile the Fun source files found at the locations specified in <code>funpath</code>
     *  and return a fun_domain object.  If a location is a directory and <code>recursive</code>
     *  is true, scan subdirectories recursively for Fun source files.  If <code>autoloadCore</code>
     *  is true, and the core definitions required by the system cannot be found in the files
     *  specified in <code>funpath</code>, the processor will attempt to load the core
     *  definitions automatically from a known source (e.g. from the same jar file that the
     *  processor was loaded from).
     *
     *  <code>siteName</code> is the name of the main site; it may be null, in which case the
     *  default site must contain a definition for <code>main_site</code>, which must yield the
     *  name of the main site.
     */
    public fun_domain compile(String siteName, String funpath, boolean recursive, boolean autoloadCore);

    /** Compile Fun source code passed in as a string and return a fun_domain object.  If
     *  <code>autoloadCore</code> is true, and the core definitions required by the system cannot
     *  be found in the passed text, the processor will attempt to load the core definitions
     *  automatically from a known source (e.g. from the same jar file that the processor was
     *  loaded from).
     *
     *  <code>siteName</code> is the name of the main site; it may be null, in which case the
     *  default site must contain a definition for <code>main_site</code>, which must yield the
     *  name of the main site.
     */
    public fun_domain compile(String siteName, String funtext, boolean autoloadCore);

    /** Compile Fun source code passed in as a string and merge the result into the specified
     *  fun_domain.  If there is a fatal error in the code, the result is not merged and
     *  a Redirection is thrown.
     */
    public void compile_into(fun_domain domain, String funtext) throws Redirection;
    
    /** Returns the domain type.  The default for the primary domain is "site".
     */
    public String domain_type();
}


