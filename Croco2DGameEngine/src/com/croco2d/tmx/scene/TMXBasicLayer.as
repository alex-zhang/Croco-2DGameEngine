package com.croco2d.tmx.scene
{
	

	public class TMXBasicLayer// extends SceneLayer
	{
		//helper
//		public var tmxMapData:TMXMapData;
//
//		public function TMXBasicLayer()
//		{
//			super();
//		}
//		
//		override public function get propertyBag():PropertyBag
//		{
//			if(!__propertyBag) __propertyBag = new TMXPropertySet();
//			
//			return __propertyBag;
//		}
//		
//		public function deserialize(xml:XML):void
//		{
//			//base atr
//			name = xml.@name;
//			
//			TMXPropertySet(propertyBag).deserialize(xml.properties[0]);
//			
//			if(xml.hasOwnProperty("@visible"))
//			{
//				this.visible = parseInt(xml.@visible) == 1;
//			}
//			
//			if(xml.hasOwnProperty("@opacity"))
//			{
//				this.alpha = MathUtil.clamp(parseFloat(xml.@opacity), 0, 1);
//			}
//			
//			if(propertyBag.has("needRealTimeDepthSort"))
//			{
//				this.needRealTimeDepthSort = parseInt(propertyBag.read("needRealTimeDepthSort")) == 1;
//			}
//		}
//		
//		override public function dispose():void
//		{
//			super.dispose();
//			
//			tmxMapData = null;
//		}
	}
}