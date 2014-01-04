package com.croco2dMGE.utils.tmx.world
{
	import com.croco2dMGE.utils.tmx.data.TMXMapData;
	import com.croco2dMGE.utils.tmx.data.TMXPropertySet;
	import com.croco2dMGE.world.SceneLayer;
	import com.fireflyLib.utils.MathUtil;

	public class TMXBasicLayer extends SceneLayer
	{
		//helper
		public var tmxMapData:TMXMapData;
		
		public function TMXBasicLayer()
		{
			super();
		}
		
		public function deserialize(xml:XML):void
		{
			//base atr
			name = xml.@name;
			
			propertyBag  = new TMXPropertySet();
			TMXPropertySet(propertyBag).deserialize(xml.properties[0]);
			
			//ignore the visible from tmx
			if(xml.hasOwnProperty("@visible"))
			{
				visible = parseInt(xml.@visible) == 1;
			}
			
			//--
			
			if(xml.hasOwnProperty("@opacity"))
			{
				layerAlpha = MathUtil.clamp(parseFloat(xml.@opacity), 0, 1);
			}
			
			//set from tmxLayerPropertySet
			if(propertyBag.has("scrollFactorX"))
			{
				this.scrollFactorX = parseFloat(propertyBag.read("scrollFactorX"));
			}
			
			if(propertyBag.has("scrollFactorY"))
			{
				this.scrollFactorY = parseFloat(propertyBag.read("scrollFactorY"));
			}
			
			if(propertyBag.has("needDepthsort"))
			{
				this.needDepthsort = parseInt(propertyBag.read("needDepthsort")) == 1;
			}
			
			if(propertyBag.has("needRealTimeDepthSort"))
			{
				this.needRealTimeDepthSort = parseInt(propertyBag.read("needRealTimeDepthSort")) == 1;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			tmxMapData = null;
		}
	}
}