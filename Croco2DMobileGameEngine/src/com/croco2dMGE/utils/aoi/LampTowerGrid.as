package com.croco2dMGE.utils.aoi
{
	import com.croco2dMGE.utils.ViewportGridUtil;
	import com.croco2dMGE.world.SceneObject;
	
	import flash.utils.Dictionary;

	public class LampTowerGrid extends ViewportGridUtil
	{
		//uncompact and uncontinuous cell index mapping. it's use the colIndex:rowIndex as the index key.
		protected var mLampTowerCellsMap:Array;//cellIndex:rowIndex->Cell
		protected var mSceneObjectCellMap:Dictionary;//SceneObject -> Cell
		
		public var lampTowerCellCls:Class;//must an instance of MapCellBasic
		
		public function LampTowerGrid(cellWidth:int, cellHeight:int,
										   maxColCount:int, maxRowCount:int,
										   minColStartIndex:int = 0, minRowStartIndex:int = 0)
		{
			super(cellWidth, cellHeight, 
				maxColCount, maxRowCount, 
				minColStartIndex, minRowStartIndex);
			
			mLampTowerCellsMap = [];
			mSceneObjectCellMap = new Dictionary();
			
			activeValidCellFunction = onActiveValidCell;
			deactiveInvalidCellFunction = onDeactiveInvalidCell;
			
			lampTowerCellCls ||= LampTowerCell;
		}
		
		public function clear():void
		{
			mLampTowerCellsMap = [];
			mSceneObjectCellMap = new Dictionary();
		}
		
		public function dispose():void
		{
			mLampTowerCellsMap = null;
			mSceneObjectCellMap = null;
		}
		
		public function getAllActivedItems():Vector.<SceneObject>
		{
			var cell:ILampTowerCell;
			
			var results:Vector.<SceneObject> = new Vector.<SceneObject>();
			
			for(var colIndex:int = validColStartIndex; colIndex < validColCount; colIndex++)
			{
				for(var rowIndex:int = validRowStartIndex; rowIndex < validRowCount; rowIndex++)
				{
					cell = getCellFromCellsMapping(colIndex, rowIndex);

					if(cell)
					{
						results.push.apply(null, cell.getItems());
					}
				}
			}
			
			return results;
		}

		public function addItem(item:SceneObject):SceneObject
		{
			if(mSceneObjectCellMap[item] !== undefined) return null;
			
			var colIndex:int = int(item.x / cellWidth);
			var rowIndex:int = int(item.y / cellHeight);
			
			var cell:ILampTowerCell = getCellFromCellsMapping(colIndex, rowIndex);
			if(!cell)
			{
				cell = createCell(cellWidth, cellHeight);
				establishCellsMapping(cell, colIndex, rowIndex);
			}
			
			//mapping
			mSceneObjectCellMap[item] = cell;
			cell.addItem(item);
			
			onItemAdded(item, cell);
			
			return item;
		}
		
		protected function onItemAdded(item:SceneObject, cell:ILampTowerCell):void
		{
		}
		
		public function removeItem(item:SceneObject):SceneObject
		{
			if(mSceneObjectCellMap[item] === undefined) return null;
			
			var cell:ILampTowerCell = mSceneObjectCellMap[item];
			
			delete mSceneObjectCellMap[item];
			cell.removeItem(item);
			
			onItemRemoved(item, cell);
			
			return item;
		}
		
		protected function onItemRemoved(item:SceneObject, cell:ILampTowerCell):void
		{
		}
		
		public function updateItem(item:SceneObject):SceneObject
		{
			if(mSceneObjectCellMap[item] !== undefined) return null;
			
			var lastCell:ILampTowerCell = mSceneObjectCellMap[item];	
			
			//check new cell
			var colIndex:int = int(item.x / cellWidth);
			var rowIndex:int = int(item.y / cellHeight);
			
			var cell:ILampTowerCell = getCellFromCellsMapping(colIndex, rowIndex);
			if(!cell)
			{
				cell = createCell(cellWidth, cellHeight);
				establishCellsMapping(cell, colIndex, rowIndex);
			}
			
			if(lastCell === cell) return item;
			
			delete mSceneObjectCellMap[item];
			lastCell.removeItem(item);
			
			mSceneObjectCellMap[item] = cell;
			cell.addItem(item);
			
			onItemUpdated(item, lastCell, cell);
			
			return item;
		}
		
		protected function onItemUpdated(item:SceneObject, lastCell:ILampTowerCell, newCell:ILampTowerCell):void
		{
		}
		
		protected function onActiveValidCell(colIndex:int, rowIndex:int):void
		{
			var cell:ILampTowerCell = getCellFromCellsMapping(colIndex, rowIndex);
			if(!cell)
			{
				cell = createCell(cellWidth, cellHeight);
				establishCellsMapping(cell, colIndex, rowIndex);
			}
			
			onValidCellActived(cell, colIndex, rowIndex);
		}

		protected function onValidCellActived(cell:ILampTowerCell, colIndex:int, rowIndex:int):void
		{
			cell.colIndex = colIndex;
			cell.rowIndex = rowIndex;
			cell.onActive();
		}
		
		protected function onDeactiveInvalidCell(colIndex:int, rowIndex:int):void
		{
			var cell:ILampTowerCell = getCellFromCellsMapping(colIndex, rowIndex);
			onInvalidCellDeactived(cell, colIndex, rowIndex);
		}
		
		protected function onInvalidCellDeactived(cell:ILampTowerCell, colIndex:int, rowIndex:int):void
		{
			cell.onDeActive();
		}
		
		protected function createCell(cellWidth:int, cellHeight:int):ILampTowerCell
		{
			var cell:ILampTowerCell = new lampTowerCellCls(cellWidth, cellHeight);
			cell.owner = this;
			return cell;
		}
		
		protected function getCellFromCellsMapping(colIndex:int, rowIndex:int):ILampTowerCell
		{
			return mLampTowerCellsMap[colIndex + ":" + rowIndex];
		}
		
		protected function establishCellsMapping(cell:ILampTowerCell, colIndex:int, rowIndex:int):void
		{
			mLampTowerCellsMap[colIndex + ":" + rowIndex] = cell;
		}
	}
}