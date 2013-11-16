package com.croco2dMGE.extensions.tmx.datas
{
	import com.fireflyLib.crypto.Base64Decoder;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class TMXGridData extends TMXBasicData
	{
		public var mapData:TMXMapData;
		
		public var encoding:String;//Base64 must be
		public var compression:String;//gzip,zlib
		
		protected var gridRowData:Vector.<int>;
		
		public function TMXGridData()
		{
			super();
		}
		
		public function getCellValue(colIndex:int, rowIndex:int):int
		{
			var cellIndex:int = rowIndex * mapData.colNum + colIndex;
			return gridRowData[cellIndex];
		}
		
		override public function deserialize(xml:XML):void
		{
			if(xml.hasOwnProperty("@encoding"))
			{
				encoding = xml.@encoding;
			}

			if(xml.hasOwnProperty("@compression"))
			{
				compression = xml.@compression;
			}
			
			if(encoding != "base64" && (compression != "zlib"))// || compression != "gzib"))
			{
				throw new Error("error encoding must be base64 and compression must be zlib");
			}
			
			var base64Decoder:Base64Decoder = new Base64Decoder();
			var base64Chars:String = xml.valueOf().toString();
			base64Decoder.decode(base64Chars);
			
			var dataBytes:ByteArray = base64Decoder.flush();
			dataBytes.uncompress(compression);
			
			dataBytes.endian = Endian.LITTLE_ENDIAN;
			dataBytes.position = 0;
			
			var cellNum:int = mapData.cellsNum;
			
			gridRowData = new Vector.<int>(cellNum, true);
			
			for(var cellIndex:int = 0; cellIndex < cellNum; cellIndex++)
			{
				gridRowData[cellIndex] = dataBytes.readInt();
			}
			dataBytes.clear();
		}
		
		override public function dispose():void
		{
			encoding = null;
			compression = null;
			mapData = null;
			gridRowData = null;
		}
	}
}