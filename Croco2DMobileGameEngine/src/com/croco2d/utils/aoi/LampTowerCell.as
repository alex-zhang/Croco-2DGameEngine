package com.croco2d.utils.aoi
{
	import com.croco2d.core.CrocoObject;
	import com.croco2d.core.CrocoObjectSet;
	import com.croco2d.entities.SceneEntity;

	public class LampTowerCell extends CrocoObjectSet
	{
		public var cellWidth:int = 0;
		public var cellHeight:int = 0;
		public var colIndex:int = 0;
		public var rowIndex:int = 0;

		public function LampTowerCell()
		{
			super();
		}
		
		override protected function onActive():void
		{
			super.onActive();
			
			var child:CrocoObject = __childrenLinkList.moveFirst();
			while(child)
			{
				if(child.__alive)
				{
					child.visible = true;
				}
				
				child = __childrenLinkList.moveNext();
			}
		}
		
		override protected function onDeactive():void
		{
			var child:CrocoObject = __childrenLinkList.moveFirst();
			while(child)
			{
				if(child.__alive)
				{
					child.visible = false;
				}
				
				child = __childrenLinkList.moveNext();
			}
		}
		
		override protected function onAddChild(child:CrocoObject):void
		{
			super.onAddChild(child);
			
			child.visible = __actived;
		}
		
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			var sceneEntity:SceneEntity = __childrenLinkList.moveFirst();
			while(sceneEntity)
			{
				if(sceneEntity.__alive)
				{
					updateChildGridCell(sceneEntity);
				}
				
				sceneEntity = __childrenLinkList.moveNext();
			}
		}
		
		protected function updateChildGridCell(sceneEntity:SceneEntity):void
		{
			LampTowerGrid(owner).updateSceneEntityLampTowerLocateCell(sceneEntity);
		}
	}
}