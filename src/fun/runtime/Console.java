/* Fun
 *
 * $Id: Console.java,v 1.3 2005/06/30 04:20:56 sthippo Exp $
 *
 * Copyright (c) 2002-2005 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.runtime;

import fun.lang.*;

/**
 * A Console monitors the construction process interactively.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.3 $
 */

public interface Console {

    // this is called in Instantiation
    public void reportLookup(NameNode name, Definition def);

    // these are called in Context
    public Object reportStartConstruction(Construction construction);
    public Object reportEndConstruction(Construction construction);

    // this is called in Instantiation
    public Object reportInstantiation(Instantiation instantiation);
}
