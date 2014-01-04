package com.croco2dMGE.utils.assets
{
	import com.fireflyLib.utils.dataRepo.DataRepository;

	public class ExcelDataRepositoryAsset extends BinaryAsset
	{
		public var dataRepository:DataRepository;
		
		public function ExcelDataRepositoryAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override protected function onBinaryBasedAssetDeserialize():void
		{
			dataRepository = new DataRepository();
			dataRepository.deserialize(byteArray);
			
			byteArray.clear();
			byteArray = null;
		}
	}
}