/* Fun
 *
 * $Id: ExternalTableBuilder.java,v 1.1 2013/05/02 16:47:35 sthippo Exp $
 *
 * Copyright (c) 2002-2013 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
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


