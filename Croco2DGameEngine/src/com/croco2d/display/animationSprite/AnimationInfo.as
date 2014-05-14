package com.croco2d.display.animationSprite
{
	import com.fireflyLib.utils.StringUtil;
	
	import starling.textures.TextureAtlas;

	public class AnimationInfo
	{
		public var name:String;
		public var frameRate:Number = 30;//default
		
		private var mFrames:Vector.<FrameInfo>;
		private var mTextureAtlas:TextureAtlas;
		
		public function AnimationInfo(textureAtlas:TextureAtlas)
		{
			super();

			mTextureAtlas = textureAtlas;
		}
		
		public function get textureAtlas():TextureAtlas
		{
			return mTextureAtlas;
		}
		
		public function getFrames():Vector.<FrameInfo>
		{
			return mFrames;
		}
		
		public function deserializeFromXML(xml:XML):void
		{
			this.mFrames = new Vector.<FrameInfo>();
			this.mFrames.fixed = false;
			//
			var i:int = 0, n:int = 0;
			
			this.name = xml.@name;
			this.frameRate = parseInt(xml.@frameRate);
			
			//Frame
			var frameXMLs:XMLList = xml.Frame;
			var frameXML:XML;
			n = frameXMLs.length();
			var frameInfo:FrameInfo;
			
			for(i = 0; i < n; i++)
			{
				frameXML = frameXMLs[i];
				
				frameInfo = new FrameInfo();
				mFrames.push(frameInfo);
				
				frameInfo.frame = i + 1;
				frameInfo.eventName = frameXML.hasOwnProperty("@event") ? frameXML.@event : null;
				if(frameXML.hasOwnProperty("@eventParams"))
				{
					frameInfo.eventParams = StringUtil.decodeKeyValueStr(frameXML.@eventParams);
				}
				frameInfo.texture = mTextureAtlas.getTexture(frameXML.@textureName);
			}
			
			this.mFrames.fixed = true;
		}
		
		public function getFrameCount():uint { return mFrames ? mFrames.length : 0; }
		
		public function getFrameAt(index:int):FrameInfo
		{
			if(index < 0 || index > getFrameCount() - 1) return null;
			
			return mFrames[index];
		}
		
		public function dispose():void
		{
			var frameInfo:FrameInfo = null;
			
			for(var i:int = 0, n:int = getFrameCount(); i < n; i++)
			{
				frameInfo = mFrames[i];
				
				frameInfo.dispose();
			}
			
			mFrames = null;
		}
	}
}