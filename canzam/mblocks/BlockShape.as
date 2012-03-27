package canzam.mblocks {
	import flash.display.Sprite;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	
	public class BlockShape extends Sprite {
		private var _sideLength:Number;
		private var _color:uint;
		
		public function BlockShape(sideLength:Number, color:uint) {
			_sideLength = sideLength;
			_color = color;
			
			var bevel:BevelFilter = new BevelFilter();
			bevel.distance = 2.0;
			bevel.strength = 0.7;
			var shadow:DropShadowFilter = new DropShadowFilter();
			shadow.distance = 4.0;
			shadow.alpha = 0.5;
			this.filters = [bevel, shadow];
			
			redraw();
		}
		
		public function set sideLength(n:Number):void {
			_sideLength = n;
			redraw();
		}
		
		public function get sideLength():Number {
			return _sideLength;
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function set color(n:uint):void {
			_color = n;
			redraw();
		}
		
		private function redraw():void {
			with (graphics) {
				clear();
				lineStyle(1);
				beginFill(color);
				drawRect(-sideLength / 2, -sideLength / 2, sideLength, sideLength);
				endFill();
			}
		}

	}
	
}
