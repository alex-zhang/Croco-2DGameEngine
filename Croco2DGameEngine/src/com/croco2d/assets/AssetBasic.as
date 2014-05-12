package com.croco2d.assets
{
	import flash.events.Event;
	import flash.events.ProgressEvent;

	public class AssetBasic
	{
		private var mName:String;
		private var mType:String;
		private var mExtention:String;
		private var mUrl:String;
		
		private var mLoaded:Boolean = false;
		private var mAssetLoadProgressCallback:Function;
		private var mAssetLoadCompletedCallback:Function;
		
		internal var mAssetsManager:CrocoAssetsManager;
		
		public function AssetBasic(name:String, type:String, extention:String, url:String)
		{
			super();
			
			mName = name;
			mType = type;
			mExtention = extention;
			mUrl = url;
		}
		
		public function get name():String { return mName; };
		public function get type():String { return mType; };
		public function get extention():String { return mExtention; };
		public function get url():String { return mUrl; };
		
		public function get assetsManager():CrocoAssetsManager { return mAssetsManager; };
		
		public function dispose():void
		{
			mName = null;
			mType = null;
			mExtention = null;
			mUrl = null;
			
			mAssetLoadProgressCallback = null;
			mAssetLoadCompletedCallback = null;
		}
		
		public function load(assetLoadProgressCallback:Function, assetLoadCompletedCallback:Function):void
		{
			mLoaded = false; 
			mAssetLoadProgressCallback = assetLoadProgressCallback;
			mAssetLoadCompletedCallback = assetLoadCompletedCallback;
		}
		
		protected function onLoadProgressHandler(event:ProgressEvent):void
		{
			if(mAssetLoadProgressCallback)
			{
				mAssetLoadProgressCallback(event.bytesLoaded / event.bytesTotal);
			}
		}
		
		protected function onLoadCompletedHandler(event:Event):void 
		{
			onAssetDeserialize();
		}
		
		//asset loaded but need to init.
		protected function onAssetDeserialize():void
		{
			//should call in sub clss.
//			onAssetLoadedCompeted();
		}
		
		protected function onLoadErrorHandler(event:Event):void 
		{
			onAssetLoadedError();
		}
		
		//helper
		protected function onAssetLoadedCompeted():void
		{
			mLoaded = true;
			
			mAssetLoadProgressCallback = null;
			
			if(mAssetLoadCompletedCallback)
			{
				mAssetLoadCompletedCallback(true);
				mAssetLoadCompletedCallback = null;
			}
		}
		
		protected function onAssetLoadedError():void
		{
			mLoaded = false;
			
			mAssetLoadProgressCallback = null;
			
			if(mAssetLoadCompletedCallback)
			{
				mAssetLoadCompletedCallback(false);
				mAssetLoadCompletedCallback = null;
			}
		}
	}
}