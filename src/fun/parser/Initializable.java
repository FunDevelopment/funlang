/* Fun Compiler and Runtime Engine
 * Initializable.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.parser;


/**
 * Interface for parsed nodes which need to be initialized by the Initializer visitor.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.4 $
 */
public interface Initializable {
    public void init();
}
