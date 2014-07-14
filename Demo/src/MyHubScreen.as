package
{
	import com.croco2d.AppConfig;
	import com.croco2d.CrocoEngine;
	import com.croco2d.assets.CrocoAssetsManager;
	import com.croco2d.assets.ImageAsset;
	import com.croco2d.screens.PreloadHubScreen;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;

	public class MyHubScreen extends PreloadHubScreen
	{
		private var mTextfield:TextField;
		private var mImage:Image;
		
		public function MyHubScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			mTextfield = new TextField(200, 30, "");
			addChild(mTextfield);
			
			var globalAssetsManager:CrocoAssetsManager = CrocoEngine.globalAssetsManager;
			var imageAssetPath:String = AppConfig.findPreloadResourcePath("bg.jpg");
			var imageAsset:ImageAsset = globalAssetsManager.getImageAsset(imageAssetPath);
			
			mImage = new Image(imageAsset.texture);
			addChild(mImage);
		}
		
		override protected function onTargetScreenAssetsPreloadProgress(progress:Number):void
		{
			super.onTargetScreenAssetsPreloadProgress(progress);
			
			if(mTextfield)
			{
				mTextfield.text = int(parseFloat(progress.toExponential(2)) * 100).toString();
			}
		}
		
		override protected function screen_resizeHandler(event:Event):void
		{
			super.screen_resizeHandler(event);
			
			if(mTextfield)
			{
				mTextfield.x = (actualWidth - mTextfield.width) * 0.5;
				mTextfield.y = (actualWidth - mTextfield.width) * 0.3;	
			}
		}
	}
}