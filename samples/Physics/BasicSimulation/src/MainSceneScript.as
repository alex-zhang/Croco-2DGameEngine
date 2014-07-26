package
{
	import com.croco2d.CrocoEngine;
	import com.croco2d.components.physics.RigidbodyComponent;
	import com.croco2d.components.script.ScriptComponent;
	import com.croco2d.core.CrocoObjectEntity;
	import com.croco2d.core.GameObject;
	
	import nape.geom.Vec2;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import nape.shape.Polygon;

	public class MainSceneScript extends ScriptComponent
	{
		public function MainSceneScript()
		{
			super();
		}
		
		override public function onGameObjectInited():void
		{
			var go:GameObject;
			
			//floor
			go = GameObject.createFromJsonConfig(
				{
					clsType:GameObject,
					props:
					{
						initComponents:
						[
							{
								clsType:RigidbodyComponent,
								props:
								{
									debug:true,
									bodyType:BodyType.STATIC,
									shape: new Polygon(Polygon.rect(0, 0, CrocoEngine.stageWidth, 2)),
									position:Vec2.get(0, CrocoEngine.stageHeight - 10),
									physicsSpaceComponent:CrocoEngine.rootGameObject.physicsSpace
								}
							}
						]
					}
				});
			
			gameObject.addGameObejct(go);
			
			for (var i:int = 0; i < 15; i++)
			{
				go = GameObject.createFromJsonConfig(
					{
						clsType:GameObject,
						props:
						{
							initComponents:
							[
								{
									clsType:RigidbodyComponent,
									props:
									{
										debug:true,
										position:Vec2.get(CrocoEngine.stageWidth * 0.5, 
											(CrocoEngine.stageHeight - 10) - 20 * i),
										shape: new Polygon(Polygon.rect(0, 0, 30, 20)),
										physicsSpaceComponent:CrocoEngine.rootGameObject.physicsSpace
									}
								}
							]
						}
					});
				
				gameObject.addGameObejct(go);
			}
			
			//ball
			go = GameObject.createFromJsonConfig(
				{
					clsType:GameObject,
					props:
					{
						initComponents:
						[
							{
								clsType:RigidbodyComponent,
								props:
								{
									debug:true,
									shape: new Circle(40),
									position:Vec2.get(200, 50),
									angularVel:10,
									physicsSpaceComponent:CrocoEngine.rootGameObject.physicsSpace
								}
							}
						]
					}
				});
			
			gameObject.addGameObejct(go);
		}
		
		private function gameObjectInitHandler(eventObject:Object):void
		{
			gameObject.removeEventListener(CrocoObjectEntity.EVENT_INIT, gameObjectInitHandler);
		}
	}
}