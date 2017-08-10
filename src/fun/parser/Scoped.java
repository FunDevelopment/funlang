/* Fun
 *
 * $Id: Scoped.java,v 1.6 2014/03/24 02:16:02 sthippo Exp $
 *
 * Copyright (c) 2002-2014 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.parser;

import fun.lang.*;

/**
 * Interface for parsed nodes which can have a scoper modifier (public, private
 * or protected).
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.6 $
 */
public interface Scoped extends Initializable {
    public void setModifiers(int access, int dur);
    public NameNode getDefName();
}
