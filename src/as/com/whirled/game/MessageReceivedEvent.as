//
// $Id$

package com.whirled.game {

import flash.events.Event;

/**
 * Dispatched on the 'net' subcontrol when a message is sent by any client.
 */
public class MessageReceivedEvent extends Event
{
    /**
     * The type of all MessageReceivedEvents.
     *
     * @eventType MsgReceived
     */
    public static const MESSAGE_RECEIVED :String = "MsgReceived";

    /**
     * Access the message name.
     */
    public function get name () :String
    {
        return _name;
    }

    /**
     * Access the message value.
     */
    public function get value () :Object
    {
        return _value;
    }

    public function MessageReceivedEvent (messageName :String, value :Object)
    {
        super(MESSAGE_RECEIVED);
        _name = messageName;
        _value = value;
    }

    override public function toString () :String
    {
        return "[MessageReceivedEvent name=" + _name + ", value=" + _value + "]";
    }

    override public function clone () :Event
    {
        return new MessageReceivedEvent(_name, _value);
    }

    /** @private */
    protected var _name :String;

    /** @private */
    protected var _value :Object;
}
}
