package com.croco2d.utils.tmx.data
{
	import com.croco2d.AppConfig;
	import com.croco2d.assets.CrocoAssetsManager;
	
	import starling.textures.Texture;

	/*<tileset firstgid="1" name="rules_sewers" tilewidth="32" tileheight="32">
		<image source="map001/sewer_automap/rules_sewers.png" width="72" height="48"/>
	   </tileset>*/
	public class TMXTileSheet extends TMXDataBasic
	{
		public var firstgid:int;
		
		public var name:String;
		
		public var tilewidth:int;//tile cell width in pixle
		public var tileHeight:int;//tile cell height in pixle
		
		//may be none if not set.
		public var spacing:int;
		public var margin:int;
		
		public var offsetX:int;
		public var offsetY:int;
		
		public var propertySet:TMXPropertySet;
		
		public var imageSource:String;
		
		//help
		public var numCol:int;//tile col num
		public var numRow:int;//tile row num
		//help prop for colTileCount * rowTileCount
		public var numTiles:int = 0;
		public var tileUvalue:Number = 0;
		public var tileVvalue:Number = 0;
		
		public var imageTexture:Texture;
		
		override public function deserialize(xml:XML):void 
		{
			super.deserialize(xml);
			
			firstgid = parseInt(xml.@firstgid);
			
			name = xml.@name;
			
			tilewidth = parseInt(xml.@tilewidth);
			tileHeight = parseInt(xml.@tileHeight);
			
			spacing = parseInt(xml.@spacing);
			margin = parseInt(xml.@margin);
			
			var tileoffsetXMl:XML = xml.tileoffset[0];
			if(tileoffsetXMl)
			{
				offsetX = parseInt(tileoffsetXMl.@x);
				offsetY = parseInt(tileoffsetXMl.@y);
			}
			
			propertySet = new TMXPropertySet();
			propertySet.deserialize(xml.properties[0]);
			
			//must has the image XML tag.
			var imageXML:XML = xml.image[0];
			
			imageSource = imageXML.@source;
			imageSource = AppConfig.findTargetScenePathResource(mapData.tmxMapScene.name, imageSource);
			
			var assetsManager:CrocoAssetsManager = mapData.tmxMapScene.screen.screenAssetsManager;
			imageTexture = assetsManager.getImageAsset(imageSource).texture;
			
			var imageWidth:int = parseInt(imageXML.@width);
			var imageHeight:int = parseInt(imageXML.@height);
			
			//helper
			numCol = Math.floor(imageWidth / tilewidth);
			numRow = Math.floor(imageHeight / tilewidth);
			numTiles = numCol * numRow;
			
			tileUvalue = 1 / numCol;
			tileVvalue = 1 / numRow;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			if(propertySet)
			{
				propertySet.clear();
				propertySet = null;
			}
			
			imageSource = null;
			imageTexture = null;
		}
	}
}