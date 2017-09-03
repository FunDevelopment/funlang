/* Fun Compiler and Runtime Engine
 * ExternStatement.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

/**
 * ExternStatement represents an extern statement, which declares a name to refer
 * to an external object of a particular binding.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.4 $
 */

public class ExternStatement extends AdoptStatement {

    private String binding;

    public ExternStatement() {
        super();
    }

    public void setBinding(String binding) {
        this.binding = binding;
    }

    public String getBinding() {
        return binding;
    }

    public String toString(String prefix) {
        return prefix + "extern " + binding + " " + getName();
    }
}

