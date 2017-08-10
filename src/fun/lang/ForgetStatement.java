/* Fun
 *
 * $Id: ForgetStatement.java,v 1.5 2011/09/16 21:56:03 sthippo Exp $
 *
 * Copyright (c) 2002-2005 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;


/**
 * A discard directive.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.5 $
 */

public class ForgetStatement extends FunStatement {

    private String name;

    public ForgetStatement() {
        super();
    }

    public ForgetStatement(String name) {
        super();
        this.name = name;
    }

    public boolean isDynamic() {
        return false;
    }

    protected void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

}
