package
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.core.GameObject;
	import com.croco2d.screens.SceneScreen;
	
	import feathers.controls.TextInput;
	
	import starling.display.Image;

	public class MainScreen extends SceneScreen
	{
		private var mMainSceneGameObjectFactory:MainSceneGameObjectFactory;
		
		private var mImage:Image;
		
		public function MainScreen()
		{
			super();
		}
		
		override protected function initialize():void
		{
			mMainSceneGameObjectFactory = new MainSceneGameObjectFactory(this);
			
			super.initialize();
			
			var ti:TextInput = new TextInput();
			ti.text = "asdadadasdsadadasdsadadsad";
			ti.x = 200;
			ti.y = 300;
			ti.prompt = "as";
			addChild(ti);
		}
		
		override protected function createScene():GameObject
		{
			var camera:GameObject = CrocoEngine.camera;
			
//			camera.addGameObejct(mMainSceneGameObjectFactory.createImage2());
			
			return mMainSceneGameObjectFactory.createScene();
		}
	}
}