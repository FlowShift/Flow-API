// Whirled contrib library - tools for developing whirled games
// http://www.whirled.com/code/contrib/asdocs
//
// This library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this library.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008 Three Rings Design
//
// $Id$

package com.whirled.contrib.platformer.game {

import com.whirled.contrib.platformer.board.ColliderDetails;
import com.whirled.contrib.platformer.board.SimpleActorBounds;

import com.whirled.contrib.platformer.piece.Actor;
import com.whirled.contrib.platformer.piece.Shot;

public class ShotCollisionHandler extends CollisionHandler
{
    public function ShotCollisionHandler ()
    {
        super(ActorController);
    }

    override public function collide (source :Object, target :Object, cd :ColliderDetails) :void
    {
        pCollide(source as Shot, target as SimpleActorBounds, cd);
    }

    protected function pCollide (s :Shot, sab :SimpleActorBounds, cd :ColliderDetails) :void
    {
        if (cd.alines[0] == null || sab.actor.doesHit(cd.alines[0].x1, cd.alines[0].y1)) {
            s.hit = true;
            if (cd.alines[0] != null && Math.abs(cd.alines[0].nx) > 0) {
                sab.actor.wasHit =
                    ((cd.alines[0].nx > 0 && (sab.actor.orient & Actor.ORIENT_RIGHT) > 0) ||
                     (cd.alines[0].nx < 0 && (sab.actor.orient & Actor.ORIENT_RIGHT) == 0)) ?
                    Actor.HIT_FRONT : Actor.HIT_BACK;
            } else {
                if (s.dx == 0) {
                    sab.actor.wasHit = Actor.HIT_FRONT;
                } else if ((s.dx < 0 && (sab.actor.orient & Actor.ORIENT_RIGHT) > 0) ||
                    (s.dx > 0 && (sab.actor.orient & Actor.ORIENT_RIGHT) == 0)) {
                    sab.actor.wasHit = Actor.HIT_FRONT;
                } else {
                    sab.actor.wasHit = Actor.HIT_BACK;
                }
            }
            sab.actor.health -= s.damage;
        } else {
            s.ttl = 0;
        }
    }
}
}
