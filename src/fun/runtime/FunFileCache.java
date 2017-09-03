/* Fun Compiler and Runtime Engine
 * FunFileCache.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.runtime;

import java.io.*;
import java.util.*;

/**
 * A FunFileCache stores values in the form of Fun source code.
 * 
 * 
 * @author Michael St. Hippolyte
 * @version $Revision: 1.3 $
 */

abstract public class FunFileCache extends AbstractMap {

    File file;
    String siteName;
 
    /** Constructs a file-based persistent cache.
     */
    public FunFileCache(File file, String siteName) {
    }

}

