/* Fun Compiler and Runtime Engine
 * NextStatement.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

import fun.runtime.Context;

/**
 * A next statement.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.8 $
 */

public class NextStatement extends AbstractConstruction {

    public NextStatement() {
        super();
    }

    public boolean isDynamic() {
        return true;
    }

    /** Returns true. **/
    public boolean hasNext() {
        return true;
    }

    public String toString(String prefix) {
        return prefix + "next;\n";
    }

    public Object generateData(Context context, Definition def) {
        return "";
    }
}
