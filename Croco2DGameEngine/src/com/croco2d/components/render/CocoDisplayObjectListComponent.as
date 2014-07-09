package com.croco2d.components.render
{
	import com.croco2d.display.CocoDisplayObjectList;
	
	import starling.display.DisplayObject;

	public class CocoDisplayObjectListComponent extends DisplayObjectComponent
	{
		public var __displayObjectList:CocoDisplayObjectList;
		public var __childrenSortFunction:Function = CocoDisplayObjectList.childrenSortFunction;
		
		public function CocoDisplayObjectListComponent()
		{
			super();
		}
		
		public function invalidChildrenSort():void
		{
			if(__displayObjectList)
			{
				__displayObjectList.invalidChildrenSort();
			}
		}
		
		public function get childrenSortFunction():Function
		{
			return __childrenSortFunction;
		}
		
		public function set childrenSortFunction(value:Function):void
		{
			if(__childrenSortFunction != value)
			{
				__childrenSortFunction = value;
				
				if(__displayObjectList)
				{
					__displayObjectList.invalidChildrenSort();
				}
			}
		}
		
		public function addChild(child:DisplayObject):DisplayObject
		{
			if(__displayObjectList)
			{
				return __displayObjectList.addChild(child);
			}
			
			return null;
		}
		
		public function removeChild(child:DisplayObject, dispose:Boolean=false):DisplayObject
		{
			if(__displayObjectList)
			{
				return __displayObjectList.removeChild(child, dispose);
			}
			
			return null;
		}
		
		public function removeChildAt(index:int, dispose:Boolean=false):DisplayObject
		{
			if(__displayObjectList)
			{
				return __displayObjectList.removeChildAt(index, dispose);
			}
			
			return null;
		}
		
		public function removeChildren(beginIndex:int=0, endIndex:int=-1, dispose:Boolean=false):void
		{
			if(__displayObjectList)
			{
				return __displayObjectList.removeChildren(beginIndex, endIndex, dispose);
			}
		}
		
		public function getChildAt(index:int):DisplayObject
		{
			if(__displayObjectList)
			{
				return __displayObjectList.getChildAt(index);
			}
			
			return null;
		}
		
		public function getChildByName(name:String):DisplayObject
		{
			if(__displayObjectList)
			{
				return __displayObjectList.getChildByName(name);
			}
			
			return null;
		}
		
		public function getChildIndex(child:DisplayObject):int
		{
			if(__displayObjectList)
			{
				return __displayObjectList.getChildIndex(child);
			}
			
			return -1;
		}
		
		public function setChildIndex(child:DisplayObject, index:int):void
		{
			if(__displayObjectList)
			{
				__displayObjectList.setChildIndex(child, index);
			}
		}
		
		public function contains(child:DisplayObject):Boolean
		{
			if(__displayObjectList)
			{
				return __displayObjectList.contains(child);
			}
			
			return false;
		}
		
		public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			if(__displayObjectList)
			{
				__displayObjectList.swapChildren(child1, child2);
			}
		}
		
		public function swapChildrenAt(index1:int, index2:int):void
		{
			if(__displayObjectList)
			{
				__displayObjectList.swapChildrenAt(index1, index2);
			}
		}
		
		public function get numChildren():int 
		{ 
			if(__displayObjectList)
			{
				return __displayObjectList.numChildren;
			}
			
			return 0;
		}
		
		//dead end.
		override public function set dispalyObject(value:DisplayObject):void
		{
			throw new Error("u can't set the value.");
		}
		
		override protected function onInit():void
		{
			__displayObjectList = new CocoDisplayObjectList();
			__displayObjectList.invalidChildrenSort();

			super.dispalyObject = __displayObjectList;
		}
	}
}