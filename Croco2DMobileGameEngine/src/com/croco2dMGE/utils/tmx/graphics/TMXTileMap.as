package com.croco2dMGE.utils.tmx.graphics
{
	import com.croco2dMGE.graphics.map.TileMap;
	import com.croco2dMGE.utils.tmx.data.TMXTileGridData;
	import com.croco2dMGE.utils.tmx.world.TMXMapScene;

	public class TMXTileMap extends TileMap
	{
		public var tmxMapScene:TMXMapScene;
		public var tmxGridData:TMXTileGridData;
		
		public function TMXTileMap(cellWidth:int, cellHeight:int,
								   maxColCount:int, maxRowCount:int,
								   minColStartIndex:int = 0, minRowStartIndex:int = 0)
		{
			super(cellWidth, cellHeight, maxColCount, maxRowCount, minColStartIndex, minRowStartIndex);
			
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
			tmxMapScene = null;
		}
	}
}

import com.croco2dMGE.graphics.map.TileMapCell;
import com.croco2dMGE.utils.assets.CrocoAssetsManager;
import com.croco2dMGE.utils.tmx.data.TMXTileGridData;
import com.croco2dMGE.utils.tmx.data.TMXTileSheet;
import com.croco2dMGE.utils.tmx.graphics.TMXTileMap;
import com.croco2dMGE.utils.tmx.world.TMXMapScene;

class TMXTileMapCell extends TileMapCell
{
	public function TMXTileMapCell(cellWidth:int, cellHeight:int)
	{
		super(cellWidth, cellHeight);
	}
	
	override public function onActive():void
	{
		super.onActive();
		
		var tmxTileMap:TMXTileMap = owner as TMXTileMap;
		var tmxMapScene:TMXMapScene = tmxTileMap.tmxMapScene;
		var assetsManager:CrocoAssetsManager = tmxMapScene.screen.screenPreLoadAssetsManager;
		var tileGridData:TMXTileGridData = tmxTileMap.tmxGridData;
		
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

