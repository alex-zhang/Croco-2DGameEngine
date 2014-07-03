package
{
	import com.croco2d.screens.CrocoScreen;
	
	import flash.utils.setTimeout;
	
	import starling.display.Quad;

	public class Hubscreen1 extends CrocoScreen
	{
		public function Hubscreen1()
		{
			super();
		}
		
		override protected function initialize():void
		{
			super.initialize();
			
			var quad:Quad = new Quad(100, 100, 0xFF0000);
			addChild(quad);
			
			setTimeout(function():void {jump2OwnerScreen()}, 2000)
		}
	}
}