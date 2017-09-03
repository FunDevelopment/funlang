/* Fun Compiler and Runtime Engine
 * ConstructionContainer.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

import fun.runtime.Context;

import java.util.List;

/**
 * ConstructionContainer is the interface for objects which own dynamic and/or
 * static constructions.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.5 $
 */

public interface ConstructionContainer {

    /** Returns the list of constructions owned by this container. */
    public List<Construction> getConstructions(Context context);
}
