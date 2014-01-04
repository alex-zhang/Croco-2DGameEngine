package com.croco2dMGE.utils.assets
{
	import flash.media.Sound;

	public class SoundAsset extends BinaryAsset
	{
		public var sound:Sound;
		
		public function SoundAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
	
		override protected function onBinaryBasedAssetDeserialize():void
		{
			sound = new Sound();
			
			sound.loadCompressedDataFromByteArray(byteArray, byteArray.length);
			
			byteArray.clear();
			byteArray = null;
		}
	}
}