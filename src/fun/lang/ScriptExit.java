/* Fun
 *
 * $Id: Redirection.java,v 1.13 2014/12/15 14:10:26 sthippo Exp $
 *
 * Copyright (c) 2002-2017 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.lang;

/**
 *  A ScriptExit is a Redirection thrown by instantiating exit(n).
 *
 **/

public class ScriptExit extends Redirection {
    private static final long serialVersionUID = 1L;

    
    public static void exit(int exitCode) throws ScriptExit {
        throw new ScriptExit(exitCode);
    }
    
    private String textOut = "";
    
    public ScriptExit(int exitCode) {
        super(exitCode, "", "Exiting with code " + exitCode);
    }
    
    public void setTextOut(String textOut) {
        this.textOut = textOut; 
    }

    public String getTextOut() {
    	return textOut;
    }
}
