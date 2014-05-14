package com.croco2d.utils.aoi
{
	import com.croco2d.core.CrocoObject;
	import com.croco2d.core.CrocoObjectGroup;
	import com.croco2d.core.CrocoObjectSet;
	import com.croco2d.scene.SceneEntity;
	import com.croco2d.utils.ViewportGridUtil;
	import com.fireflyLib.utils.UniqueLinkList;
	
	import flash.geom.Rectangle;

	public class LampTowerGrid extends CrocoObject
	{
		public var lampTowerCellCls:Class;
		
		protected var mLampTowerCellMap:Vector.<LampTowerCell>;//cellIndex->LampTowerCell;
		protected var mInValidTowerCell:LampTowerCell;
		protected var mValidTowerCellSet:CrocoObjectSet;
		protected var mSceneEntitiesLinkList:UniqueLinkList;
		
		protected var mViewportCellGridUtil:ViewportGridUtil;
		
		public function LampTowerGrid(cellWidth:int, cellHeight:int,
										   maxColCount:int, maxRowCount:int)
		{
			mViewportCellGridUtil = new ViewportGridUtil(cellWidth, cellHeight, 
				maxColCount, maxRowCount);
			
			mViewportCellGridUtil.activeValidCellFunction = onActiveValidCell;
			mViewportCellGridUtil.deactiveInvalidCellFunction = onDeactiveInvalidCell;

			mLampTowerCellMap = new Vector.<LampTowerCell>(maxColCount * maxRowCount, true);
			mSceneEntitiesLinkList = new UniqueLinkList();

			lampTowerCellCls ||= LampTowerCell;
		}
		
		public function get cellWidth():int { return mViewportCellGridUtil.cellWidth };
		public function get cellHeight():int { return mViewportCellGridUtil.cellHeight };
		
		public function get maxColCount():int { return mViewportCellGridUtil.maxColCount };
		public function get maxRowCount():int { return mViewportCellGridUtil.maxRowCount };
		
		public function get viewPort():Rectangle { return mViewportCellGridUtil.viewPort; };

		public function setViewPort(viewPortX:Number, viewPortY:Number, 
									viewPortWidth:Number, viewPortHeight:Number):void
		{
			mViewportCellGridUtil.setViewPort(viewPortX, viewPortY, viewPortWidth, viewPortHeight);
		}
		
		public final function addSceneEntity(sceneEntity:SceneEntity):SceneEntity
		{
			var result:SceneEntity = mSceneEntitiesLinkList.add(sceneEntity) as SceneEntity;
			if(result)
			{
				onAddSceneEntity(sceneEntity);
			}

			return result;
		}
		
		protected function onAddSceneEntity(sceneEntity:SceneEntity):void
		{
			updateSceneEntityLampTowerLocateCell(sceneEntity);
		}
		
		public function updateSceneEntityLampTowerLocateCell(sceneEntity:SceneEntity):void
		{
			var sceneEntityPosX:Number = sceneEntity.x;
			var sceneEntityPosY:Number = sceneEntity.y;
			
			var colIndex:int = Math.floor(sceneEntityPosX / cellWidth);
			var rowIndex:int = Math.floor(sceneEntityPosY / cellHeight);
			
			var lastManager:LampTowerCell = sceneEntity.manager as LampTowerCell;
			
			var targetManager:LampTowerCell;
			
			if(isValidCellIndex(colIndex, rowIndex))
			{
				targetManager = getLampTowerCellFromCellsMapping(colIndex, rowIndex);
				if(!targetManager)
				{
					targetManager = createNewLampTowerCell(colIndex, rowIndex);
				}
			}
			else
			{
				if(!mInValidTowerCell)
				{
					mInValidTowerCell = createInvalidLampTowerCell();
				}
				
				targetManager = mInValidTowerCell;
			}
			
			if(targetManager !== lastManager)
			{
				if(lastManager)
				{
					lastManager.removeChild(sceneEntity);
				}
				
				if(targetManager)
				{
					targetManager.addChild(sceneEntity);
				}
			}
		}
		
		public final function removeSceneEntity(sceneEntity:SceneEntity):SceneEntity
		{
			var result:SceneEntity =  mSceneEntitiesLinkList.remove(sceneEntity) as SceneEntity;
			if(result)
			{
				onRemoveSceneEntity(sceneEntity);
			}
			
			return result;
		}
		
		protected function onRemoveSceneEntity(sceneEntity:SceneEntity):void
		{
			var targetManager:LampTowerCell = sceneEntity.manager as LampTowerCell;
			if(targetManager)
			{
				targetManager.removeChild(sceneEntity);
			}
		}
		
		public function hasSceneEntity(sceneEntity:SceneEntity):Boolean
		{
			return mSceneEntitiesLinkList.has(sceneEntity) as SceneEntity;
		}
		
		protected function onActiveValidCell(colIndex:int, rowIndex:int):void
		{
			var lampTowerCell:LampTowerCell = getLampTowerCellFromCellsMapping(colIndex, rowIndex);
			if(!lampTowerCell)
			{
				lampTowerCell = createNewLampTowerCell(colIndex, rowIndex);
			}
			
			lampTowerCell.active();
		}
		
		protected function onDeactiveInvalidCell(colIndex:int, rowIndex:int):void
		{
			var lampTowerCell:LampTowerCell = getLampTowerCellFromCellsMapping(colIndex, rowIndex);
			if(lampTowerCell)
			{
				lampTowerCell.deactive();
			}
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			mValidTowerCellSet = new CrocoObjectGroup();
			mValidTowerCellSet.name = "mValidTowerCellGroup";
			mValidTowerCellSet.__onAddChildCallback = onAddTowerCell;
			mValidTowerCellSet.__onRemoveChildCallback = onRemoveTowerCell;
			mValidTowerCellSet.init();
		}
		
		protected function onAddTowerCell(lampTowerCell:LampTowerCell):void
		{
			lampTowerCell.parent = mValidTowerCellSet;
			lampTowerCell.owner = this;
			lampTowerCell.init();
		}
		
		protected function onRemoveTowerCell(lampTowerCell:LampTowerCell, needDispose:Boolean = false):void
		{
			if(needDispose)
			{
				lampTowerCell.dispose();
			}
		}
		
		override protected function onActive():void
		{
			super.onActive();
			
			mValidTowerCellSet.active();
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			var lampTowerCell:LampTowerCell = mValidTowerCellSet.moveFirst() as LampTowerCell;
			while(lampTowerCell)
			{
				lampTowerCell.tick(deltaTime);
				
				lampTowerCell = mValidTowerCellSet.moveNext() as LampTowerCell;
			}
			
			if(mInValidTowerCell)
			{
				mInValidTowerCell.tick(deltaTime);
			}
			
			mViewportCellGridUtil.updateRangeChange();
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			lampTowerCellCls = null;
			
			if(mValidTowerCellSet)
			{
				mValidTowerCellSet.dispose();
				mValidTowerCellSet = null;
			}
			
			if(mInValidTowerCell)
			{
				mInValidTowerCell.dispose();
				mInValidTowerCell = null;
			}
			
			if(mLampTowerCellMap)
			{
				mLampTowerCellMap.fixed = false;
				mLampTowerCellMap.length = 0;
				mLampTowerCellMap = null;
			}
			
			if(mSceneEntitiesLinkList)
			{
				mSceneEntitiesLinkList.clear();
				mSceneEntitiesLinkList = null;
			}
		}
		
		protected function createInvalidLampTowerCell():LampTowerCell
		{
			var lampTowerCell:LampTowerCell = new LampTowerCell();
			lampTowerCell.name = "mInValidTowerCell";
			lampTowerCell.init();
			
			return lampTowerCell;
		}
		
		protected function createNewLampTowerCell(colIndex:int, rowIndex:int):LampTowerCell
		{
			var lampTowerCell:LampTowerCell = new lampTowerCellCls();
			var cellIndex:int = rowIndex * maxColCount;
			mLampTowerCellMap[cellIndex] = mLampTowerCellMap;
			
			mValidTowerCellSet.addChild(lampTowerCell);
			
			return lampTowerCell;
		}
		
		protected function getLampTowerCellFromCellsMapping(colIndex:int, rowIndex:int):LampTowerCell
		{
			if(isValidCellIndex(colIndex, rowIndex))
			{
				var cellIndex:int = rowIndex * maxColCount;
				return mLampTowerCellMap[cellIndex];
			}
			
			return null;
		}
		
		protected function isValidCellIndex(colIndex:int, rowIndex:int):Boolean
		{
			if(colIndex < 0 ||
				rowIndex < 0 ||
				colIndex > maxColCount - 1 ||
				rowIndex > maxRowCount - 1) return false;
			
			return true;
		}
	}
}