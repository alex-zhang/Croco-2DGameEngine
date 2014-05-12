package com.croco2d.assets
{
	import com.croco2d.display.animationSprite.AnimationSetInfo;
	
	import deng.fzip.FZipFile;

	public class AnimationSetAsset extends ZipPackAsset
	{
		//aniSet.xml + spritSheet.SpritSheet
		public var animationSetInfo:AnimationSetInfo;
		
		private var mSpriteSheetAsset:SpriteSheetAsset;
		
		public function AnimationSetAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(animationSetInfo)
			{
				animationSetInfo.dispose();
				animationSetInfo = null;
			}
			
			if(mSpriteSheetAsset)
			{
				mSpriteSheetAsset.dispose();
				mSpriteSheetAsset = null;
			}
		}
		
		override protected function onZipAssetDeserialize():void
		{
			var aniSetXMLZipFile:FZipFile = zipPackFile.getFileByName("aniSet.xml");
			var aniSetXML:XML = new XML(aniSetXMLZipFile.content);
			
			var spriteSheetZipFile:FZipFile = zipPackFile.getFileByName("spritSheet.SpritSheet");
			
			mSpriteSheetAsset = new SpriteSheetAsset(spriteSheetZipFile.filename, 
				CrocoAssetsManager.SPRIT_SHEET_TYPE, 
				CrocoAssetsManager.SPRIT_SHEET_EXTENTION, null);
			
			mSpriteSheetAsset.loadBytes(spriteSheetZipFile.content, function():void {
				animationSetInfo = new AnimationSetInfo(mSpriteSheetAsset.textureAtlas, aniSetXML);
				
				onAssetLoadedCompeted();
			});
		}
	}
}