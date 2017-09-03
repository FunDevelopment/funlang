/* Fun Compiler and Runtime Engine
 * Console.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
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
