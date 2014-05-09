package com.croco2d.utils.tmx.data
{
	import com.fireflyLib.crypto.Base64Decoder;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class TMXTileGridData extends TMXDataBasic
	{
		public var gridEncoding:String;
		public var gridCompression:String;
		public var gridRowData:Vector.<int>;
		
		override public function deserialize(xml:XML):void 
		{
			super.deserialize(xml);
			
			gridEncoding = xml.@encoding;
			gridCompression = xml.@compression;
			
			if(gridEncoding != "base64" && gridCompression != "zlib")
			{
				throw new Error("error encoding must be base64 and compression must be zlib");
			}
			
			var base64Decoder:Base64Decoder = new Base64Decoder();
			var base64Chars:String = xml.valueOf().toString();
			base64Decoder.decode(base64Chars);
			var base64Bytes:ByteArray = base64Decoder.flush();
			base64Bytes.uncompress(gridCompression);
			base64Bytes.endian = Endian.LITTLE_ENDIAN;
			base64Bytes.position = 0;
			
			var tilesCount:int = mapData.numTiles
			gridRowData = new Vector.<int>(tilesCount, true);
			var tileGID:int = 0;
			
			for(var cellIndex:int = 0; cellIndex < tilesCount; cellIndex++)
			{
				//the tile gid value.
				tileGID = base64Bytes.readInt();
				gridRowData[cellIndex] = tileGID;
			}
			base64Bytes.clear();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			gridRowData = null;
		}

		public function getTileGIDValue(colIndex:int, rowIndex:int):int
		{
			var cellIndex:int = rowIndex * mapData.numRow + colIndex;
			if(cellIndex < 0 || cellIndex >= gridRowData.length) return 0;
			
			return gridRowData[cellIndex];
		}
	}
}