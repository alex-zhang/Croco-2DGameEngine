package com.croco2d.core
{
	import com.croco2d.CrocoEngine;
	
	import flash.utils.getQualifiedClassName;
	
	import starling.core.RenderSupport;

	public class CrocoObject
	{
		//fileds to identify CrocoObject.
		public var uid:String = null;
		public var name:String = null;
		public var type:String = null;
		
		//__alive true when new.
		public var __alive:Boolean = true;
		public var __inited:Boolean = false;
		public var __actived:Boolean = false;
		
		public var tickable:Boolean = true;
		//default can't be draw.
		public var visible:Boolean = false;

		public var parent:CrocoObject = null;
		public var owner:CrocoObject = null;
		public var manager:CrocoObject = null;
		
		public var __userData:Object = null;

		//default value is 0.
		public var sortPriority:Number = 0;
		
		/**
		 * Setting this to true will prevent the object from appearing
		 * when the visual debug mode in the debugger overlay is toggled on.
		 */
		public var debug:Boolean = false;
		
		//u can modify the logic method in run time. but u'd better do that carefully.
		public var __onInitCallback:Function = onInit;
		public var __onInitedCallback:Function = onInited;
		
		public var __onActiveCallback:Function = onActive;
		public var __onActivedCallback:Function = onActived;
		
		public var __onDeactiveCallback:Function = onDeactive;
		public var __onDeactivedCallback:Function = onDeactived;

		public var __onDrawDebugCallback:Function = onDrawDebug;
		
		public function CrocoObject()
		{
			super();
		}
		
		public final function get userData():Object
		{
			if(!__userData) __userData = {};
			
			return __userData;
		}
		
		public final function init():void
		{
			if(!__inited)
			{
				__onInitCallback();
				__inited = true;
				__onInitedCallback();
			}
		}
		
		protected function onInit():void {}
		protected function onInited():void {}
		
		public final function active():void
		{
			if(!__actived)
			{
				__onActiveCallback();
				__actived = true;
				__onActivedCallback();
			}
		}
		
		protected function onActive():void {}
		protected function onActived():void {}
		
		public function tick(deltaTime:Number):void {}
		
		public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(debug && CrocoEngine.debug)
			{
				__onDrawDebugCallback();
			}
		}
		
		protected function onDrawDebug():void {}
		
		public final function deactive():void
		{
			if(__actived)
			{
				__onDeactiveCallback();
				__actived = false;
				__onDeactivedCallback();
			}
		}
		
		protected function onDeactive():void {};
		protected function onDeactived():void {};
		
		//will dispose in next tick.
		public final function kill():void
		{
			__alive = false;
		}
		
		public final function getParentRoot():CrocoObject
		{
			var p:CrocoObject = this;
			while(p.parent) p = p.parent;
			return p;
		}
		
		public function dispose():void 
		{
			uid = null;
			name = null;
			type = null;
			
			parent = null;
			owner = null;
			
			__userData = null;
			
			sortPriority = NaN;

			__alive = false;
			__inited = false;
			__actived = false;
			
			tickable = false;
			visible = false;
			
			__onInitCallback = null;
			__onInitedCallback = null;
			
			__onActiveCallback = null;
			__onActivedCallback = null;
			
			__onDeactiveCallback = null;
			__onDeactivedCallback = null;

			__onDrawDebugCallback = null;
		}

		public function toString():String
		{
			var results:String = "class: " + getQualifiedClassName(this) + "\n" + 
				"uid: " + uid + "\n" +
				"name: " + name + "\n" +
				"type: " + type + "\n" +
				"__alive: " + __alive + "\n" +
				"__inited: " + __inited + "\n" +
				"__actived: " + __actived + "\n" +
				"tickable: " + tickable + "\n" +
				"visible: " + visible + "\n" +
				"sortPriority: " + sortPriority + "\n" +
				"debug: " + debug + "\n" +
				"parent: " + (parent ? (parent.uid || parent.name || parent.type) : null) + "\n" +
				"owner: " + (owner ? (owner.uid || owner.name || owner.type) : null) + "\n" +
				"manager: " + (manager ? (manager.uid || manager.name || manager.type) : null) + "\n" +
				"userData: " + (__userData ? __userData : null);
			
			return results;
		}
	}
}