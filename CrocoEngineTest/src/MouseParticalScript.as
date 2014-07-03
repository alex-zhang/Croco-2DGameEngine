package
{
	import com.croco2d.components.render.PDParticleSystemComponent;
	import com.croco2d.core.CrocoGameObject;
	import com.croco2d.core.CrocoObject;
	import com.fireflyLib.utils.GlobalPropertyBag;

	public class MouseParticalScript extends CrocoObject
	{
		public var particleSystemComponent:PDParticleSystemComponent
		public function MouseParticalScript()
		{
			super();
		}
		
		override protected function onInit():void
		{
			particleSystemComponent = CrocoGameObject(owner).renderComponent as PDParticleSystemComponent;
		}
		
		override public function tick(deltaTime:Number):void
		{
			var mouseX:Number = GlobalPropertyBag.stage.mouseX;
			var mouseY:Number = GlobalPropertyBag.stage.mouseY;
			
			particleSystemComponent.emitterX = mouseX;
			particleSystemComponent.emitterY = mouseY;
		}
	}
}