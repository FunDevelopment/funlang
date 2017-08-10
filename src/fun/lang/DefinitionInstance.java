/* Fun
 *
 * $Id: DefinitionInstance.java,v 1.1 2013/12/23 14:08:44 sthippo Exp $
 *
 * Copyright (c) 2013-2014 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

import java.util.List;

/**
 * DefinitionInstance is a wrapper for a definition with arguments and indexes.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.1 $
 */

public class DefinitionInstance {
    public Definition def;
    public ArgumentList args;
    public List<Index> indexes;
        
    public DefinitionInstance(Definition def, ArgumentList args, List<Index> indexes) {
        this.def = def;
        this.args = args;
        this.indexes = indexes;
    }
}	    
