/* Fun Compiler and Runtime Engine
 * SuperStatement.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

import fun.runtime.Context;

/**
 * A super statement.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.4 $
 */

public class SuperStatement extends AbstractConstruction {

    public SuperStatement() {
        super();
    }

    public boolean isDynamic() {
        return true;
    }

    public String toString(String prefix) {
        return prefix + "super;\n";
    }

    public Object generateData(Context context, Definition def) {
        return "";
    }
}
