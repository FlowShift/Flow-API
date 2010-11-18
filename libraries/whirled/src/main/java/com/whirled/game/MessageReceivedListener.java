//
// $Id$

package com.whirled.game;

/**
 * Implement this interface to automagically be registered to received
 * MessageReceivedEvents.
 */
public interface MessageReceivedListener
{
    /**
     * Handle a MessageReceivedEvent.
     */
    public void messageReceived (MessageReceivedEvent event);
}
