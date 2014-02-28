package com.croco2d.assets
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;

	public class BinaryAsset extends AssetBasic
	{
		protected var mBytesLoader:URLStream;
		
		public var byteArray:ByteArray;
		
		public function BinaryAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override public function dispose():void
		{	
			if(byteArray)
			{
				byteArray.clear();
				byteArray = null;
			}
		}
		
		override public function load(loadProgressCallback:Function, loadCompletedCallback:Function):void
		{
			super.load(loadProgressCallback, loadCompletedCallback);
			
			mBytesLoader = new URLStream();
			mBytesLoader.addEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler);
			mBytesLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadErrorHandler);
			mBytesLoader.addEventListener(ProgressEvent.PROGRESS, onLoadProgressHandler);
			mBytesLoader.addEventListener(Event.COMPLETE, onLoadCompletedHandler);
			
			mBytesLoader.load(new URLRequest(url));
		}
		
		override protected function onLoadCompletedHandler(event:Event):void 
		{
			super.onLoadCompletedHandler(event);
			
			mBytesLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler);
			mBytesLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadErrorHandler);
			mBytesLoader.removeEventListener(ProgressEvent.PROGRESS, onLoadProgressHandler);
			mBytesLoader.removeEventListener(Event.COMPLETE, onLoadCompletedHandler);
			mBytesLoader = null;
		}
		
		override protected function onAssetDeserialize():void
		{
			byteArray = new ByteArray();
			mBytesLoader.readBytes(byteArray);
			
			onBinaryBasedAssetDeserialize();
			
			onAssetDeserializeComplete();
		}
		
		protected function onBinaryBasedAssetDeserialize():void
		{
		}
		
		override protected function onLoadErrorHandler(event:Event):void 
		{
			super.onLoadErrorHandler(event);
			
			mBytesLoader.removeEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler);
			mBytesLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadErrorHandler);
			mBytesLoader.removeEventListener(ProgressEvent.PROGRESS, onLoadProgressHandler);
			mBytesLoader.removeEventListener(Event.COMPLETE, onLoadCompletedHandler);
			mBytesLoader = null;
		}
	}
}