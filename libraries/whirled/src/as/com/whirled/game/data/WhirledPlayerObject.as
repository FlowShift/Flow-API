//
// $Id$

package com.whirled.game.data {

import com.threerings.io.ObjectInputStream;
import com.threerings.presents.dobj.DSet;
import com.threerings.crowd.data.BodyObject;

/**
 * Body for playing whirled games.
 */
public class WhirledPlayerObject extends BodyObject
{
    // AUTO-GENERATED: FIELDS START
    /** The field name of the <code>gameContent</code> field. */
    public static const GAME_CONTENT :String = "gameContent";
    // AUTO-GENERATED: FIELDS END

    /** Messages containing private inter-player messages begin with this. */
    public static const PRIVATE_USER_MESSAGE_PREFIX :String  = "Umsg:";

    /** Ident for <code>GameData.RESOLUTION_MARKER</code> content during resolution. */
    public static const RESOLVING :String = "resolving";

    /** Ident for <code>GameData.RESOLUTION_MARKER</code> content after resolution. */
    public static const RESOLVED :String = "resolved";

    /** Contains information on player's ownership of game content (populated lazily). */
    public var gameContent :DSet; /* of */ GameContentOwnership;

    /**
     * Computes the name for private user messages for a given game id.
     */
    public static function getMessageName (gameId :int) :String
    {
        return PRIVATE_USER_MESSAGE_PREFIX + gameId;
    }

    /**
     * Checks if a the name of a private user message is from the given game id.
     */
    public static function isFromGame (eventName :String, gameId :int) :Boolean
    {
        return eventName == getMessageName(gameId);
    }

    /**
     * Returns true if content is resolved for the specified game, false if it is not yet ready.
     */
    public function isContentResolved (gameId :int) :Boolean
    {
        return ownsGameContent(gameId, GameData.RESOLUTION_MARKER, RESOLVED);
    }

    /**
     * Returns true if this player owns the specified piece of game content. <em>Note:</em> the
     * content must have previously been resolved, which happens when the player enters the game in
     * question.
     */
    public function ownsGameContent (gameId :int, type :int, ident :String) :Boolean
    {
        var key :GameContentOwnership = new GameContentOwnership();
        key.gameId = gameId;
        key.type = type;
        key.ident = ident;
        return gameContent.containsKey(key);
    }

    // from BodyObject
    override public function readObject (ins :ObjectInputStream) :void
    {
        super.readObject(ins);
        gameContent = DSet(ins.readObject());
    }
}
}
