package com.croco2dMGE.extensions.tmx.datas
{
	public class TMXTilesetListData extends TMXBasicData
	{
		protected var mTilesetDataPathMap:Array;
		protected var mTilesetDataNameMap:Array;
		protected var mTilesetDataList:Vector.<TMXTilesetData>;
		
		override public function deserialize(xml:XML):void
		{
			mTilesetDataPathMap = [];
			mTilesetDataNameMap = [];
			
			var tilesetXMLs:XMLList = xml.tileset;
			var tilesetXML:XML;
			var tilesetData:TMXTilesetData;
			var n:int = tilesetXMLs.length();
			mTilesetDataList = new Vector.<TMXTilesetData>(n, true);
			
			for(var i:int = 0; i < n; i++)
			{
				tilesetXML = tilesetXMLs[i];
				
				tilesetData = new TMXTilesetData();
				tilesetData.deserialize(tilesetXML);
				
				mTilesetDataNameMap[tilesetData.name] = tilesetData;
				mTilesetDataPathMap[tilesetData.imageData.path] = tilesetData;
				
				mTilesetDataList[i] = tilesetData;
			}
		}
		
		public function getTilesetAt(index:int):TMXTilesetData
		{
			return mTilesetDataList[index];
		}
		
		public function getTilesetByPath(path:String):TMXTilesetData
		{
			return mTilesetDataPathMap[path];
		}
		
		public function getTilesetByName(name:String):TMXTilesetData
		{
			return mTilesetDataNameMap[name];
		}
		
		private var mTilesetGIDCache:Array = [];
		public function getTilesetByGID(gid:int):TMXTilesetData
		{
			if(mTilesetGIDCache[gid] !== undefined)
			{
				return mTilesetGIDCache[gid];
			}
			else
			{
				var n:int = mTilesetDataList ? mTilesetDataList.length: 0;
				if(n > 0)
				{
					var tilesetData:TMXTilesetData;
					for(var i:int = 0; i < n; i++)
					{
						tilesetData = mTilesetDataList[i];
						
						if(gid >= tilesetData.firstgid && gid <= tilesetData.lastgid)
						{
							mTilesetGIDCache[gid] = tilesetData;
							return tilesetData;
						}
					}
				}
				
				mTilesetGIDCache[gid] = null;
				return null;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			mTilesetGIDCache = null;
			
			mTilesetDataPathMap = null;
			mTilesetDataNameMap = null;
			
			var tilesetData:TMXTilesetData;
			var n:int = mTilesetDataList ? mTilesetDataList.length : 0;
			for(var i:int = 0; i < n; i++)
			{
				tilesetData = mTilesetDataList[i];
				tilesetData.dispose();
			}
			mTilesetDataPathMap = null;
		}
	}
}