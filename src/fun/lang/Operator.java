/* Fun
 *
 * $Id: Operator.java,v 1.5 2011/08/12 21:17:59 sthippo Exp $
 *
 * Copyright (c) 2002-2011 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

import java.util.List;

/**
 * Operator interface.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.5 $
 */

public interface Operator {

    /** Operates on one or more operands and return the result.
     */
    public Value operate(List<Value> operands);

}
