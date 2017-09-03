/* Fun Compiler and Runtime Engine
 * Redirection.java
 *
 * Copyright (c) 2017 by Fun Development
 * All rights reserved.
 */

package fun.lang;

import fun.runtime.FunObjectWrapper;
import fun.runtime.Context;

/**
 *  A Redirection is thrown by a Fun <code>redirect</code> statement.  This
 *  interrupts the construction of the page and leads to a HTTP redirect.
 */
public class Redirection extends Throwable {
    
    private static final long serialVersionUID = 1L;

    public static final String STANDARD_ERROR = "error";
    public static final String STANDARD_ERROR_PAGE = "/error_page";
    public static final String STANDARD_ERROR_DIV = "/$error_div";
    
    public static final int SERVER_ERROR_STATUS = 500;

    private int status = 307;  // 307 == temporary redirect
    private String location;
    private String message;
    private ResolvedInstance instance;
    
    public Redirection(Instantiation instance, Context context) {
        super();
        this.instance = new ResolvedInstance(instance, context, false);
        Type type = this.instance.getType();
        if (type.isTypeOf("error")) {
            FunObjectWrapper obj = new FunObjectWrapper(this.instance, null);
            status = obj.getChildInt("status");
            message = obj.getChildText("message");
        } else {
            message = null;
        }
        location = null;
        fun.runtime.SiteBuilder.vlog("Creating redirection to instance: " + instance.getName());
    }
    
    public Redirection(String location) {
        super();
        this.location = location;
        message = null;
        instance = null;
        fun.runtime.SiteBuilder.vlog("Creating redirection to location: " + location);
    }

    public Redirection(String location, String message) {
        super(message);
        this.location = location;
        this.message = message;
        fun.runtime.SiteBuilder.vlog("Creating redirection to location: " + location + " with message: " + message);
    }

    public Redirection(int status, String location, String message) {
        super(message);
        this.status = status;
        this.location = location;
        this.message = message;
        fun.runtime.SiteBuilder.vlog("Creating redirection to location: " + location + " with message: " + message + " and status: " + status);
    }

    public int getStatus() {
        return status;
    }

    public String getLocation() {
        if (instance != null) {
            return instance.getString();
        } else {
            return location;
        }
    }

    public String getMessage() {
        return message;
    }

    public void setLocation(String location) {
    	this.location = location;
    }
}
