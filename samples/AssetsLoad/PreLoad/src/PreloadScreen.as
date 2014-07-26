package
{
	import com.croco2d.screens.FlashBootStrapScreen;
	import com.llamaDebugger.Logger;
	
	import flash.display.Bitmap;
	import flash.display.Shape;

	public class PreloadScreen extends FlashBootStrapScreen
	{
		[Embed(source="assets/cover.png")]
		private var mImgCls:Class;
		
		private var mImage:Bitmap;
		private var mProgress:Shape;
		
		public function PreloadScreen()
		{
			super();
		}
		
		override public function launch():void
		{
			super.launch();
			
			mImage = new mImgCls();
			mImage.width = stage.stageWidth;
			mImage.height = stage.stageHeight;
			addChild(mImage);
			
			mProgress = new Shape();
			addChild(mProgress);
		}
		
		override public function onAssetsPreloadProgress(progress:Number):void
		{
			super.onAssetsPreloadProgress(progress);
			
			Logger.debug("preload progress{0}", progress);
			
			mProgress.graphics.clear();
			mProgress.graphics.beginFill(0xFF0000);
			mProgress.graphics.drawRect(0, stage.stageHeight * 0.6, stage.stageWidth * progress, 5);
			mProgress.graphics.endFill();
		}
	}
}