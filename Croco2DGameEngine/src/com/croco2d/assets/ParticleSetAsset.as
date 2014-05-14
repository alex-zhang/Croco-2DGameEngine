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
		private var mDefaultParticleName:String;
		
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
							
							if(!mDefaultParticleName)
							{
								mDefaultParticleName = zipFileName;
							}
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
		
		public function getDefaultParticleConfig():Array
		{
			if(mDefaultParticleName)
			{
				return getParticleConfigByName(mDefaultParticleName);
			}
			
			return null;
		}
		
		//return 0->XML 1->Texture
		private var particleConfigCache:Array = [];
		public function getParticleConfigByName(particalName:String):Array
		{
			var results:Array = particleConfigCache[particalName] as Array;
			if(!results)
			{
				//<texture name="texture.png"/>
				var particalXML:XML = mParticleXMLMap[particalName];
				var textureName:String = String(particalXML.texture.@name).split(".")[0];
				var texture:Texture = mSpriteSheetAsset.textureAtlas.getTexture(textureName);
				if(texture)
				{
					results = [particalXML, texture];
					particleConfigCache[particalName] = results;
				}
			}
			
			return results;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			particleConfigCache = null;
			
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