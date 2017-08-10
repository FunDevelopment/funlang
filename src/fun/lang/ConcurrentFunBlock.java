/* Fun
 *
 * $Id: ConcurrentFunBlock.java,v 1.5 2014/10/24 20:01:36 sthippo Exp $
 *
 * Copyright (c) 2003-2014 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

/**
 * A ConcurrentFunBlock is a FunBlock in which each construction is executed
 * concurrently.  ConcurrentFunBlocks are delimited by <code>[+</code> and <code>+]</code>
 * brackets.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.5 $
 */

public class ConcurrentFunBlock extends FunBlock {

    public ConcurrentFunBlock() {
        super();
    }


    public String getTokenString(String prefix) {
        String str = prefix + "[++\n" + getChildrenTokenString(prefix + "    ") + prefix + "++]\n";
        return str;
    }

    public String toString(String prefix) {
        String str = super.toString(prefix);
        str = str.substring(2, str.length()).substring(2);
        str = "[++" + str + "++]";
        return str;
    }

}

