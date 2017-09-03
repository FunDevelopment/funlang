/* Fun Compiler and Runtime Engine
 * CodeGenerator.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
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
