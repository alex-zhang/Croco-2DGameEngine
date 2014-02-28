package com.croco2d.display.animationSprite
{
	import starling.textures.TextureAtlas;

	public class AnimationSetInfo
	{
		public var name:String;
		public var pivotX:int = 0;
		public var pivotY:int = 0;
		public var width:int = 0;
		public var height:int = 0;
		public var metadata:Object;

		private var mAnimationInfos:Array = null;//<AnimationInfo>;
		private var mAnimationInfoCount:int = 0;
		
		private var mDefaultAnimationName:String;
		
		private var mAnimationSetTextureAtlas:TextureAtlas;
		
		public function AnimationSetInfo(animationSetTextureAtlas:TextureAtlas, animationSetXML:XML)
		{
			mAnimationSetTextureAtlas = animationSetTextureAtlas;
			deserializeFromXML(animationSetXML);
		}
		
		private function deserializeFromXML(xml:XML):void
		{
			this.metadata = {};
			
			this.mAnimationInfos = [];
			
			var i:int = 0, n:int = 0;
			
			pivotX = parseInt(xml.@pivotX);
			pivotY = parseInt(xml.@pivotY);
			width = parseInt(xml.@width);
			height = parseInt(xml.@height);
			
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

				animationInfo = new AnimationInfo(mAnimationSetTextureAtlas);
				animationInfo.deserializeFromXML(aniamtionXML);
				
				mDefaultAnimationName = animationInfo.name;
				
				mAnimationInfos[mDefaultAnimationName] = animationInfo;
			}
		}
		
		public function get defaultAniamtionName():String { return mDefaultAnimationName; };
		
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
			mDefaultAnimationName = null;
			mAnimationSetTextureAtlas = null;
		}
	}
}