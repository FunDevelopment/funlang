/* Fun Compiler and Runtime Engine
 * XorOperator.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;


/**
 * Exclusive or operator.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.5 $
 */
public class XorOperator extends BitwiseOperator {

    public boolean operate(boolean op1, boolean op2) {
        return op1 ^ op2;
    }

    public byte operate(byte op1, byte op2) {
        return (byte)(op1 ^ op2);
    }

    public char operate(char op1, char op2) {
        return (char)(op1 ^ op2);
    }

    public int operate(int op1, int op2) {
        return op1 ^ op2;
    }

    public long operate(long op1, long op2) {
        return op1 ^ op2;
    }

    public String toString() {
        return " ^ ";
    }
}
