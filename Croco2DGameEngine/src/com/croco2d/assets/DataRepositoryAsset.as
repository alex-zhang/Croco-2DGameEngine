package com.croco2d.assets
{
	import com.fireflyLib.utils.dataRepo.DataRepository;

	public class DataRepositoryAsset extends BinaryAsset
	{
		public var dataRepository:DataRepository;
		
		public function DataRepositoryAsset(name:String, type:String, extention:String, url:String)
		{
			super(name, type, extention, url);
		}
		
		override protected function onBinAssetDeserialize():void
		{
			dataRepository = new DataRepository();
			dataRepository.deserialize(byteArray);
			
			byteArray.clear();
			byteArray = null;
			
			onAssetLoadedCompeted();
		}
	}
}