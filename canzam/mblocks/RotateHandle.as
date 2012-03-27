package canzam.mblocks {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class RotateHandle extends Sprite {
		private var radius:Number;
		private var expanded:Boolean = false;

		public function RotateHandle(radius:int) {
			this.radius = radius;
			redraw();
			addEventListener(MouseEvent.MOUSE_OVER, expand);
			addEventListener(MouseEvent.MOUSE_OUT, contract);
		}
		
		private function expand(evt:MouseEvent):void {
			expanded = true;
			redraw();
		}
		
		private function contract(evt:MouseEvent):void {
			expanded = false;
			redraw();
		}
		
		private function redraw():void {
			var diameter:Number = (expanded ? 6 : 3);
			with (graphics) {
				clear();
				lineStyle(1);
				lineTo(0, -radius);
				beginFill(0x00ff00);
				drawCircle(0, -radius, diameter);
				endFill();
			}
			
		}

	}
	
}
