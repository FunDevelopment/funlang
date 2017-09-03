/* Fun Compiler and Runtime Engine
 * ExternalType.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

import fun.runtime.Context;

/**
 * A Type corresponding to an externally defined class.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.11 $
 */
public class ExternalType extends ComplexType {

    public ExternalType(ExternalDefinition def) {
        super(def, def.getExternalTypeName(), def.getDims(), def.getArguments());
    }

    public Class<?> getTypeClass(Context context) {
        return ((ExternalDefinition) getDefinition()).getExternalClass(context);
    }
}


