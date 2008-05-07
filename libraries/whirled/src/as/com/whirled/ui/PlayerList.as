//
// $Id$
//

package com.whirled.ui {

import mx.collections.ArrayCollection;
import mx.collections.Sort;

import mx.containers.VBox;

import mx.core.ClassFactory;
import mx.core.ScrollPolicy;

import com.threerings.util.Comparable;
import com.threerings.util.Hashable;
import com.threerings.util.HashMap;
import com.threerings.util.Name;

import com.threerings.flex.AmbidextrousList;

public class PlayerList extends VBox
{
    /**
     * Create a new player list. 
     *
     * @param labelCreator If null, will use a default implementation that does nothing special
     *                     with text formatting or click behavior.
     */
    public function PlayerList (labelCreator :NameLabelCreator = null) :void
    {
        _labelCreator = labelCreator;
        if (_labelCreator == null) {
            _labelCreator = new DefaultNameLabelCreator();
        }

        // set up the UI
        width = 280;
        height = 125;
        _list = new AmbidextrousList();
        _list.verticalScrollPolicy = ScrollPolicy.ON;
        _list.selectable = false; 
        _list.percentWidth = 100;
        _list.percentHeight = 100;
        _list.itemRenderer = new ClassFactory(getRenderingClass());
        _list.dataProvider = _players;
        _list.styleName = "playerList";

        addChild(_list);

        // set up the sort for the collection
        var sort :Sort = new Sort();
        sort.compareFunction = sortFunction;
        _players.sort = sort;
        _players.refresh();
    }

    public function get scrollBarOnLeft () :Boolean
    {
        return _list.scrollBarOnLeft;
    }

    public function set scrollBarOnLeft (onLeft :Boolean) :void
    {
        _list.scrollBarOnLeft = onLeft;
    }

    public function clear () :void
    {
        _values.clear();
        _players.removeAll();
    }

    /**
     * The PlayerList is meant to include data that is at least as complicated as a Name, so to 
     * keep things simple and extendable, we require Hashable.  This allows the issue of passing
     * the NameLabelCreator into the player renderer to be kept simple and straightforward and still
     * allow efficient item updating.
     */
    public function addItem (value :Hashable) :void
    {
        var currentValue :Array = _values.get(value) as Array;
        if (currentValue != null) {
            currentValue[1] = value;
            // this is the same array already contained in the list, so the proper renderer should
            // be notified of the new value.
            _players.itemUpdated(currentValue);
        } else {
            currentValue = [_labelCreator, value];
            _values.put(value, currentValue);
            _players.addItem(currentValue);
        }
    }

    public function removeItem (value :Hashable) :void
    {
        var currentValue :Array = _values.remove(value) as Array;
        if (currentValue != null) {
            _players.removeItemAt(_players.getItemIndex(currentValue));
        }
    }

    /**
     * Notify the list that this value has changed internally, and the renderer should be told to 
     * redraw its contents.
     */
    public function itemUpdated (value :Hashable) :void
    {
        var currentValue :Array = _values.get(value) as Array;
        if (currentValue != null) {
            currentValue[1] = value;
            _players.itemUpdated(currentValue);
        }
    }

    protected function getRenderingClass () :Class
    {
        return PlayerRenderer; 
    }

    protected function sortFunction (o1 :Object, o2 :Object, fields :Array = null) :int
    {
        if (!(o1 is Array) || !(o2 is Array)) {
            return 0;
        }

        var data1 :Object = (o1 as Array)[1];
        var data2 :Object = (o2 as Array)[1];
        if (data1 is Name && data2 is Name) {
            var compare :int = 
                data1.toString().toLowerCase().localeCompare(data2.toString().toLowerCase());
            return compare > 0 ? 1 : (compare < 0 ? -1 : 0);
        } else if (data1 is Comparable && data2 is Comparable) {
            compare = (data1 as Comparable).compareTo(data2);
            return compare > 0 ? 1 : (compare < 0 ? -1 : 0);
        } else {
            // default to actionscript's magical greater than or less than operators
            return data1 > data2 ? -1 : (data1 < data2 ? 1 : 0);
        }
    }

    protected var _labelCreator :NameLabelCreator;
    protected var _list :AmbidextrousList;
    protected var _players :ArrayCollection = new ArrayCollection();
    protected var _values :HashMap = new HashMap();
}
}

import mx.containers.HBox;

import mx.controls.Label;

import mx.core.ScrollPolicy;
import mx.core.UIComponent;

import com.whirled.ui.NameLabelCreator;

import com.threerings.util.Name;

class DefaultNameLabelCreator implements NameLabelCreator
{
    public function createLabel (name :Name) :UIComponent
    {
        var label :Label = new Label();
        label.text = "" + name;
        return label;
    }
}

/**
 * A renederer for lists that contain Names.
 */
class PlayerRenderer extends HBox
{
    public function PlayerRenderer ()
    {
        super();

        verticalScrollPolicy = ScrollPolicy.OFF;
        horizontalScrollPolicy = ScrollPolicy.OFF;
        setStyle("backgroundAlpha", 0);
        // the horizontalGap should be 8...
    }

    override public function set data (value :Object) :void
    {
        super.data = value;

        if (processedDescriptors) {
            configureUI();
        }
    }

    override protected function createChildren () :void
    {
        super.createChildren();

        configureUI();
    }

    /**
     * Update the UI elements with the data we're displaying.
     */
    protected function configureUI () :void
    {
        removeAllChildren();

        if (this.data != null && (this.data is Array) && (this.data as Array).length == 2) {
            var dataArray :Array = this.data as Array;
            var creator :NameLabelCreator = dataArray[0] as NameLabelCreator;
            var name :Name = dataArray[1] as Name;
            if (creator != null && name != null) {
                addChild(creator.createLabel(name));
            }
        }
    }
}
