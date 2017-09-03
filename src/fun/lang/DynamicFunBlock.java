/* Fun Compiler and Runtime Engine
 * DynamicFunBlock.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

import fun.runtime.Context;
import fun.parser.FunParser;
import fun.parser.ParseException;

import java.util.*;
import java.io.StringReader;

/**
 * A DynamicFunBlock is a FunBlock which constructs Fun code.  DynamicFunBlocks
 * are used by code comprehensions and are delimited by <code>[[</code> and <code>]]</code>
 * brackets.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.14 $
 */

public class DynamicFunBlock extends FunBlock implements CodeGenerator, DynamicObject {

    protected AbstractNode generatedNode = null;
    protected List<String> generatedProblems = null;
    private boolean initialized = false;

    public DynamicFunBlock() {
        super();
    }

    protected DynamicFunBlock(DynamicFunBlock proto, Context context) {
        super();
        this.owner = proto.getOwner();
        this.children = proto.children;
        generatedNode = generateContents(context);
        initialized = true;
    }

    public AbstractNode[] generateChildren(Context context) {
        if (generatedNode == null) {
            generatedNode = generateContents(context);
        }
        return generatedNode.children;
    }
    
    private AbstractNode generateContents(Context context) {
        AbstractNode node = null;
        try {
            String code = generateCode(context);
            FunParser parser = new FunParser(new StringReader(code));
            Definition owner = getOwner();
            
            node = generateNode(parser);
            node.owner = owner;
            
            Site site = owner.getSite();
            Core core = site.getCore();
            node.jjtAccept(new Initializer(core, site, true), owner);
            node.jjtAccept(new Resolver(), null);
            Validater validater = new Validater();
            node.jjtAccept(validater, null);
            generatedProblems = validater.getProblems();
            
            // should there be a Linker?

        } catch (Redirection r) {
            System.out.println("Redirection generating dynamic code: " + r);
        } catch (Exception e) {
            System.out.println("Exception generating dynamic code: " + e);
        }
        return node;
    }
    
    protected AbstractNode generateNode(FunParser parser) throws ParseException {
        return parser.generateFunBlock();
    }
    
    public List<String> getProblems() {
        return generatedProblems;
    }

    public String generateCode(Context context) throws Redirection {
        FunBlock delegatedBlock = new FunBlock(children);
        return delegatedBlock.getText(context);
    }

    public List<Construction> getConstructions(Context context) {
        Block block = (Block) initForContext(context, null, null);
        return block.getConstructions();
    }

    public Object initForContext(Context context, ArgumentList args, List<Index> indexes) {
        if (initialized) {
            return this;
        } else {
            return new DynamicFunBlock(this, context);
        }
    }

    /** Returns true if this object is already initialized for the specified context,
     *  i.e., if <code>initForContext(context, args) == this</code> is true.
     */
    public boolean isInitialized(Context context) {
        return initialized;
    }

    
    public FunNode getChild(int n) {
        return (generatedNode == null ? null : generatedNode.getChild(n));
    }

    public Iterator<FunNode> getChildren() {
        return (generatedNode == null ? null : generatedNode.getChildren());
    }

    public int getNumChildren() {
        return (generatedNode == null ? 0 : generatedNode.getNumChildren());
    }

    public String getTokenString(String prefix) {
        String str = prefix + "[[\n" + getChildrenTokenString(prefix + "    ") + prefix + "]]\n";
        return str;
    }

    public String toString(String prefix) {
        String str = super.toString(prefix);
        str = str.substring(2, str.length()).substring(2);
        str = "[%" + str + "%]";
        return str;
    }

}

