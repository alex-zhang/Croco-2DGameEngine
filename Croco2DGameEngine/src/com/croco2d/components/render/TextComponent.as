package com.croco2d.components.render
{
	import flash.text.TextFieldAutoSize;
	
	import starling.display.DisplayObject;
	import starling.text.TextField;

	public class TextComponent extends DisplayObjectComponent
	{
		public var width:int = 100;//default
		public var height:int = 100;//default
		
		public var __text:String; 
		public var __fontName:String = "Verdana";//default
		public var __fontSize:Number = 12;
		public var __color:uint = 0x00;
		
		public var __hAlign:String = "center";
		public var __vAlign:String = "center";
		
		public var __border:Boolean = false;
		public var __bold:Boolean = false;
		public var __italic:Boolean = false;
		public var __underline:Boolean = false;
		public var __kerning:Boolean = false;
		public var __autoScale:Boolean = false;
		public var __autoSize:String = TextFieldAutoSize.NONE;
		public var __batchable:Boolean = false;
		public var __nativeFilters:Array = null;
		
		public var __textField:TextField;
		
		public function TextComponent()
		{
			super();
		}
		
		//dead end.
		override public function set dispalyObject(value:DisplayObject):void
		{
			throw new Error("u can't set the value.");
		}
		
		public function get text():String
		{
			return __text;
		}
		
		public function set text(value:String):void
		{
			__text = value;
			
			if(__textField)
			{
				__textField.text = __text;
			}
		}
		
		public function get fontName():String { return __fontName; }
		public function set fontName(value:String):void
		{
			if(__fontName != value)
			{
				__fontName = value;
				
				if(__textField)
				{
					__textField.fontName = __fontName;
				}
			}
		}
		
		public function get fontSize():Number { return __fontSize; }
		public function set fontSize(value:Number):void
		{
			if (__fontSize != value)
			{
				__fontSize = value;
				
				if(__textField)
				{
					__textField.fontSize = __fontSize;
				}
			}
		}
		
		/** The color of the text. For bitmap fonts, use <code>Color.WHITE</code> to use the
		 *  original, untinted color. @default black */
		public function get color():uint { return __color; }
		public function set color(value:uint):void
		{
			if (__color != value)
			{
				__color = value;
				
				if(__textField)
				{
					__textField.color = __color;
				}
			}
		}
		
		/** The horizontal alignment of the text. @default center @see starling.utils.HAlign */
		public function get hAlign():String { return __hAlign; }
		public function set hAlign(value:String):void
		{
			if (__hAlign != value)
			{
				__hAlign = value;
				
				if(__textField)
				{
					__textField.hAlign = __hAlign;
				}
			}
		}
		
		/** The vertical alignment of the text. @default center @see starling.utils.VAlign */
		public function get vAlign():String { return __vAlign; }
		public function set vAlign(value:String):void
		{
			if (__vAlign != value)
			{
				__vAlign = value;
			
				if(__textField)
				{
					__textField.vAlign = __vAlign;
				}
			}
		}
		
		/** Draws a border around the edges of the text field. Useful for visual debugging. 
		 *  @default false */
		public function get border():Boolean { return __border; }
		public function set border(value:Boolean):void
		{
			if(__border != value)
			{
				__border = value;
				
				if(__textField)
				{
					__textField.border = __border;
				}
			}
		}
		
		/** Indicates whether the text is bold. @default false */
		public function get bold():Boolean { return __bold; }
		public function set bold(value:Boolean):void 
		{
			if (__bold != value)
			{
				__bold = value;
				
				if(__textField)
				{
					__textField.bold = __bold;
				}
			}
		}
		
		/** Indicates whether the text is italicized. @default false */
		public function get italic():Boolean { return __italic; }
		public function set italic(value:Boolean):void
		{
			if (__italic != value)
			{
				__italic = value;
				
				if(__textField)
				{
					__textField.italic = __italic;
				}
			}
		}
		
		/** Indicates whether the text is underlined. @default false */
		public function get underline():Boolean { return __underline; }
		public function set underline(value:Boolean):void
		{
			if (__underline != value)
			{
				__underline = value;
				
				if(__textField)
				{
					__textField.underline = __underline;
				}
			}
		}
		
		/** Indicates whether kerning is enabled. @default true */
		public function get kerning():Boolean { return __kerning; }
		public function set kerning(value:Boolean):void
		{
			if (__kerning != value)
			{
				__kerning = value;
				
				if(__textField)
				{
					__textField.kerning = __kerning;
				}
			}
		}
		
		/** Indicates whether the font size is scaled down so that the complete text fits
		 *  into the text field. @default false */
		public function get autoScale():Boolean { return __autoScale; }
		public function set autoScale(value:Boolean):void
		{
			if (__autoScale != value)
			{
				__autoScale = value;
				
				if(__textField)
				{
					__textField.autoScale = __autoScale;
				}
			}
		}
		
		/** Specifies the type of auto-sizing the TextField will do.
		 *  Note that any auto-sizing will make auto-scaling useless. Furthermore, it has 
		 *  implications on alignment: horizontally auto-sized text will always be left-, 
		 *  vertically auto-sized text will always be top-aligned. @default "none" */
		public function get autoSize():String { return __autoSize; }
		public function set autoSize(value:String):void
		{
			if (__autoSize != value)
			{
				__autoSize = value;
				
				if(__textField)
				{
					__textField.autoSize = __autoSize;
				}
			}
		}
		
		/** Indicates if TextField should be batched on rendering. This works only with bitmap
		 *  fonts, and it makes sense only for TextFields with no more than 10-15 characters.
		 *  Otherwise, the CPU costs will exceed any gains you get from avoiding the additional
		 *  draw call. @default false */
		public function get batchable():Boolean { return __batchable; }
		public function set batchable(value:Boolean):void
		{
			if(__batchable != value)
			{
				__batchable = value;
				
				if(__textField)
				{
					__textField.batchable = __batchable;
				}
			}
		}
		
		/** The native Flash BitmapFilters to apply to this TextField. 
		 *  Only available when using standard (TrueType) fonts! */
		public function get nativeFilters():Array { return __nativeFilters; }
		public function set nativeFilters(value:Array) : void
		{
			__nativeFilters = value;
			
			if(__nativeFilters && __textField)
			{
				__textField.batchable = __batchable;
			}
		}
		
		override protected function onInit():void
		{
			__textField = new TextField(width, height, __text, __fontName, __fontSize, __color, __bold);
			__textField.hAlign = __hAlign;
			__textField.vAlign = __vAlign;
			__textField.border = __border;
			__textField.italic = __italic;
			__textField.underline = __underline;
			__textField.kerning = __kerning;
			__textField.autoScale = __autoScale;
			__textField.autoSize = __autoSize;
			__textField.batchable = __batchable;
			if(__nativeFilters)
			{
				__textField.nativeFilters = __nativeFilters;
			}
			
			super.dispalyObject = __textField;
		}
	}
}