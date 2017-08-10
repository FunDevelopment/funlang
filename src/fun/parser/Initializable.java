/* Fun
 *
 * $Id: Initializable.java,v 1.4 2005/06/30 04:20:55 sthippo Exp $
 *
 * Copyright (c) 2002-2005 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.parser;


/**
 * Interface for parsed nodes which need to be initialized by the Initializer visitor.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.4 $
 */
public interface Initializable {
    public void init();
}
