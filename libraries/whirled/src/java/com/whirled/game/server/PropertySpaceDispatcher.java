//
// $Id$
//
// Copyright (c) 2007 Three Rings Design, Inc. Please do not redistribute.

package com.whirled.game.server;

import com.threerings.presents.client.InvocationService;
import com.threerings.presents.data.ClientObject;
import com.threerings.presents.server.InvocationDispatcher;
import com.threerings.presents.server.InvocationException;
import com.whirled.game.data.PropertySpaceMarshaller;

/**
 * Dispatches requests to the {@link PropertySpaceProvider}.
 */
public class PropertySpaceDispatcher extends InvocationDispatcher<PropertySpaceMarshaller>
{
    /**
     * Creates a dispatcher that may be registered to dispatch invocation
     * service requests for the specified provider.
     */
    public PropertySpaceDispatcher (PropertySpaceProvider provider)
    {
        this.provider = provider;
    }

    @Override // documentation inherited
    public PropertySpaceMarshaller createMarshaller ()
    {
        return new PropertySpaceMarshaller();
    }

    @Override // documentation inherited
    public void dispatchRequest (
        ClientObject source, int methodId, Object[] args)
        throws InvocationException
    {
        switch (methodId) {
        case PropertySpaceMarshaller.SET_PROPERTY:
            ((PropertySpaceProvider)provider).setProperty(
                source, (String)args[0], args[1], (Integer)args[2], ((Boolean)args[3]).booleanValue(), ((Boolean)args[4]).booleanValue(), args[5], (InvocationService.InvocationListener)args[6]
            );
            return;

        default:
            super.dispatchRequest(source, methodId, args);
            return;
        }
    }
}
