package com.whirled.contrib.core.util {

import com.threerings.util.Set;

import flash.utils.Dictionary;

public class ObjectSet
    implements Set
{
    public function add (o :Object) :Boolean
    {
        if (this.contains(o)) {
            return false;
        } else {
            _dict[o] = null;
            ++_size;
            return true;
        }
    }

    public function remove (o :Object) :Boolean
    {
        if (this.contains(o)) {
            delete _dict[o];
            --_size;
            return true;
        } else {
            return false;
        }
    }

    public function clear () :void
    {
        for (var key :* in _dict) {
            delete _dict[key];
        }

        _size = 0;
    }

    public function contains (o :Object) :Boolean
    {
        return (undefined !== _dict[o]);
    }

    public function size () :int
    {
        return _size;
    }

    public function isEmpty () :Boolean
    {
        return (0 == _size);
    }

    public function toArray () :Array
    {
        var arr :Array = new Array();

        for (var key :* in _dict) {
            arr.push(key);
        }

        return arr;
    }
    
    public function forEach (callback :Function, thisObject :* = null) :void
    {
        for (var key :* in _dict) {
            callback.call(thisObject, key);
        }
    }

    protected var _dict :Dictionary = new Dictionary();
    protected var _size :int = 0;
}

}
