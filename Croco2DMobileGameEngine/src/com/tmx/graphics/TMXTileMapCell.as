package com.tmx.graphics
{
	import com.croco2dMGE.graphics.map.TileMapCell;
	import com.fireflyLib.core.SystemGlobal;
	import com.tmx.datas.TMXGridData;
	import com.tmx.datas.TMXTilesetData;
	
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class TMXTileMapCell extends TileMapCell
	{
		public function TMXTileMapCell(cellWidth:int, cellHeight:int)
		{
			super(cellWidth, cellHeight);
		}
		
		override public function onActive():void
		{
			super.onActive();
			
			var gridData:TMXGridData = TMXTileMap(owner).gridData;
			var colNum:int = gridData.mapData.colNum;
			
			var tileMapCellGid:int = gridData.getCellValue(colIndex, rowIndex);
			var tilesetData:TMXTilesetData = gridData.mapData.tilesetListData.getTilesetByGID(tileMapCellGid);
			var tileTexture:Texture = AssetManager(SystemGlobal.get("AssetManager")).getTexture(tilesetData.imageData.path); 
			
			var tileMapTextureCellColNum:int = tilesetData.colCount;
			var tileMapTextureCellRowNum:int = tilesetData.rowCount;
			
			var tileMapTextureCellIndex:int = tileMapCellGid - tilesetData.firstgid;
			
			var tileMapTextureCellColIndex:int = int(tileMapTextureCellIndex % tileMapTextureCellColNum);
			var tileMapTextureCellRowIndex:int = int(tileMapTextureCellIndex / tileMapTextureCellColNum);
			
			var tileMapTextureCellUValue:Number = tilesetData.tileUvalue;
			var tileMapTextureCellVValue:Number = tilesetData.tileVvalue;
			
			var tileMapTextureCellU0:Number = tileMapTextureCellUValue * tileMapTextureCellColIndex;
			var tileMapTextureCellU1:Number = tileMapTextureCellU0 + tileMapTextureCellUValue;
			
			var tileMapTextureCellV0:Number = tileMapTextureCellVValue * tileMapTextureCellRowIndex;
			var tileMapTextureCellV1:Number = tileMapTextureCellV0 + tileMapTextureCellVValue;
			
			this.setTexCoordsTo(0, tileMapTextureCellU0, tileMapTextureCellV0);
			this.setTexCoordsTo(1, tileMapTextureCellU1, tileMapTextureCellV0);
			this.setTexCoordsTo(2, tileMapTextureCellU0, tileMapTextureCellV1);
			this.setTexCoordsTo(3, tileMapTextureCellU1, tileMapTextureCellV1);
			this.texture = tileTexture;
		}
	}
}