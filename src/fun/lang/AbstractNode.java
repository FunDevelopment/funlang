/* Fun Compiler and Runtime Engine
 * AbstractNode.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;

import fun.compiler.visitor.FunCompilerVisitDestination;
import fun.parser.FunParserConstants;
import fun.parser.FunParserVisitor;
import fun.parser.Initializable;
import fun.parser.Node;
import fun.parser.Token;
import fun.runtime.Context;
import fun.runtime.SiteBuilder;

/**
 * AbstractNode is the base class for fun nodes.  Nodes are either primitive
 * or complex; a primitive node contains simple data or logic, while a complex node
 * contains other nodes.  Nodes may also belong to one of three mutually exclusive
 * special categories: static, meaning they contain unchanging data; dynamic, meaning
 * they generate data; and definitions, meaning they are employed by other nodes
 * to generate runtime data.  Some nodes belong to none of the three categories,
 * meaning they neither contain nor generate data, nor are referenced directly by
 * nodes which do.  Examples include linkage instructions such as extern and join
 * statements and runtime caching directives such as keep and forget statements.
 *
 * AbstractNodes exist in two hierarchies, a node hierarchy and a namespace hierarchy.
 * The node hierarchy is generated by the parser and reflects the grammatical structure
 * of the fun document.  The namespace hierarchy consists of the top-level site
 * definitions and all the named definitions nested within them.  A node's parent in
 * the node hierarchy is returned by the getParent method; the parent in the name
 * hierarchy is returned by the getOwner method.
 *
 * AbstractNode implements both the FunNode interface, which is used by classes in
 * the fun.lang package, and the Node interface, which is used by classes generated
 * by javacc and jjtree.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.28 $
 */
abstract public class AbstractNode extends FunCompilerVisitDestination implements FunNode, Node, Cloneable {

    /** The default size for ArrayLists */
    public final static int TYPICAL_LIST_SIZE = 4;

    /** Standard indent when displaying source */
    public final static String indent = "    ";

    /** An undefined object.  This can be returned by methods which need to distinguish
     *  between an undefined object and an object which is defined but null.
     */
    public final static class Undefined extends Object {}
    public final static Undefined UNDEFINED = new Undefined();
    
    public final static class Uninstantiated extends Object {}
    public final static Uninstantiated UNINSTANTIATED = new Uninstantiated();



    /** Static utility method to retrieve the value of an arbitrary object. */
    public static Object getObjectValue(Context context, Object obj) {
        Object data = null;
        if (obj instanceof ValueGenerator) {
            try {
                data = ((ValueGenerator) obj).getData(context);
            } catch (Redirection r) {
                data = null;
            }

        } else if (obj instanceof Value) {
            data = ((Value) obj).getValue();
        } else {
            data = obj;
        }
        return data;
    }

    /** The definition in whose namespace this node resides. */
    protected Definition owner;

    /** The parent of this node, or null if this is the root. */
    protected AbstractNode parent;

    /** The children of this node.  This field is protected
     *  protected rather than private to allow for efficient
     *  node initialization and tree walking.
     */
    protected AbstractNode[] children;

    /** The first token in the input stream corresponding to this node. */
    protected Token firstToken;

    /** The last token in the input stream corresponding to this node. */
    protected Token lastToken;

    /** Constructs an empty node. */
    public AbstractNode() {
    }

    /** Constructs a node which is a copy of the passed node. */
    public AbstractNode(AbstractNode node) {
        owner = node.owner;
        parent = node.parent;
        children = node.children;
        firstToken = node.firstToken;
        lastToken = node.lastToken;
    }

    public void setOwner(Definition owner) {
        this.owner = owner;
    }

    public Definition getOwner() {
        return owner;
    }

    /** Resolves any references.  Assumes that the owner of this node has been set. **/
    public void resolve() {}
    
    /** Gets the name of this node.  The default name is just the class name, but nodes types that have
     *  meaningful names should override this to return the name.
     */
    public String getName() {
        return '[' + getClass().getName() + ']';
    }


    /** Clone this node.  Cloning is shallow, in that the child nodes are not
     *  cloned, and a cloned node contains the exact same child nodes as the
     *  original.  However, the array containing those nodes is cloned, not
     *  copied, so that child nodes may be added to or removed from a cloned node
     *  without affecting the original node.
     */
    public Object clone() {
        try {
            AbstractNode copy = (AbstractNode) super.clone();
            if (children != null) {
                copy.children = (AbstractNode[]) children.clone();
            }
            return copy;
        } catch (CloneNotSupportedException e) {
            // this is purely to avoid a "throws CloneNotSupportedException" clause
            throw new InternalError("unexpected exception; Java version may be incompatible");
        }
    }

    /** If true, this node cannot have children. */
    abstract public boolean isPrimitive();

    /** If true, this chunk represents static information. */
    abstract public boolean isStatic();

    /** If true, this chunk is dynamically generated at runtime. */
    abstract public boolean isDynamic();

    /** If true, this chunk is a definition. */
    abstract public boolean isDefinition();
    
    /** If this node supports the notion of contents, returns the contents.  Otherwise,
     *  throws an UnsupportedOperationException.
     */
    public AbstractNode getContents() {
        throw new UnsupportedOperationException("This node type does not support getContents()");
    }

    protected void setChild(int n, AbstractNode child) {
        jjtAddChild(child, n);
    }

    void addChildren(AbstractNode node) {
        int currentLen = (children == null ? 0 : children.length);
        int newLen = currentLen + (node.children == null ? 0 : node.children.length);
        if (newLen > currentLen) {
            AbstractNode c[] = new AbstractNode[newLen];
            if (children != null) {
                System.arraycopy(children, 0, c, 0, currentLen);
            }
            System.arraycopy(node.children, 0, c, currentLen, node.children.length);
            children = c;
        }
    }

    void copyChildren(FunNode node) {
        copyChildren(node, 0, node.getNumChildren());
    }
    
    void copyChildren(FunNode node, int start, int len) {
        int newLen = Math.min(node.getNumChildren(), start + len) - start;
        if (newLen < 0) newLen = 0;
        AbstractNode c[] = new AbstractNode[newLen];
        for (int i = start; i < start + newLen; i++) {
            c[i - start] = (AbstractNode) ((AbstractNode) node.getChild(i)).clone();
            c[i - start].parent = this;
        }
        children = c;
    }


    public FunNode getChild(int n) {
        return children[n];
    }

    public Iterator<FunNode> getChildren() {
        if (children == null || children.length == 0) {
            return new NullIterator<FunNode>();
        } else {
            return Arrays.asList((FunNode[]) children).iterator();
        }
    }

    public List<FunNode> getChildList() {
        if (children == null || children.length == 0) {
            return new EmptyList<FunNode>();
        } else {
            return Arrays.asList((FunNode[]) children);
        }
    }
    
    
    private static class NullIterator<E> implements Iterator<E> {
        public boolean hasNext() { return false; }
        public E next() { throw new NoSuchElementException("this is a NullIterator"); }
        public void remove() { throw new UnsupportedOperationException("NullIterator does not support remove()"); }
    }

    public int getNumChildren() {
        return (children == null) ? 0 : children.length;
    }

    public FunNode getParent() {
        return parent;
    }

    /** Returns the next child after this node in the parent's child nodes. */
    public FunNode getNextSibling() {
        AbstractNode[] nodes = parent.children;
        for (int i = 0; i < nodes.length - 1; i++) {
            if (nodes[i] == this) {
                return nodes[i + 1];
            }
        }
        
        return null;
    }

    public String getChildrenTokenString(String prefix) {
        StringBuffer sb = new StringBuffer();
        for (Token t = firstToken; t != null; t = t.next) {
            for (int i = 0; i < children.length; i++) {
                sb.append(children[i].getTokenString(prefix));
            }
        }
        return sb.toString();
    }


    public String getTokenString(String prefix) {
        StringBuffer sb = new StringBuffer();
        for (Token t = firstToken; t != null; t = t.next) {
//            Token st = t.specialToken;
//            if (st != null) {
//                while (st.specialToken != null) {
//                    st = st.specialToken;
//                }
//                while (st != null) {
//                    out.print(st.image);
//                    st = st.next;
//                }
//            }
            switch (t.kind) {
                case FunParserConstants.LSTATIC:
                case FunParserConstants.LSTATICW:
                case FunParserConstants.LLITERAL:
                case FunParserConstants.STATIC_0:
                case FunParserConstants.STATIC_1:
                case FunParserConstants.STATIC_2:
                case FunParserConstants.STATIC_4:
                case FunParserConstants.STATIC_5:
                    sb.append(t.image);
                    sb.append('\n');
                    prefix = prefix + indent;
                    sb.append(prefix);
                    break;

                case FunParserConstants.RSTATIC:
                case FunParserConstants.RSTATICW:
                case FunParserConstants.RLITERAL:
                case FunParserConstants.STATIC_3:
                case FunParserConstants.LITERAL_1:
                    sb.append('\n');
                    if (prefix.length() > 4) {
                        prefix = prefix.substring(4);
                    } else {
                        prefix = "";
                    }
                    if (prefix.length() > 0) {
                        prefix = prefix.substring(4);
                        sb.append(prefix);
                    }
                    sb.append(t.image);
                    sb.append('\n');
                    break;

                case FunParserConstants.DOT:
                case FunParserConstants.LPAREN:
                case FunParserConstants.LCODE:
                case FunParserConstants.LBRACKET:
                    sb.append(t.image);
                    break;

                case FunParserConstants.SEMICOLON:
                case FunParserConstants.NULL_BLOCK:
                case FunParserConstants.ABSTRACT_NULL:
                case FunParserConstants.EXTERNAL_BLOCK:
                    sb.append(t.image);
                    sb.append('\n');
                    if (prefix.length() > 0) {
                        sb.append(prefix);
                    }
                    break;

                default:
                    sb.append(t.image);
                    if (t.next != null) {
                        switch (t.next.kind) {
                            case FunParserConstants.DOT:
                            case FunParserConstants.COMMA:
                            case FunParserConstants.LPAREN:
                            case FunParserConstants.RPAREN:
                            case FunParserConstants.LBRACKET:
                            case FunParserConstants.RBRACKET:
                            case FunParserConstants.LCODE:
                            case FunParserConstants.RCODE:
                                break;
                            case FunParserConstants.ADOPT:
                            case FunParserConstants.KEEP:
                            case FunParserConstants.EXTERN:
                            case FunParserConstants.FOR:
                            case FunParserConstants.IF:
                            case FunParserConstants.ELSE:
                            case FunParserConstants.SUB:
                            case FunParserConstants.SUPER:
                            case FunParserConstants.OWNER:
                            case FunParserConstants.CONTAINER:
                            case FunParserConstants.THIS:
                            case FunParserConstants.CATCH:
                                sb.append('\n');
                                if (prefix.length() > 0) {
                                    sb.append(prefix);
                                }
                                break;
                            default:
                                sb.append(' ');
                                break;
                        }
                    }
                    break;
            }
            if (t == lastToken) {
                break;
            }
        }

        return sb.toString();
    }

    public String toString() {
        return toString("");
    }

    public String toString(String prefix) {
        if (firstToken != null) {
            return getTokenString(prefix);
        } else {
            return (prefix + "!!!Node of type " + getClass().getName() + "!!!\n");
        }
    }

    protected void log(String str) {
        SiteBuilder.log(str);
    }

    protected void vlog(String str) {
        SiteBuilder.vlog(str);
    }

    public Token getFirstToken() {
        return firstToken;
    }

    public Token getLastToken() {
        return lastToken;
    }

    public void setFirstToken(Token token) {
        firstToken = token;
    }

    public void setLastToken(Token token) {
        lastToken = token;
    }

    //
    // The remaining methods in this class are Node methods.  The Node interface is
    // dictated by jjtree, hence the jjt prefix on all method names (save one, the
    // childrenAccept method.  Oh, well.  I know how it goes.  Sometimes as a
    // programmer you find yourself in a stupid-looking rut, like putting prefixes
    // on methods, and you finally get to the point at which you just can't bring
    // yourself to do it yet again.  Of course, that only leaves you with something
    // even more stupid looking: a bunch of methods with a silly prefix and one odd
    // method without the prefix.)
    //
    // The code below is based on the equivalent methods in SimpleNode.java, which
    // was generated by jjtree.
    //

    public void jjtOpen() {}

    public void jjtClose() {
        // all children have now been added; call the node's init method if
        // it has one
        if (this instanceof Initializable) {
            ((Initializable) this).init();
        }
    }

    public void jjtSetParent(Node n) {
        parent = (AbstractNode) n;
    }

    public Node jjtGetParent() {
        return parent;
    }

    public void jjtAddChild(Node node, int i) {
        AbstractNode n = (AbstractNode) node;
        if (children == null) {
            children = new AbstractNode[i + 1];
        } else if (i >= children.length) {
            AbstractNode c[] = new AbstractNode[i + 1];
            System.arraycopy(children, 0, c, 0, children.length);
            children = c;
        }
        children[i] = n;
    }

    public void jjtClear() {
        children = null;
        parent = null;
    }

    public Node jjtGetChild(int i) {
        return children[i];
    }

    public int jjtGetNumChildren() {
        return (children == null) ? 0 : children.length;
    }

    /** Accept the visitor. **/
    public Object jjtAccept(FunParserVisitor visitor, Object data) {
        //return visitor.visit(this, data);
        //System.out.println("jjtAccept on this class (FunNode) should never be called!");
        return data;
    }

    /** Accept the visitor. **/
    public Object childrenAccept(FunParserVisitor visitor, Object data) {
        if (children != null) {
            for (int i = 0; i < children.length; i++) {
                children[i].jjtAccept(visitor, data);
            }
        }
        return data;
    }
}
