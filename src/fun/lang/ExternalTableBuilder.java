/* Fun Compiler and Runtime Engine
 * ExternalTableBuilder.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

import fun.runtime.Context;

import java.lang.reflect.*;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Facade class to make a Java object available as a Fun definition.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.1 $
 */
public class ExternalTableBuilder extends TableBuilder {

    private ExternalDefinition externalDef = null;

    public ExternalTableBuilder(ExternalCollectionDefinition collectionDef, ExternalDefinition externalDef) {
        super(collectionDef);
        this.externalDef = externalDef; 
    }

}


