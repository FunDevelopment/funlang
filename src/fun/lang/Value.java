/* Fun Compiler and Runtime Engine
 * Value.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;


/**
 * Interface for objects which can participate in expressions.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.8 $
 */

public interface Value extends ValueSource {

    public String getString();

    public boolean getBoolean();

    public byte getByte();

    public char getChar();

    public int getInt();

    public long getLong();

    public double getDouble();

    public Object getValue();

    public Class<?> getValueClass();
}
