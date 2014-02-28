package com.croco2d.assets
{
	import com.croco2d.display.animationSprite.AnimationSetInfo;
	
	import flash.utils.ByteArray;

	public class AnimationSetAsset extends SpriteSheetAsset
	{
		//aniSet.xml,spritesheet.atf,spritesheet.xml
		public var animationSetInfo:AnimationSetInfo;
		
		public function AnimationSetAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override protected function onBinaryBasedAssetDeserialize():void
		{
			super.onBinaryBasedAssetDeserialize();
			
			var aniSetXMLBytes:ByteArray = coralPackDirFile.getFile("aniSet.xml").contentBytes;
			animationSetInfo = new AnimationSetInfo(textureAtlas, new XML(aniSetXMLBytes));
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(animationSetInfo)
			{
				animationSetInfo.dispose();
				animationSetInfo = null;
			}
		}
	}
}