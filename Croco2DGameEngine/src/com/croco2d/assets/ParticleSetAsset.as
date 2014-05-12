package com.croco2d.assets
{
	import flash.system.System;
	
	import deng.fzip.FZipFile;
	
	import starling.textures.Texture;

	public class ParticleSetAsset extends ZipPackAsset
	{
		//particleName.pex ...... + spritSheet.SpritSheet
		
		private var mParticleXMLMap:Array = [];//particleName->XML(.pex)
		private var mSpriteSheetAsset:SpriteSheetAsset;
		
		public function ParticleSetAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override protected function onZipAssetDeserialize():void
		{
			var spriteSheetZipFile:FZipFile = zipPackFile.getFileByName("spritSheet.SpritSheet");
			
			var zipFile:FZipFile;
			var zipFileFullName:String;
			var zipFileName:String;
			var zipFileExtension:String = null;
			var indexOfDot:int;
			
			var particleXML:XML;
			var n:int = zipPackFile.getFileCount();
			for(var i:int = 0; i < n; i++)
			{
				zipFile = zipPackFile.getFileAt(i);
				if(zipFile !== spriteSheetZipFile)
				{
					zipFileFullName = zipFile.filename;
					indexOfDot = zipFileFullName.lastIndexOf(".");
					if(indexOfDot != -1)
					{
						zipFileExtension = zipFileFullName.substr(indexOfDot + 1);
						if(zipFileExtension == "pex")
						{
							zipFileName = zipFileFullName.slice(0, indexOfDot);
							mParticleXMLMap[zipFileName] = new XML(zipFile.content);
						}
					}
				}
			}
			
			mSpriteSheetAsset = new SpriteSheetAsset(spriteSheetZipFile.filename, 
				CrocoAssetsManager.SPRIT_SHEET_TYPE, 
				CrocoAssetsManager.SPRIT_SHEET_EXTENTION, null);
			
			mSpriteSheetAsset.loadBytes(spriteSheetZipFile.content, function():void {
				onAssetLoadedCompeted();
			});
		}
		
		//return 0->XML 1->Texture
		public function getParticleConfigByName(particalName:String):Array
		{
			//<texture name="texture.png"/>
			var particalXML:XML = mParticleXMLMap[particalName];
			if(particalXML)
			{
				var textureName:String = String(particalXML.texture.@name).split(".")[0];
				var texture:Texture = mSpriteSheetAsset.textureAtlas.getTexture(textureName);
				if(texture)
				{
					return [particalXML, texture];
				}
			}
			
			return null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(mParticleXMLMap)
			{
				for each(var xml:XML in mParticleXMLMap)
				{
					System.disposeXML(xml);
				}
				
				mParticleXMLMap = null;
			}
		}
	}
}