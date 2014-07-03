package com.croco2d.components.render
{
	import com.croco2d.assets.ParticleSetAsset;
	import com.llamaDebugger.Logger;
	
	import starling.core.RenderSupport;
	import starling.extensions.PDParticleSystem;

	public class PDParticleSystemComponent extends RenderComponent
	{
		public var particleSetAsset:ParticleSetAsset;
		public var particleName:String;

		public var __particleSystem:PDParticleSystem;

		public function PDParticleSystemComponent()
		{
			super();
		}
		
		override protected function onInit():void
		{
			if(!particleSetAsset)
			{
				Logger.error("PDParticleSystemComponent onInit error: particleSetAsset is null");
				return;
			}
			
			var xmlAndTexture:Array = particleName ? 
				particleSetAsset.getParticleConfigByName(particleName) :
				particleSetAsset.getDefaultParticleConfig();

			__particleSystem = new PDParticleSystem(xmlAndTexture[0], xmlAndTexture[1]);
		}
		
		override public function tick(deltaTime:Number):void
		{
			if(__particleSystem)
			{
				__particleSystem.advanceTime(deltaTime);
			}
		}
		
		override public function draw(support:RenderSupport, parentAlpha:Number):void
		{
			if(__particleSystem)
			{
				__particleSystem.render(support, parentAlpha);
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(__particleSystem)
			{
				__particleSystem.dispose();
				__particleSystem = null;
			}
		}
	}
}