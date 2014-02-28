package com.croco2d.assets
{
	import com.fireflyLib.utils.coralPackFile.CoralPackFile;
	
	import flash.system.System;
	
	import starling.textures.Texture;

	public class ParticleSetAsset extends SpriteSheetAsset
	{
		private var mParticleXMLMap:Array = [];//pureFileName->XML(.pex)
		private var mDefaultParticleName:String;
		
		public function ParticleSetAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override protected function onBinaryBasedAssetDeserialize():void
		{
			super.onBinaryBasedAssetDeserialize();
			
			var allFiles:Vector.<CoralPackFile> = coralPackDirFile.getAllFiles();
			var n:int = allFiles.length;
			
			var file:CoralPackFile;
			var particalXml:XML;
			
			for(var i:int = 0; i < n; i++)
			{
				file = allFiles[i];
				
				if(file.extention == "pex")
				{
					mDefaultParticleName = file.pureName;
					particalXml = new XML(file.contentBytes);
					mParticleXMLMap[mDefaultParticleName] = particalXml;
				}
			}
		}
		
		public function getDefaultParticleConfig():Array
		{
			return getParticleConfigByName(mDefaultParticleName);
		}
		
		//return 0->XML 1->Texture
		public function getParticleConfigByName(particalName:String):Array
		{
			//<texture name="texture.png"/>
			var particalXML:XML = mParticleXMLMap[particalName];
			if(particalXML)
			{
				var textureName:String = String(particalXML.texture.@name).split(".")[0];
				var texture:Texture = textureAtlas.getTexture(textureName);
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