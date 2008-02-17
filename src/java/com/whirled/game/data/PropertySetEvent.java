//
// $Id$

package com.whirled.game.data;

import java.io.IOException;

import com.threerings.io.ObjectInputStream;
import com.threerings.io.ObjectOutputStream;
import com.threerings.io.Streamable;
import com.threerings.io.Streamer;
import com.threerings.util.ActionScript;
 
import com.threerings.presents.dobj.DObject;
import com.threerings.presents.dobj.NamedEvent;

import com.whirled.game.util.ObjectMarshaller;

/**
 * Represents a property change on the actionscript object we use in WhirledGameObject.
 */
@ActionScript(omit=true)
public class PropertySetEvent extends NamedEvent
{
    /** Suitable for unserialization. */
    public PropertySetEvent ()
    {
    }

    /**
     * Create a PropertySetEvent.
     */
    public PropertySetEvent (int targetOid, String propName, Object value, int index, Object ovalue)
    {
        super(targetOid, propName);
        _data = value;
        _index = index;
        _oldValue = ovalue;
    }

    /**
     * Returns the value that was set for the property.
     */
    public Object getValue ()
    {
        return _data;
    }

    /**
     * Returns the old value.
     */
    public Object getOldValue ()
    {
        return _oldValue;
    }

    /**
     * Returns the index, or -1 if not applicable.
     */
    public int getIndex ()
    {
        return _index;
    }

    // from abstract DEvent
    public boolean applyToObject (DObject target)
    {
        WhirledGameObject gameObj = (WhirledGameObject) target;
        if (!gameObj.isOnServer()) {
            _data = ObjectMarshaller.decode(_data);
        }
        if (_oldValue == UNSET_OLD_VALUE) {
            // only apply the property change if we haven't already
            _oldValue = gameObj.applyPropertySet(_name, _data, _index);
        }
        return true;
    }

    @Override
    protected void notifyListener (Object listener)
    {
        if (listener instanceof PropertySetListener) {
            ((PropertySetListener) listener).propertyWasSet(this);
        }
    }

    @Override @ActionScript(name="toStringBuf")
    protected void toString (StringBuilder buf)
    {
        buf.append("PropertySetEvent ");
        super.toString(buf);
        buf.append(", index=").append(_index);
    }

    /** The index of the property, if applicable. */
    protected int _index;

    /** The client-side data that is assigned to this property. */
    protected Object _data;

    /** The old value. */
    protected transient Object _oldValue = UNSET_OLD_VALUE;
}
