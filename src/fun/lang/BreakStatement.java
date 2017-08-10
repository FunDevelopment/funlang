/* Fun
 *
 * $Id: BreakStatement.java,v 1.3 2005/06/30 04:20:54 sthippo Exp $
 *
 * Copyright (c) 2002-2005 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;


/**
 * A <code>break</code> statement
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.3 $
 */

public class BreakStatement extends FunStatement {

    public BreakStatement() {
        super();
    }

    public boolean isDynamic() {
        return false;
    }
}
