/* Fun
 *
 * $Id: Filter.java,v 1.3 2005/06/30 04:20:56 sthippo Exp $
 *
 * Copyright (c) 2002-2005 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
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
