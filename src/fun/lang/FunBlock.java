/* Fun Compiler and Runtime Engine
 * FunBlock.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

import fun.runtime.Context;


/**
 * A FunBlock is a container whose children are Fun statements.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.6 $
 */

public class FunBlock extends Block {

    public FunBlock() {
        super();
    }

    public FunBlock(AbstractNode[] children) {
        super(children);
    }

    public boolean isDynamic() {
        return true;
    }

    public boolean isStatic() {
        return false;
    }

    public boolean isAbstract(Context context) {
        return false;
    }

    //    public String toString() {
//        String str = "[=\n";
//        Iterator it = getChildren();
//        while (it.hasNext()) {
//            FunNode node = (FunNode) it.next();
//            str = str + "\n    " + node.toString();
//        }
//        str = str + "\n=]\n";
//        return str;
//    }

    public String getTokenString(String prefix) {
        String str = prefix + "{=\n" + getChildrenTokenString(prefix + "    ") + prefix + "=}\n";
        return str;
    }

    public String toString(String prefix) {
        String str = "{=\n" + super.toString(prefix) + prefix + "=}";
        return str;
    }

    public String toString(String firstPrefix, String prefix) {
        return firstPrefix + toString(prefix);
    }
}

