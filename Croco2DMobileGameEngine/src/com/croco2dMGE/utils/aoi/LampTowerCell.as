package com.croco2dMGE.utils.aoi
{
	import com.croco2dMGE.world.SceneLayer;
	import com.croco2dMGE.world.SceneObject;

	public class LampTowerCell implements ILampTowerCell
	{
		private var mCellWidth:int = 0;
		private var mCellHeight:int = 0;
		
		private var mColIndex:int = 0;
		private var mRowIndex:int = 0;
		
		private var mOwner:LampTowerGrid;
		
		protected var mSceneObjects:Vector.<SceneObject>;
		
		public function LampTowerCell()
		{
			super();
			
			mSceneObjects = new Vector.<SceneObject>();
		}
		
		public function get colIndex():int { return mColIndex; };
		public function set colIndex(value:int):void 
		{
			mColIndex = value;
		}
		
		public function get rowIndex():int { return mRowIndex; };
		public function set rowIndex(value:int):void 
		{
			mRowIndex = value;
		}
		
		public function get cellWidth():int { return mCellWidth; };
		public function get cellHeight():int { return mCellHeight; };
		
		public function get owner():LampTowerGrid { return mOwner; };
		public function set owner(value:LampTowerGrid):void { mOwner = value; }
		
		public function onActive():void
		{
			var n:int = mSceneObjects.length;
			var sceneObject:SceneObject;
			
			for(var i:int = 0; i < n; i++)
			{
				sceneObject = mSceneObjects[i];
				
				onSceneObjectActived(sceneObject);
			}
		}
		
		protected function onSceneObjectActived(item:SceneObject):void
		{
			SceneLayer(item.owner).addItem(item);
		}
		
		public function onDeActive():void
		{
			var n:int = mSceneObjects.length;
			var sceneObject:SceneObject;
			
			for(var i:int = 0; i < n; i++)
			{
				sceneObject = mSceneObjects[i];
				
				onSceneObjectDeActived(sceneObject);
			}
		}
		
		protected function onSceneObjectDeActived(item:SceneObject):void
		{
			var owner:SceneLayer = SceneLayer(item.owner)
			SceneLayer(item.owner).removeItem(item);
			item.owner = owner;
		}
		
		public function addItem(item:SceneObject):SceneObject
		{
			var index:int = mSceneObjects.indexOf(item);
			if(index == -1)
			{
				mSceneObjects.push(item);
				
				return item;
			}
			
			return null;
		}
		
		public function removeItem(item:SceneObject):SceneObject
		{
			var index:int = mSceneObjects.indexOf(item);
			if(index != -1)
			{
				mSceneObjects.splice(index, 1);
				
				return item;
			}
			
			return null;
		}
		
		public function getItems():Vector.<SceneObject>
		{
			return mSceneObjects;
		}
	}
}