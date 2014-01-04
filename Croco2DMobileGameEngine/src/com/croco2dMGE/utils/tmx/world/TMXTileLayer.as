package com.croco2dMGE.utils.tmx.world
{
	import com.croco2dMGE.CrocoEngine;
	import com.croco2dMGE.core.CrocoBasic;
	import com.croco2dMGE.utils.tmx.data.TMXTileGridData;
	import com.croco2dMGE.utils.tmx.graphics.TMXTileMap;
	
	import starling.core.RenderSupport;

	public class TMXTileLayer extends TMXBasicLayer
	{
		public var tmxGridData:TMXTileGridData;
		
		protected var mTMXTileMap:TMXTileMap;
		
		public function TMXTileLayer()
		{
			super();
		}
		
		override public function deserialize(xml:XML):void
		{
			super.deserialize(xml);
			
			//gridData
			tmxGridData = new TMXTileGridData();
			tmxGridData.mapData = tmxMapData;
			tmxGridData.deserialize(xml.data[0]);
		}
		
		override public function addItem(item:CrocoBasic):CrocoBasic
		{
			throw new Error("TMXImageLayer:: U can not add any things to this layer.");
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			mTMXTileMap = new TMXTileMap(tmxMapData.tileWidth, tmxMapData.tileHeight, 
				tmxMapData.numCol, tmxMapData.numCol, 0, 0);
			mTMXTileMap.tmxMapScene = owner as TMXMapScene;
			mTMXTileMap.tmxGridData = tmxGridData;
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			mTMXTileMap.setViewPort(CrocoEngine.camera.scrollX * scrollFactorX, 
				CrocoEngine.camera.scrollY * scrollFactorY, 
				CrocoEngine.camera.width, CrocoEngine.camera.height);

			mTMXTileMap.tick(deltaTime);
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			mTMXTileMap.x = int(-CrocoEngine.camera.scrollX * scrollFactorX);
			mTMXTileMap.y = int(-CrocoEngine.camera.scrollY * scrollFactorY);
			
			//render
			support.pushMatrix();
			support.transformMatrix(mTMXTileMap);
			mTMXTileMap.render(support, parentAlpha * layerAlpha);
			support.popMatrix();
		}

		override public function dispose():void
		{
			super.dispose();
			
			if(tmxGridData)
			{
				tmxGridData.dispose();
				tmxGridData = null;
			}
		}
	}
}