/* Fun
 *
 * $Id: FunFileCache.java,v 1.3 2015/05/14 12:35:17 sthippo Exp $
 *
 * Copyright (c) 2006-2015 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
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

