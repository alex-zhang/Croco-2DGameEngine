package com.croco2d.utils.tmx.data
{
	import com.croco2d.utils.tmx.scene.TMXMapScene;
	import com.llamaDebugger.Logger;

	public class TMXMapData extends TMXDataBasic
	{
		public var version:String;
		public var orientation:String;
		
		public var numCol:int;//tile col num
		public var numRow:int;//tile row num
		//help prop for colTileCount * rowTileCount
		public var numTiles:int = 0;
		
		public var tileWidth:int; //tile cell width in pixle
		public var tileHeight:int;//tile cell height in pixle
		//help prop for scene size in pixel.		
		public var mapWidth:Number = 0;
		public var mapHeight:Number = 0;
		
		protected var mTileSheetNameMap:Array;//name -> TMXTileSet
		protected var mTileSheetList:Vector.<TMXTileSheet>;
		protected var mTileSheetGIDMap:Array;//gid -> TMXTileSet
		
		public var tmxMapScene:TMXMapScene;
		
		override public function deserialize(xml:XML):void 
		{
			super.deserialize(xml);
			
			version = xml.@version;
			orientation = xml.@orientation;//must be orthogonal
			
			if(orientation != "orthogonal")
			{
				Logger.error("deserialize orientation must be orthogonal!", "deserialize", "TMXMapData");
			}
			
			numCol = parseInt(xml.@width);
			numRow = parseInt(xml.@height);
			numTiles = numCol * numRow;
			
			tileWidth = parseInt(xml.@tilewidth);
			tileHeight = parseInt(xml.@tileheight);
			
			mapWidth = tileWidth * numCol;
			mapHeight = tileHeight * numRow;
			
			//tile sets
			deserializeTileSheets(xml.tileset);
		}
		
		protected function deserializeTileSheets(tileSetXMLs:XMLList):void
		{
			var tileSetXML:XML;
			var tileSheet:TMXTileSheet;
			var n:int = tileSetXMLs.length();
			
			mTileSheetList = new Vector.<TMXTileSheet>(n, true);
			mTileSheetNameMap = [];
			mTileSheetGIDMap = [];
			
			for(var i:int = 0; i < n; i++)
			{
				tileSetXML = tileSetXMLs[i];
				
				tileSheet = new TMXTileSheet();
				tileSheet.mapData = this;
				tileSheet.deserialize(tileSetXML);
				
				mTileSheetList[i] = tileSheet;
				mTileSheetNameMap[tileSheet.name] = tileSheet;
			}
		}
		
		public function getTileSheetCount():uint
		{
			return mTileSheetList.length;
		}
		
		public function getTileSheetAt(index:int):TMXTileSheet
		{
			return mTileSheetList[index];
		}
		
		public function getTileSheetByName(name:String):TMXTileSheet
		{
			return mTileSheetNameMap[name];
		}
		
		public function getTileSheetByGID(gid:int):TMXTileSheet
		{
			if(mTileSheetGIDMap[gid] !== undefined)
			{
				return mTileSheetGIDMap[gid];
			}
			else
			{
				var n:int = mTileSheetList.length;
				var tileSheet:TMXTileSheet;
				for(var i:int = 0; i < n; i++)
				{
					tileSheet = mTileSheetList[i];
					
					if(gid >= tileSheet.firstgid && gid < tileSheet.numTiles)
					{
						mTileSheetGIDMap[gid] = tileSheet;
						
						return tileSheet;
					}
				}
				
				return null;
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			version = null;
			orientation = null;
			
			mTileSheetNameMap = null;
			if(mTileSheetList)
			{
				var n:int = mTileSheetList.length;
				for(var i:int = 0; i < n; i++)
				{
					mTileSheetList[i].dispose();
					mTileSheetList[i] = null;
				}
				mTileSheetList = null;
			}
			
			tmxMapScene = null;
		}
	}
}