/* Fun
 *
 * $Id: Value.java,v 1.8 2011/08/12 21:17:59 sthippo Exp $
 *
 * Copyright (c) 2002-2011 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
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
