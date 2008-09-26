//
// $Id$
//
// Copyright (c) 2007 Three Rings Design, Inc. Please do not redistribute.

package com.whirled.game.server;

import com.threerings.presents.client.InvocationService;
import com.threerings.presents.data.ClientObject;
import com.threerings.presents.server.InvocationException;
import com.threerings.presents.server.InvocationProvider;
import com.whirled.game.client.PrizeService;

/**
 * Defines the server-side of the {@link PrizeService}.
 */
public interface PrizeProvider extends InvocationProvider
{
    /**
     * Handles a {@link PrizeService#awardPrize} request.
     */
    void awardPrize (ClientObject caller, String arg1, int arg2, InvocationService.InvocationListener arg3)
        throws InvocationException;

    /**
     * Handles a {@link PrizeService#awardTrophy} request.
     */
    void awardTrophy (ClientObject caller, String arg1, int arg2, InvocationService.InvocationListener arg3)
        throws InvocationException;
}
