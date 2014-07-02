package com.croco2d.components.bt
{
	import com.fireflyLib.utils.PropertyBag;

	public class BTRootNode extends SelectorBTNode
	{
		public var __propertyBag:PropertyBag;
		
		public function get propertyBag():PropertyBag
		{
			if(!__propertyBag) __propertyBag = new PropertyBag();
			
			return __propertyBag;
		}
		
		public function BTRootNode(childrenNodes:Vector.<BTNode>)
		{
			super(childrenNodes);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(__propertyBag)
			{
				__propertyBag.dispose();
				__propertyBag = null;
			}
		}
	}
}