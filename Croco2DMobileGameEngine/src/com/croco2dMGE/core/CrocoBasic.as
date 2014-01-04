package com.croco2dMGE.core
{
	import com.fireflyLib.utils.PropertyBag;
	
	import flash.utils.getQualifiedClassName;
	
	import starling.core.RenderSupport;

	public class CrocoBasic
	{
		public var uid:String;
		public var name:String;
		public var type:String;
		
		public var __alive:Boolean = true;
		public var __inited:Boolean = false;
		
		public var actived:Boolean = true;
		public var tickable:Boolean = true;
		public var visible:Boolean = true;
		
		public var owner:CrocoBasic;
		
		public var propertyBag:PropertyBag;
		
		public function CrocoBasic()
		{
			super();
		}
		
		public final function init():void 
		{
			if(!__inited)
			{
				onInit();
				
				__inited = true;
			}
		}
		
		protected function onInit():void 
		{
			propertyBag ||= new PropertyBag();
		}
		
		public function onActive():void
		{ 
			actived = true;
		}
		
		public function tick(deltaTime:Number):void {};
		public function draw(support:RenderSupport, parentAlpha:Number):void {};
		
		public function onDeactive():void 
		{ 
			actived = false;
		}
		
		public function __kill():void
		{
			__alive = false;
		}
		
		public function dispose():void 
		{
			uid = null;
			name = null;
			type = null;

			__alive = false;
			__inited = false;
			
			actived = false;
			tickable = false;
			visible = false;
			
			if(propertyBag)
			{
				propertyBag.clear();
				propertyBag = null;
			}
		}
		
		public function toString():String
		{
			return getQualifiedClassName(this) + " " + 
						"uid: " + uid + " " +
						"name: " + name + " " +
						"type: " + type + " " +
						"__alive: " + __alive + " " +
						"__inited: " + __inited + " " +
						"actived: " + actived + " " +
						"tickable: " + tickable + " " +
						"visible: " + visible + " " + 
						"owner: " + owner + " " +
						"propertyBag: " + propertyBag;
		}
	}
}