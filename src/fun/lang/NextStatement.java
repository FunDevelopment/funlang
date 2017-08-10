/* Fun
 *
 * $Id: NextStatement.java,v 1.8 2013/04/10 03:29:30 sthippo Exp $
 *
 * Copyright (c) 2002-2013 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
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