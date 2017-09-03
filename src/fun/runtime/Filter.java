/* Fun Compiler and Runtime Engine
 * Filter.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.runtime;


/**
 * A Filter distinguishes among paths.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.3 $
 */

public interface Filter {

    /** Returns true if the path is distinguished by this filter. */
    public boolean filter(String path);
}
