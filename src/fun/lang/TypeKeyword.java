/* Fun
 *
 * $Id: TypeKeyword.java,v 1.6 2011/08/29 19:29:58 sthippo Exp $
 *
 * Copyright (c) 2002-2011 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

import fun.runtime.Context;

import java.util.*;

/**
 * Reserved name.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.6 $
 */
public class TypeKeyword extends AbstractType {
    public TypeKeyword() {
        super();
    }

    public String getName() {
        return "type"; //getDefinition().getName();
    }

    public boolean equals(Object obj) {
        if (obj instanceof Type) {
            Type otherType = (Type) obj;
            String name = getName();
            if (name == null) {
                return (otherType.getName() == null);
            } else {
                return name.equals(otherType.getName());
            }
        }
        return false;
    }

    public List<Dim> getDims() {
        return null; // getDefinition().getType().getDims();
    }

    public ArgumentList getArguments(Context context) {
        // this needs to be changed to return the arguments from the preceding
        // reference
        return null; // getDefinition().getType().getArguments();
    }

    public Class<?> getTypeClass(Context context) {
        return getDefinition().getType().getTypeClass(context);
    }

    public Value convert(Value val) {
        return getDefinition().getType().convert(val);
    }
}
