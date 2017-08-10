/* Fun
 *
 * $Id: NameWithConstraints.java,v 1.2 2011/08/29 19:29:58 sthippo Exp $
 *
 * Copyright (c) 2007-2011 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

import java.util.List;

/**
 * A NameWithConstraints is an identifier and a list of constraint objects.  Constraints include
 * ArgumentLists, ArrayIndexes and TableIndexes.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.2 $
 */
public class NameWithConstraints extends NameNode {

    private List<FunNode> constraints;

    public NameWithConstraints() {
        super();
    }

    public NameWithConstraints(String name, List<FunNode> constraints) {
        super(name);
        this.constraints = constraints;
    }

    public boolean isPrimitive() {
        return false;
    }

    public boolean hasConstraints() {
        return constraints != null && constraints.size() > 0;
    }

    /** Returns the list of constraints associated with this name. */
    public List<FunNode> getConstraints() {
        return constraints;
    }

    protected void setConstraints(List<FunNode> constraints) {
        this.constraints = constraints;
    }
}
