/* Fun
 *
 * $Id: ConstructionContainer.java,v 1.5 2011/08/13 19:22:14 sthippo Exp $
 *
 * Copyright (c) 2002-2011 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
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
