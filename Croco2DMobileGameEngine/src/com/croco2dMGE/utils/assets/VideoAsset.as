package com.croco2dMGE.utils.assets
{
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class VideoAsset extends AssetBasic
	{
		public var netStream:NetStream;
		
		private var mNetConnection:NetConnection;
		
		public function VideoAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override public function load(loadProgressCallback:Function, loadCompletedCallback:Function):void
		{
			super.load(loadCompletedCallback);
		
			mNetConnection = new NetConnection();
			mNetConnection.connect(null);
			
			netStream = new NetStream(mNetConnection);
			netStream.addEventListener(IOErrorEvent.IO_ERROR, onLoadErrorHandler);
			netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStreamStatusHandler);
			
			try
			{
				// TODO: test for security error thown.
				netStream.play(url);
			}
			catch( e:SecurityError)
			{
				var secErrorEvt:SecurityErrorEvent = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR, false, false, e.message);
				onLoadErrorHandler(secErrorEvt);
			}
			
			netStream.seek(0);
		}
		
		protected function onNetStreamStatusHandler(event:NetStatusEvent):void
		{
		}
	}
}