package com.croco2dMGE.world.entities
{
	import com.croco2dMGE.CrocoEngine;
	import com.croco2dMGE.world.SceneEntity;
	
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class ParticleEntity extends SceneEntity
	{
		public var particleSystemCls:Class;

		public var particleConfig:XML;
		public var particleTexture:Texture;
		
		protected var mParticleSystem:PDParticleSystem;
		
		public function ParticleEntity()
		{
			super();
		}
		
		override protected function onInit():void
		{
			if(!particleConfig || !particleTexture) throw new Error("particleConfig and particleTexture can't be null!");
			
			particleSystemCls ||= PDParticleSystem;
			
			mParticleSystem = new particleSystemCls(particleConfig, particleTexture);
			displayObject = mParticleSystem;
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			mParticleSystem = null;
		}
		
		public function start(duration:Number=Number.MAX_VALUE):void
		{
			if(mParticleSystem) mParticleSystem.start(duration);
		}
		
		public function stop(clearParticles:Boolean=false):void
		{
			if(mParticleSystem) mParticleSystem.stop(clearParticles);
		}
		
		public function clear():void
		{
			if(mParticleSystem) mParticleSystem.clear();
		}
		
		override protected function drawDisplayObject():void
		{
			mParticleSystem.advanceTime(CrocoEngine.deltaTime);
			
			super.drawDisplayObject();
		}
	}
}