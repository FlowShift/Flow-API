//
// $Id$
//
// Copyright (c) 2007 Three Rings Design, Inc.  Please do not redistribute.

package com.whirled {

import flash.display.DisplayObject;

/**
 * Dispatched when a game-global state property has changed.
 * 
 * @eventType com.whirled.PropertyChangedEvent.PROPERTY_CHANGED
 */
[Event(name="propertyChanged", type="com.whirled.PropertyChangedEvent")]

/**
 * Dispatched when a player-local state property has changed.
 * 
 * @eventType com.whirled.PlayerPropertyChangedEvent.PLAYER_PROPERTY_CHANGED
 */
[Event(name="playerPropertyChanged", type="com.whirled.PlayerPropertyChangedEvent")]

/**
 * Dispatched when a message has been received.
 * 
 * @eventType com.whirled.MessageReceivedEvent.MESSAGE_RECEIVED
 */
[Event(name="msgReceived", type="com.whirled.MessageReceivedEvent")]

/**
 * This file should be included by AVR games so that they can communicate
 * with the whirled.
 *
 * AVRGame means: Alternate Virtual Reality Game, and refers to games
 * played within the whirled environment.
 */
public class AVRGameControl extends WhirledControl
{
    /**
     * Create a world game interface. The display object is your world game.
     */
    public function AVRGameControl (disp :DisplayObject)
    {
        super(disp);
    }

    public function getProperty (key :String) :Object
    {
        return callHostCode("getProperty_v1", key);
    }

    public function setProperty (key :String, value :Object, persistent :Boolean) :Boolean
    {
        return callHostCode("setProperty_v1", key, value, persistent);
    }

    public function getPlayerProperty (key :String) :Object
    {
        return callHostCode("getPlayerProperty_v1", key);
    }

    public function setPlayerProperty (key :String, value :Object, persistent :Boolean) :Boolean
    {
        return callHostCode("setPlayerProperty_v1", key, value, persistent);
    }

    public function sendMessage (key :String, value :Object, playerId :int = 0) :Boolean
    {
        return callHostCode("sendMessage_v1", key, value, playerId);
    }

    public function offerQuest (questId :String, initialStatus :String) :Boolean
    {
        return callHostCode("offerQuest_v1", questId, initialStatus);
    }

    public function updateQuest (questId :String, step :int, status :String) :Boolean
    {
        return callHostCode("updateQuest_v1", questId, step, status);
    }

    public function completeQuest (questId :String, payoutLevel :int) :Boolean
    {
        return callHostCode("completeQuest_v1", questId, payoutLevel);
    }

    public function cancelQuest (questId :String) :Boolean
    {
        return callHostCode("cancelQuest_v1", questId);
    }

    public function getActiveQuests () :Array
    {
        return callHostCode("getActiveQuests_v1");
    }

    override protected function isAbstract () :Boolean
    {
        return false;
    }

    override protected function populateProperties (o :Object) :void
    {
        super.populateProperties(o);

        o["stateChanged_v1"] = stateChanged_v1;
        o["playerStateChanged_v1"] = playerStateChanged_v1;
        o["messageReceived_v1"] = messageReceived_v1;
    }

    /**
     * Called when a game-global state property has changed.
     */
    protected function stateChanged_v1 (key :String, value :Object) :void
    {
        dispatchEvent(new PropertyChangedEvent(key, value));
    }

    /**
     * Called when a player-local state property has changed.
     */
    protected function playerStateChanged_v1 (key :String, value :Object) :void
    {
        dispatchEvent(new PlayerPropertyChangedEvent(key, value));
    }

    /**
     * Called when a user message has arrived.
     */
    protected function messageReceived_v1 (key :String, value :Object) :void
    {
        dispatchEvent(new MessageReceivedEvent(key, value));
    }
}
}
