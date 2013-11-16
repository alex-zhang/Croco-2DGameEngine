package com.croco2dMGE.core
{
	import starling.core.RenderSupport;

	public class CrocoBasic
	{
		public var uid:String;
		public var name:String;
		public var type:String;
		
		public var active:Boolean = true;
		public var visible:Boolean = true;
		public var exists:Boolean = true;
		public var alive:Boolean = true;
		
		public var owner:CrocoBasic;

		private var mInited:Boolean = false;
		
		public function CrocoBasic()
		{
			super();
		}
		
		public final function get inited():Boolean { return mInited; };
		public final function init():void 
		{
			if(!mInited)
			{
				onInit();
				mInited = true;
			}
		}
		
		protected function onInit():void {};
		
		public function onActive():void
		{ 
			exists = true;
		}
		
		public function tick(deltaTime:Number):void {};
		public function draw(support:RenderSupport, parentAlpha:Number):void {};
		
		public function onDeactive():void 
		{ 
			exists = false;
		}
		
		public function kill():void
		{
		}
		
		public function dispose():void 
		{
			uid = null;
			name = null;
			type = null;

			mInited = false;
			exists = false;
			visible = false;
			active = false;
		}
	}
}