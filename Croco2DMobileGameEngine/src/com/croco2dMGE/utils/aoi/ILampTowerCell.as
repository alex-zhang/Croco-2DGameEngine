package com.croco2dMGE.utils.aoi
{
	import com.croco2dMGE.world.SceneObject;

	public interface ILampTowerCell
	{
		function get colIndex():int;
		function set colIndex(value:int):void;
		
		function get rowIndex():int;
		function set rowIndex(value:int):void;
		
		function get cellWidth():int;
		function get cellHeight():int;
		
		function get owner():LampTowerGrid;
		function set owner(value:LampTowerGrid):void;
		
		function addItem(item:SceneObject):SceneObject;
		function removeItem(item:SceneObject):SceneObject;
		
		function getItems():Vector.<SceneObject>;
		
		function onActive():void;
		function onDeActive():void;
		
		
	}
}