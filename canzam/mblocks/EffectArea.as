package canzam.mblocks{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.display.GradientType;

	public class EffectArea extends Shape {
		private var _radius:Number;
		private var _angle:Number;
		
		// gradient variables
		private var _color:uint = 0xff;
		private var _gradientProgress:Number = 0;
		private var _pulseStartTime:Number;
		private var _alphas:Array;
		private var _ratios:Array;

		public function EffectArea(radius:Number, angle:Number, color:uint) {
			_radius = radius;
			_angle = angle;
			_color = color;
			redraw();
		}
		
		public function hitTestBlock(b:Block):Boolean {
			return this.hitTestObject(b.blockShape);
		}
		
		public function pulse():void {
			addEventListener(Event.ENTER_FRAME, movePulse);
			_pulseStartTime = new Date().time;
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function set color(n:uint):void {
			_color = n;
			redraw();
		}

		public function get radius():Number {
			return _radius;
		}

		public function set radius(n:Number):void {
			_radius = n;
			redraw();
		}

		public function get angle():Number {
			return _angle;
		}

		public function set angle(n:Number):void {
			_angle = n;
			redraw();
		}
		
		private function beginGradientFill(radius:Number):void {
			var colors:Array;
			
			if (_gradientProgress > 0) {
				colors = [_color, _color, _color];
			} else {
				colors = [_color, _color];
				_alphas = [0.9, 0.3];
				_ratios = [0, 255];
			}
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(radius * 2, radius * 2, 0, -radius, -radius);
			graphics.beginGradientFill(GradientType.RADIAL, colors, _alphas, _ratios, matrix);
		}
		
		private function movePulse(evt:Event):void {
			_gradientProgress = (new Date().time - _pulseStartTime) / 1000;
			if (_gradientProgress >= 1) {
				_gradientProgress = 0;
				removeEventListener(Event.ENTER_FRAME, movePulse);
			} else {
				// We use 1.05 so the minimum alpha is 0.05 rather than full transparent
				var midAlpha:Number = 1.3 - Math.pow(_gradientProgress, 3);
				_alphas = [1 - midAlpha, midAlpha, 0.3];
				_ratios = [0, _gradientProgress * 255, 255];
			}
			redraw();
		}

		private function redraw():void {
			graphics.clear();
			var angle:Number = _angle * (Math.PI / 180);
			var startAngle:Number =  (-angle / 2) - (Math.PI / 2);
			var endAngle:Number = (angle / 2) - (Math.PI / 2);
			
			beginGradientFill(_radius);
			// Draw the path of the circle with a resolution of 1 degree,
			// so an angle of 45 degrees will have 45 subpaths
			for (var i:Number = startAngle; i < endAngle; i += Math.PI / 180) {
				graphics.lineTo(_radius * Math.cos(i), _radius * Math.sin(i));
			}
			graphics.lineTo(0, 0);
			graphics.endFill();
		}

	}

}