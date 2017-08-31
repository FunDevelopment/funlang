/* Fun
 *
 * $Id: FunFile.java,v 1.9 2014/12/05 14:11:57 sthippo Exp $
 *
 * Copyright (c) 2006-2014 by fundev.org
 *
 * Use of this code in source or compiled form is subject to the
 * Fun Poetic License at http://www.fundev.org/poetic-license.html
 */

package fun.runtime;

import java.io.*;

/**
 * File support for Fun.
 *
 * @author Michael St. Hippolyte
 * @version $Revision: 1.9 $
 */

public class FunFile {
    private File file;
    private Throwable monkeyWrench = null;

    public FunFile(String base, String path) {
        file = new File(base, path);
    }
    
    public FunFile(String path) {
        file = new File(path);
    }
    
    public FunFile(FunFile base, String path) {
        file = new File(base.file, path);
    }
    
    public FunFile(FunFile file) {
        this.file = file.file;
    }
    
    public FunFile(File file) {
        this.file = file;
    }
    
    public String name() {
        return file.getName();
    }
    
    public String error_message() {
        if (monkeyWrench == null) {
            return null;
        } else {
            return monkeyWrench.toString();
        }
    }
    
    public String absolute_path() {
        String path = file.getAbsolutePath();
        return path;
    }
    
    public String canonical_path() {
        try  {
            String path = file.getCanonicalPath();
            return path;
        } catch (Throwable t) {
            monkeyWrench = t;
            return null;
        }
    }
    
    public String[] list() {
        String[] files = file.list();
        return files;
    }
    
    public FunFile[] files() {
        FunFile[] funFiles = null;
        File[] javaFiles = file.listFiles();
        if (javaFiles != null) {
            int len = javaFiles.length;
            funFiles = new FunFile[len];
            for (int i = 0; i < len; i++) {
                funFiles[i] = new FunFile(javaFiles[i]);
            }
        }
        return funFiles;
    }

    public String contents() {
        try {
            return Utils.getFileContents(file);
        } catch (Throwable t) {
            monkeyWrench = t;
            return null;
        }
    }
    
    
    public boolean overwrite(String newContents) {
        try {
            Utils.writeToFile(file, newContents);
            return true;
        } catch (Throwable t) {
            monkeyWrench = t;
            return false;
        }
    }

    public boolean overwrite(String[] newLines) {
        try {
            Utils.writeToFile(file, newLines);
            return true;
        } catch (Throwable t) {
            monkeyWrench = t;
            return false;
        }
    }

    public boolean append(String newContents) {
        try {
            Utils.appendToFile(file, newContents);
            return true;
        } catch (Throwable t) {
            monkeyWrench = t;
            return false;
        }
    }

    public boolean append(String[] newLines) {
        try {
            Utils.appendToFile(file, newLines);
            return true;
        } catch (Throwable t) {
            monkeyWrench = t;
            return false;
        }
    }

    public boolean readable() {
        try  {
            return file.canRead();
        } catch (Throwable t) {
            monkeyWrench = t;
            return false;
        }
    }

    public boolean writeable() {
        try  {
            return file.canWrite();
        } catch (Throwable t) {
            monkeyWrench = t;
            return false;
        }
    }

    public boolean exists() {
        try  {
            return file.exists();
        } catch (Throwable t) {
            monkeyWrench = t;
            return false;
        }
    }

    public boolean delete() {
        try  {
            return file.delete();
        } catch (Throwable t) {
            monkeyWrench = t;
            return false;
        }
    }

    public boolean is_dir() {
        try  {
            return file.isDirectory();
        } catch (Throwable t) {
            monkeyWrench = t;
            return false;
        }
    }

    public boolean is_file() {
        try  {
            return file.isFile();
        } catch (Throwable t) {
            monkeyWrench = t;
            return false;
        }
    }

    public boolean is_hidden() {
        try  {
            return file.isHidden();
        } catch (Throwable t) {
            monkeyWrench = t;
            return false;
        }
    }

    public long modified() {
        try  {
            return file.lastModified();
        } catch (Throwable t) {
            monkeyWrench = t;
            return -1L;
        }
    }

    public long length() {
        try  {
            return file.length();
        } catch (Throwable t) {
            monkeyWrench = t;
            return -1L;
        }
    }

    public boolean mkdir() {
        try  {
            // note: we call mkdirs instead of mkdir to make all the 
            // intermediate directories if needed
            return file.mkdirs();
        } catch (Throwable t) {
            monkeyWrench = t;
            return false;
        }
    }

    public boolean rename(String newName) {
        try  {
            return file.renameTo(new File(newName));
        } catch (Throwable t) {
            monkeyWrench = t;
            return false;
        }
    }
    
    public File toFile() {
        return file;
    }
}

