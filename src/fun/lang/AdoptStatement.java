/* Fun Compiler and Runtime Engine
 * AdoptStatement.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

/**
 * An adopt statement.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.3 $
 */

public class AdoptStatement extends ComplexName {

    public AdoptStatement() {
        super();
    }

    public String toString(String prefix) {
        return prefix + "adopt " + getName();
    }
}
