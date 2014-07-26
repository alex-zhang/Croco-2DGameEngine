package
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.components.physics.PhysicsSpaceComponent;
	import com.croco2d.core.GameObject;
	import com.croco2d.screens.SceneScreen;
	import com.fireflyLib.utils.JsonObjectFactorUtil;
	
	public class MainScreen extends SceneScreen
	{
		public function MainScreen()
		{
			super();
			
			CrocoEngine.debug = true;
		}
		
		override protected function createScene():GameObject
		{
			return GameObject.createFromJsonConfig(
				{
					clsType:GameObject,
					props:
					{
						debug:true,
						initComponents:
						[
							{
								clsType:PhysicsSpaceComponent,
								props:
								{
									debug:true
								}
							}
							,
							{
								clsType:MainSceneScript
							}
						]
					}
				}
			);
		}
	}
}