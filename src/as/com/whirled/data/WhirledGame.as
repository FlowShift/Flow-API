//
// $Id$
//
// Copyright (c) 2007 Three Rings Design, Inc. Please do not redistribute.

package com.whirled.data {

/**
 * Games that wish to make use of Whirled game services should have their {@link GameObject}
 * derivation implement this interface.
 */
public interface WhirledGame
{
    /**
     * Returns the {@link WhirledGameService} used by this game.
     */
    function getWhirledGameService () :WhirledGameMarshaller;
}
}
