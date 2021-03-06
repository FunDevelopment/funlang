/* Fun Compiler and Runtime Engine
 * FunProcessor.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.runtime;

import fun.lang.*;


/**
 * This interface extends fun_server (and therefore fun_processor) to include methods
 * to adjust the behavior of a Fun processor.
 */
public interface FunProcessor extends fun_server {

    /** Sets the files first option.  If this flag is present, then the server looks for
     *  files before fun objects to satisfy a request.  If not present, the server looks
     *  for fun objects first, and looks for files only when no suitable object by the
     *  requested name exists.
     */
    public void setFilesFirst(boolean filesFirst);

    /** Sets the base directory where the server should read and write files. **/
    public void setFileBase(String fileBase);
}


