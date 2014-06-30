package com.croco2d.core
{
	public class CrocoObjectGroup extends CrocoObjectSet
	{
		public function CrocoObjectGroup()
		{
			super();
		}
		
		/**
		 * Automatically goes through and calls update on everything you added.
		 */
		override public function tick(deltaTime:Number):void
		{
			super.tick(deltaTime);
			
			if(__childrenOrderSortDirty) sortChildrenOrder(sortFunction);
			
			var child:CrocoObject = __childrenLinkList.moveFirst();
			while(child)
			{
				if(child.__alive)
				{
					if(child.tickable)
					{
						child.tick(deltaTime);
					}
				}
				else
				{
					//when child is call kill(__alive is flase), whill delete and dispose in the next tick.
					child = __childrenLinkList.remove(child);
					__onRemoveChildCallback(child, true);
				}
				
				child = __childrenLinkList.moveNext();
			}
		}
		
//		override public function draw(support:RenderSupport, parentAlpha:Number):void
//		{
//			super.draw(support, parentAlpha);
//			
//			var child:CrocoObject = __childrenLinkList.moveFirst();
//			while(child)
//			{
//				if(child.__alive && child.visible)
//				{
//					child.draw(support, parentAlpha);
//				}
//				
//				child = __childrenLinkList.moveNext();
//			}
//		}
		
		/**
		 * Override this function to handle any deleting or "shutdown" type operations you might need,
		 * such as removing traditional Flash children like Sprite objects.
		 */
		override public function dispose():void
		{
			var child:CrocoObject = __childrenLinkList.moveFirst();
			while(child)
			{
				child.dispose();
				child = __childrenLinkList.moveNext();
			}
			
			super.dispose();
			
			sortFunction = null;
		}
		
		override protected function onAddChild(child:CrocoObject):void
		{
			child.parent = this;

			child.init();
			child.active();
		}
		
		override protected function onRemoveChild(child:CrocoObject, needDispose:Boolean = false):void
		{
			child.deactive();
			
			if(needDispose) child.dispose();
		}
	}
}