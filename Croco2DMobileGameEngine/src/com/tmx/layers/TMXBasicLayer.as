package com.tmx.layers
{
	import com.croco2dMGE.world.SceneLayer;
	import com.fireflyLib.utils.MathUtil;
	import com.tmx.datas.TMXMapData;
	import com.tmx.datas.TMXPropertiesData;

	public class TMXBasicLayer extends SceneLayer
	{
		public var mapData:TMXMapData;
		public var propertiesData:TMXPropertiesData;
		
		public function TMXBasicLayer()
		{
			super();
		}
		
		public function deserialize(xml:XML):void
		{
			//base atr
			name = xml.@name;
			
			propertiesData = new TMXPropertiesData();
			propertiesData.deserialize(xml.properties[0]);
			
			//set from propertiesData
			if(propertiesData.has("scrollFactorX"))
			{
				this.scrollFactorX = parseFloat(propertiesData.get("scrollFactorX"));
			}
			
			if(propertiesData.has("scrollFactorY"))
			{
				this.scrollFactorY = parseFloat(propertiesData.get("scrollFactorY"));
			}
			
			if(propertiesData.has("needDepthsort"))
			{
				this.needDepthsort = parseInt(propertiesData.get("needDepthsort")) != 0;
			}
			
			if(propertiesData.has("needRealTimeDepthSort"))
			{
				this.needRealTimeDepthSort = parseInt(propertiesData.get("needRealTimeDepthSort")) != 0;
			}
			
			if(xml.hasOwnProperty("@opacity"))
			{
				this.layerAlpha = MathUtil.clamp(parseFloat(xml.@opacity), 0, 1.0);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			mapData = null;
			
			if(propertiesData)
			{
				propertiesData.dispose();
				propertiesData = null;
			}
		}
	}
}