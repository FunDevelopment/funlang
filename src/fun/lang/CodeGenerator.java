/* Fun
 *
 * $Id: CodeGenerator.java,v 1.3 2005/06/30 04:20:52 sthippo Exp $
 *
 * Copyright (c) 2003-2005 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

import fun.runtime.Context;

/**
 * A CodeGenerator is an object which generates Fun source code dynamically (i.e.
 * for a particular context).
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.3 $
 */

public interface CodeGenerator {

    /** Generates Fun source code given a context. */
    public String generateCode(Context context) throws Redirection;
}
