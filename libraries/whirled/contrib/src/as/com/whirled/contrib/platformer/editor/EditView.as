//
// $Id$

package com.whirled.contrib.platformer.editor {

import flash.display.Sprite;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import flash.utils.ByteArray;

import mx.containers.Canvas;
import mx.containers.HBox;
import mx.controls.Button;
import mx.controls.Label;
import mx.controls.RadioButton;
import mx.controls.RadioButtonGroup;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;

import com.threerings.flex.FlexWrapper;

import com.whirled.contrib.platformer.board.Board;

import com.whirled.contrib.platformer.display.Metrics;

import com.whirled.contrib.platformer.piece.Dynamic;
import com.whirled.contrib.platformer.piece.Piece;
import com.whirled.contrib.platformer.piece.PieceFactory;

import mx.core.Container;

public class EditView extends Canvas
{
    public static function makeButton (label :String, callback :Function) :Button
    {
        var button :Button = new Button();
        button.label = label;
        button.addEventListener(FlexEvent.BUTTON_DOWN, function (event :FlexEvent) :void {
            callback();
        });
        return button;
    }

    /**
     * In addition to requiring valid XML, the PieceSpriteFactory should have been initialized 
     * before this view is created.
     */
    public function EditView (container :Container, pieces :XML, dynamics :XML, level :XML)
    {
        Metrics.init(700, 500, 50);
        _container = container;

        _pfac = new PieceFactory(pieces);
        _board = new Board();
        _boardSprite = new BoardEditSprite(this);
        _board.loadFromXML(level, _pfac);
        _editSelector = new PieceSelector(_pfac);
        _dynamicSelector = new DynamicSelector(dynamics);
        _pieceTree = new PieceTree(_board);
        _dynamicTree = new DynamicTree(_board, dynamics);
        _editCoords = new Label();
        _boardSprite.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        width = 940;
        height = 710;

        _boardSprite.setBoard(_board);
        _editSelector.y = Metrics.DISPLAY_HEIGHT;
        addChild(_editSelector);
        _dynamicSelector.y = Metrics.DISPLAY_HEIGHT;
        _dynamicSelector.visible = false;
        addChild(_dynamicSelector);
        _editSelector.addEventListener(MouseEvent.DOUBLE_CLICK, addPiece);
        _dynamicSelector.addEventListener(MouseEvent.DOUBLE_CLICK, addDynamic);
        _pieceTree.x = Metrics.DISPLAY_WIDTH;
        _pieceTree.y = 20;
        addChild(_pieceTree);
        _pieceTree.addEventListener(ListEvent.CHANGE, treeSelection);
        _dynamicTree.x = Metrics.DISPLAY_WIDTH;
        _dynamicTree.visible = false;
        _dynamicTree.y = 20;
        addChild(_dynamicTree);
        _dynamicTree.addEventListener(ListEvent.CHANGE, dynamicSelection);
        var bs :FlexWrapper = new FlexWrapper(_boardSprite);
        addChild(bs);
        var rbg :RadioButtonGroup = new RadioButtonGroup();
        rbg.addEventListener(ItemClickEvent.ITEM_CLICK, modeClicked);
        var rb :RadioButton = new RadioButton();
        rb.label = "Pieces";
        rb.group = rbg;
        rb.x = Metrics.DISPLAY_WIDTH;
        rb.selected = true;
        addChild(rb);
        rb = new RadioButton();
        rb.label = "Dynamics";
        rb.group = rbg;
        rb.x = Metrics.DISPLAY_WIDTH + 100;
        addChild(rb);

        var box :HBox = new HBox();
        box.addChild(makeButton("-", function () :void {
            _boardSprite.changeScale(1);
        }));
        box.addChild(makeButton("+", function () :void {
            _boardSprite.changeScale(-1);
        }));
        box.addChild(makeButton("grid", function () :void {
            _boardSprite.toggleGrid();
        }));
        box.y = Metrics.DISPLAY_HEIGHT;
        box.x = 500;
        addChild(box);
        box = new HBox();
        box.addChild(makeButton("Redraw Level", function () :void {
            _boardSprite.resetPieceLayer();
        }));
        box.addChild(makeButton("Redraw Actors", function () :void {
            _boardSprite.resetActorLayer();
        }));
        box.y = Metrics.DISPLAY_HEIGHT + 35;
        box.x = 410;
        addChild(box);
        _editCoords.y = Metrics.DISPLAY_HEIGHT;
        _editCoords.x = 410;
        addChild(_editCoords);
    }

    public function getXML () :String
    {
        return _board.getXML().toXMLString();
    }

    public function selectItem (tree :String, name :String) :void
    {
        trace("selectItem " + tree + " " + name);
        getTree(tree).selectItem(tree, name);
    }

    protected function addPiece (event :MouseEvent) :void
    {
        var type :String = _editSelector.getRandomPiece();
        if (type == null) {
            return;
        }
        var xml :XML = <piece/>;
        xml.@type = type;
        xml.@x = Math.max(0, _boardSprite.getX());
        xml.@y = Math.max(0, _boardSprite.getY());
        xml.@id = _board.getMaxId() + 1;
        var p :Piece = _pfac.getPiece(xml);
        if (p == null) {
            return;
        }
        _pieceTree.addPiece(p);
    }

    protected function addDynamic (event :MouseEvent) :void
    {
        var type :String = _dynamicSelector.getSelectedItem();
        var group :String = _dynamicSelector.getGroup();
        if (type == null || group == null) {
            return;
        }
        var xml :XML = new XML("<" + group + "/>");
        xml.@type = type;
        xml.@x = Math.max(0, _boardSprite.getX());
        xml.@y = Math.max(
                0, _boardSprite.getY() + (group == Board.GROUP_NAMES[Board.ACTORS] ? 0.01 : 0));
        xml.@id = _board.getMaxId() + 1;
        for each (var cxml :XML in _dynamicSelector.getConst()) {
            xml["@" + cxml.@id] = cxml.@value;
        }
        var d :Dynamic = _board.loadDynamic(xml);
        if (d != null) {
            _dynamicTree.addDynamic(d, group);
        }
    }

    protected function treeSelection (event :ListEvent) :void
    {
        var name :String = _pieceTree.getSelected();
        if (name != null) {
            _boardSprite.selectSprite(_pieceTree.getTree(), name);
        }
    }

    protected function dynamicSelection (event :ListEvent) :void
    {
        var name :String = _dynamicTree.getSelected();
        if (name != null) {
            _boardSprite.selectSprite(_dynamicTree.getTree(), name);
        }
    }

    protected function mouseMoveHandler (event :MouseEvent) :void
    {
        _editCoords.text = "Coords (" + (_boardSprite.getMouseX()) + ", " +
                (_boardSprite.getMouseY()) + ")";
    }

    protected function modeClicked (event :ItemClickEvent) :void
    {
        _pieceTree.visible = (event.label == "Pieces");
        _editSelector.visible = (event.label == "Pieces");
        _dynamicTree.visible = (event.label == "Dynamics");
        _dynamicSelector.visible = (event.label == "Dynamics");
    }

    protected function getTree (tree :String) :BaseTree
    {
        var group :String = tree.substr(5);
        for (var ii :int = 0; ii < Board.GROUP_NAMES.length; ii++) {
            if (group.indexOf(Board.GROUP_NAMES[ii]) == 0) {
                return _dynamicTree;
            }
        }
        return _pieceTree;
    }

    protected var _board :Board;

    protected var _boardSprite :BoardEditSprite;

    protected var _editSelector :PieceSelector;
    protected var _dynamicSelector :DynamicSelector;

    protected var _pieceTree :PieceTree;
    protected var _dynamicTree :DynamicTree;

    protected var _container :Container;

    protected var _editCoords :Label;

    protected var _pfac :PieceFactory;
}
}
