//
// $Id$

package com.whirled.game.data;

import com.threerings.util.ActionScript;

/**
 * Models a parameter that allows the toggling of a single value.
 */
public class ToggleParameter extends Parameter
{
    /** The starting state for this parameter. */
    public boolean start;

    @Override @ActionScript(omit=true) // documentation inherited
    public String getLabel ()
    {
        return "m.toggle_" + ident;
    }

    @Override // documentation inherited
    public Object getDefaultValue ()
    {
        return start;
    }
}
