package com.whirled.contrib.simplegame.resource {

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.core.ByteArrayAsset;

public class XmlResourceLoader extends EventDispatcher
    implements ResourceLoader
{
    public function XmlResourceLoader (resourceName :String, loadParams :Object)
    {
        _resourceName = resourceName;
        _loadParams = loadParams;
    }

    public function get resourceName () :String
    {
        return _resourceName;
    }

    public function get xml () :XML
    {
        return _xml;
    }

    public function load () :void
    {
        if (_loadParams.hasOwnProperty("url")) {
            this.loadFromURL(_loadParams["url"]);
        } else if (_loadParams.hasOwnProperty("embeddedClass")) {
            this.loadFromEmbeddedClass(_loadParams["embeddedClass"]);
        } else {
            throw new Error("XmlResourceLoader: either 'url' or 'embeddedClass' must be specified in loadParams");
        }
    }

    protected function loadFromURL (urlString :String) :void
    {
        _urlLoader = new URLLoader();
        _urlLoader.addEventListener(Event.COMPLETE, onComplete);
        _urlLoader.addEventListener(IOErrorEvent.IO_ERROR,
            function (e :IOErrorEvent) :void {
                onError(e.text);
            });
        _urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
            function (e :SecurityErrorEvent) :void {
                onError(e.text);
            });

        _urlLoader.load(new URLRequest(_loadParams["url"]));
    }

    protected function loadFromEmbeddedClass (theClass :Class) :void
    {
        var ba :ByteArrayAsset = ByteArrayAsset(new theClass());
        this.instantiateXml(ba.readUTFBytes(ba.length));
    }

    public function unload () :void
    {
        if (null != _urlLoader) {
            try {
                _urlLoader.close();
            } catch (e :Error) {
                // swallow the exception
            }
        }
    }

    protected function onComplete (...ignored) :void
    {
        this.instantiateXml(_urlLoader.data);
    }

    protected function instantiateXml (data :*) :void
    {
        // the XML may be malformed, so catch errors thrown when it's instantiated
        try {
            _xml = new XML(data);
        } catch (e :Error) {
            this.onError(e.message);
            return;
        }

        this.dispatchEvent(new ResourceLoadEvent(ResourceLoadEvent.LOADED));
    }

    protected function onError (errText :String) :void
    {
        this.dispatchEvent(new ResourceLoadEvent(ResourceLoadEvent.ERROR, "XmlResourceLoader (" + _resourceName + "): " + errText));
    }

    protected var _resourceName :String;
    protected var _loadParams :Object;
    protected var _urlLoader :URLLoader;
    protected var _xml :XML;
}

}
