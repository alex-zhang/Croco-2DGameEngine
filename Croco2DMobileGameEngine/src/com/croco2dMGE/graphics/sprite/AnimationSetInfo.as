package com.croco2dMGE.graphics.sprite
{
	import starling.textures.TextureAtlas;

	public class AnimationSetInfo
	{
		public var name:String;
		public var pivotX:int = 0;
		public var pivotY:int = 0;
		public var metadata:Object;

		private var mAnimationInfos:Array = null;//<AnimationInfo>;
		private var mAnimationInfoCount:int = 0;
		
		private var mTextureAtlas:TextureAtlas;
		
		public function AnimationSetInfo(textureAtlas:TextureAtlas)
		{
			mTextureAtlas = textureAtlas;
		}
		
		public function get textureAtlas():TextureAtlas
		{
			return mTextureAtlas;
		}
		
		public function deserializeFromXML(xml:XML):void
		{
			this.metadata = {};
			
			this.mAnimationInfos = [];
			
			var i:int = 0, n:int = 0;
			
			pivotX = parseInt(xml.@pivotX);
			pivotY = parseInt(xml.@pivotY);
			
			//metadata
			var metadataElements:XMLList = xml.Metadata.elements();
			for each(var metadataElementXML:XML in metadataElements)
			{
				metadata[metadataElementXML.name()] = metadataElementXML.valueOf().toString();
			}
			
			//Animation
			var animationXMLs:XMLList = xml.Animation;
			var animationInfo:AnimationInfo;
			var aniamtionXML:XML;
			n = animationXMLs.length();
			
			mAnimationInfoCount = n;
			
			for(i = 0; i < n; i++)
			{
				aniamtionXML = animationXMLs[i];
				animationInfo = new AnimationInfo(mTextureAtlas);
				animationInfo.deserializeFromXML(aniamtionXML);
				
				mAnimationInfos[animationInfo.name] = animationInfo;
			}
		}
		
		public function getAnimationCount():uint { return mAnimationInfoCount };
		
		public function getAnimationInfoByName(name:String):AnimationInfo
		{
			return mAnimationInfos[name] as AnimationInfo;
		}
		
		public function hasAnimation(name:String):Boolean
		{
			return mAnimationInfos[name] !== undefined;
		}
		
		public function dispose():void
		{
			for each(var animationInfo:AnimationInfo in mAnimationInfos)
			{
				animationInfo.dispose();
			}
			mAnimationInfos = null;
			
			mTextureAtlas = null;
		}
	}
}