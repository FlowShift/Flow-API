//
// $Id$

package com.whirled.contrib.platformer.editor {

import flash.events.Event;

import mx.core.Container;
import mx.containers.HBox;
import mx.containers.Panel;
import mx.containers.TabNavigator;
import mx.containers.VBox;
import mx.controls.TextArea;
import mx.events.IndexChangedEvent;

import flash.net.URLLoader;
import flash.net.URLRequest;

import com.whirled.contrib.platformer.editor.EditView;

/**
 * A level editor for platformer games.  The use of this level editor requires the inclusion of
 * libraries from FlexBuilder 3 Pro for Flex Data Visualization.
 */
public class LevelEditor extends Panel
{
    public function LevelEditor ()
    {
        title = "Platformer Level Editor";
        percentHeight = 100;
        percentWidth = 100;
        setStyle("PaddingTop", 0);
        setStyle("PaddingBottom", 0);
        setStyle("PaddingLeft", 0);
        setStyle("PaddingRight", 0);
    }

    /**
     * Must be called to set up loading the XML for this level editor.
     */
    public function setXmlPaths (piecesXmlPath :String, dynamicsXmlPath :String, 
        levelXmlPath :String) :void
    {
        piecesXmlPath = piecesXmlPath.replace(/:/, "|");
        piecesXmlPath = piecesXmlPath.replace(/\\/g, "/");
        _piecesLoader = new URLLoader();
        _piecesLoader.addEventListener(Event.COMPLETE,
            function (event :Event) :void {
                _piecesLoaded = true;
                addEditView();
            });
        _piecesLoader.load(new URLRequest("file://" + piecesXmlPath));
    
        dynamicsXmlPath = dynamicsXmlPath.replace(/:/, "|");
        dynamicsXmlPath = dynamicsXmlPath.replace(/\\/g, "/");
        _dynamicsLoader = new URLLoader();
        _dynamicsLoader.addEventListener(Event.COMPLETE,
            function (event :Event) :void {
                _dynamicsLoaded = true;
                addEditView();
            });
        _dynamicsLoader.load(new URLRequest("file://" + dynamicsXmlPath));
    
        levelXmlPath = levelXmlPath.replace(/:/, "|");
        levelXmlPath = levelXmlPath.replace(/\\/g, "/");
        if (levelXmlPath == null || levelXmlPath == "") {
            _levelLoaded = true;
            addEditView();
        } else {
            _levelLoader = new URLLoader();
            _levelLoader.addEventListener(Event.COMPLETE,
                function (event :Event) :void {
                    _levelLoaded = true;
                    addEditView();
                });
            _levelLoader.load(new URLRequest("file://" + levelXmlPath));
        }
    }

    /**
     * Called externally when PieceSpriteFactory is initialized
     */
    public function pieceFactoryInitialized () :void
    {
        _factoryInitialized = true;
        addEditView();
    }

    override protected function createChildren () :void
    {
        super.createChildren();

        var tabs :TabNavigator = new TabNavigator();
        tabs.percentWidth = 100;
        tabs.percentHeight = 100;
        tabs.addEventListener(IndexChangedEvent.CHANGE, function (...ignored) :void {
            tabChanged(tabs.selectedChild);
        });
        var editBox :HBox = new HBox();
        editBox.percentWidth = 100;
        editBox.label = "Edit Level";
        editBox.addChild(_levelEdit = new FocusContainer());
        _levelEdit.width = 900;
        _levelEdit.height = 700;
        tabs.addChild(editBox);
        _xmlCode = new VBox();
        _xmlCode.label = "XML Code";
        _xmlCode.percentWidth = 100;
        _xmlCode.percentHeight = 100;
        tabs.addChild(_xmlCode);
        addChild(tabs);
    }

    protected function addEditView () :void
    {
        if (!_levelLoaded || !_piecesLoaded || !_dynamicsLoaded || !_factoryInitialized) {
            return;
        }
        _codeArea = new TextArea();
        _codeArea.percentWidth = 100;
        _codeArea.percentHeight = 100;
        _codeArea.editable = false;
        _codeArea.setStyle("fontFamily", "Sans");
        _codeArea.setStyle("fontSize", "12");
        _xmlCode.addChild(_codeArea);
    
        var xmlPieces :XML = new XML(_piecesLoader.data);
        var xmlLevel :XML = (_levelLoader == null ? null : new XML(_levelLoader.data));
        var xmlDynamics :XML = new XML(_dynamicsLoader.data);
    
        _levelEdit.rawChildren.addChild(_editView = new EditView(
            _levelEdit, xmlPieces, xmlDynamics, xmlLevel));
    }
    
    protected function tabChanged (selected :Container) :void
    {
        if (selected == _xmlCode) {
            _codeArea.text = _editView.getXML();
        }
    }
    
    protected var _codeArea :TextArea;
    protected var _editView :EditView;
    protected var _piecesLoader :URLLoader;
    protected var _levelLoader :URLLoader;
    protected var _dynamicsLoader :URLLoader;
    protected var _piecesLoaded :Boolean;
    protected var _levelLoaded :Boolean;
    protected var _dynamicsLoaded :Boolean;
    protected var _levelEdit :FocusContainer;
    protected var _xmlCode :VBox;
    protected var _factoryInitialized :Boolean = false;
}
}
