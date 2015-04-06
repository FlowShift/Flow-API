//
// $Id$

package com.whirled.game;

/**
 * Implement this interface to automagically be registered to received
 * PropertyChangedEvents.
 */
public interface PropertyChangedListener
{
    /**
     * Handle a PropertyChangedEvent.
     */
    public void propertyChanged (PropertyChangedEvent event);
}
