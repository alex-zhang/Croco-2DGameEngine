package com.croco2d.assets
{
	import com.fireflyLib.utils.coralPackFile.CoralPackDirFile;
	
	public class CoralDirPackAsset extends BinaryAsset
	{
		public var coralPackDirFile:CoralPackDirFile;
		
		public function CoralDirPackAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(coralPackDirFile)
			{
				coralPackDirFile.dispose();
				coralPackDirFile = null;
			}
		}
		
		override protected function onBinaryBasedAssetDeserialize():void
		{
			coralPackDirFile = new CoralPackDirFile();
			coralPackDirFile.deserialize(byteArray);
		}
	}
}