package com.croco2d.tmx.display
{
	import com.croco2d.display.map.TileMap;
	import com.croco2d.tmx.data.TMXMapData;
	import com.croco2d.tmx.data.TMXTileGridData;
	import com.croco2d.tmx.scene.TMXMapScene;

	public class TMXTileMap extends TileMap
	{
		public var tmxGridData:TMXTileGridData;
		
		public function TMXTileMap(tmxGridData:TMXTileGridData)
		{
			this.tmxGridData = tmxGridData;
			
			var tmxMapData:TMXMapData = tmxGridData.mapData;
			
			super(tmxMapData.tileWidth, tmxMapData.tileHeight, 
				tmxMapData.numCol, tmxMapData.numRow);
			
			mapCellCls = TMXTileMapCell;
		}
		
		override protected function onActiveValidCell(colIndex:int, rowIndex:int):void
		{
			if(tmxGridData.getTileGIDValue(colIndex, rowIndex) != 0)
			{
				super.onActiveValidCell(colIndex, rowIndex);
			}
		}
		
		override protected function onDeactiveInvalidCell(colIndex:int, rowIndex:int):void
		{
			if(tmxGridData.getTileGIDValue(colIndex, rowIndex) != 0)
			{
				super.onDeactiveInvalidCell(colIndex, rowIndex);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			tmxGridData = null;
		}
	}
}

import com.croco2d.assets.CrocoAssetsManager;
import com.croco2d.display.map.TileMapCell;
import com.croco2d.tmx.data.TMXMapData;
import com.croco2d.tmx.data.TMXTileGridData;
import com.croco2d.tmx.data.TMXTileSheet;
import com.croco2d.tmx.display.TMXTileMap;
import com.croco2d.tmx.scene.TMXMapScene;

class TMXTileMapCell extends TileMapCell
{
	public function TMXTileMapCell(cellWidth:int, cellHeight:int)
	{
		super(cellWidth, cellHeight);
	}
	
	override protected function onActive():void
	{
		super.onActive();
		
		var tmxTileMap:TMXTileMap = owner as TMXTileMap;
		var tileGridData:TMXTileGridData = tmxTileMap.tmxGridData;
		var tmxMapData:TMXMapData = tileGridData.mapData;
		var tmxMapScene:TMXMapScene = tmxMapData.tmxMapScene;
		
		var assetsManager:CrocoAssetsManager// = tmxMapScene.assetsManager;
		
		var tileMapCellGID:int = tileGridData.getTileGIDValue(colIndex, rowIndex);
		var tileSheet:TMXTileSheet = tileGridData.mapData.getTileSheetByGID(tileMapCellGID);
		
		var tileMapTextureCellColNum:int = tileSheet.numCol
		var tileMapTextureCellRowNum:int = tileSheet.numRow;
		
		var tileMapTextureCellIndex:int = tileMapCellGID - tileSheet.firstgid;
		
		var tileMapTextureCellColIndex:int = int(tileMapTextureCellIndex % tileMapTextureCellColNum);
		var tileMapTextureCellRowIndex:int = int(tileMapTextureCellIndex / tileMapTextureCellColNum);
		
		var tileMapTextureCellUValue:Number = tileSheet.tileUvalue;
		var tileMapTextureCellVValue:Number = tileSheet.tileVvalue;
		
		var tileMapTextureCellU0:Number = tileMapTextureCellUValue * tileMapTextureCellColIndex;
		var tileMapTextureCellU1:Number = tileMapTextureCellU0 + tileMapTextureCellUValue;
		
		var tileMapTextureCellV0:Number = tileMapTextureCellVValue * tileMapTextureCellRowIndex;
		var tileMapTextureCellV1:Number = tileMapTextureCellV0 + tileMapTextureCellVValue;
		
		this.texture = tileSheet.imageTexture;
		
		this.setTexCoordsTo(0, tileMapTextureCellU0, tileMapTextureCellV0);
		this.setTexCoordsTo(1, tileMapTextureCellU1, tileMapTextureCellV0);
		this.setTexCoordsTo(2, tileMapTextureCellU0, tileMapTextureCellV1);
		this.setTexCoordsTo(3, tileMapTextureCellU1, tileMapTextureCellV1);	
	}
}

