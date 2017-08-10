/* Fun
 *
 * $Id: ParsedCollectionDefinition.java,v 1.4 2015/05/18 13:06:26 sthippo Exp $
 *
 * Copyright (c) 2013-2015 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.parser;

import fun.lang.*;

import java.util.*;

/**
 * Based on code generated by jjtree.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.4 $
 */
public class ParsedCollectionDefinition extends CollectionDefinition implements Scoped {

    public ParsedCollectionDefinition(int id) {
        super();
    }

    /** Accept the visitor. **/
    public Object jjtAccept(FunParserVisitor visitor, Object data) {
        return visitor.visit(this, data);
    }

    public void init() {
        int len = children.length;
        if (len > 0) {
            AbstractNode node = children[0];
            int elementIx;
            NameNode name = null;
            Type type = null;
            List<Dim> dims = null;
            if (node instanceof Type) {
                type = (Type) node;
                elementIx = 1;
            } else {
                elementIx = 0;
            }
            name = (NameNode) children[elementIx++];

            // initialize the dimensions
            if (name != null) {
                if (name instanceof NameWithDims) {
                    dims = ((NameWithDims) name).getDims();
                } else if (elementIx < len && children[elementIx] instanceof Dim) {
                    dims = new ArrayList<Dim>(len - elementIx - 1);
                    while (elementIx < len) {
                        dims.add((Dim) children[elementIx++]);
                        if (!(children[elementIx] instanceof Dim)) {
                            break;
                        }
                    }
                }
            }
            List<Dim> typeDims = null;
            if (type != null) {
                typeDims = type.getDims();
            }
            if (dims == null || dims.size() == 0) {
                if (typeDims == null || typeDims.size() == 0) {
                    dims = null;
                    if (children[elementIx] instanceof ArgumentList) {
                        ArgumentList argList = (ArgumentList) children[elementIx];
                        if (argList.isArray() || argList.isTable()) {
                            Dim newDim = new Dim(Dim.TYPE.DEFINITE, argList.size());
                            if (argList.isTable()) {
                                newDim.setTable(true);
                            }
                            dims = new ArrayList<Dim>(1);
                            dims.add(newDim);
                        }
                    }
                    vlog("Collection " + name.getName() + " dimensions not specified in definition; will be inferred from supertype");
                } else {
                    dims = typeDims;
                }
            } else if (typeDims != null) {
                List<Dim> newDims = new ArrayList<Dim>(dims.size() + typeDims.size());
                newDims.addAll(typeDims);
                newDims.addAll(dims);
                dims = newDims;
            }

            // init needs the dims, so call setDims first
            if (dims != null) {
                setDims(dims);
            }
            if (len > elementIx) {
                init(type, name, children[elementIx]);
            } else {
                init(type, name, null);
            }
        }
    }

    public void setModifiers(int access, int dur) {
        setAccess(access);
        setDurability(dur);
    }

    public NameNode getDefName() {
    	return getNameNode();
    }
}
