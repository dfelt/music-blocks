package canzam.mblocks{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.*;

	public class Block extends Sprite {
		// child DisplayObjects
		private var _blockShape:BlockShape;
		private var _effectArea:EffectArea;
		private var _rotateHandle:RotateHandle;
		private var _noteLetter:TextField = new TextField();
		
		// plays sound
		private var _note:Note;
		
		// properties
		private var _rotating:Boolean = false;
		private var _rotation:Number = 0;
		private var _dragging:Boolean = false;
		private var _noteColor:NoteColor;
		private var _willRotate:Number = 0;
		private var _willFlip:Boolean = false;
		private var _willTranslateX:Number = 0;
		private var _willTranslateY:Number = 0;
		private var _special:String;

		public function Block(sideLength:Number, effectRadius:Number, 
				effectAngle:Number, nc:NoteColor, sp:String) {
			_blockShape = new BlockShape(sideLength, nc.color);
			_effectArea = new EffectArea(effectRadius, effectAngle, nc.color);
			_rotateHandle = new RotateHandle(sideLength / 2 + 10);
			_note = new Note(nc.frequency, sideLength / 200, this);
			_noteLetter.text = nc.letter;
			_noteColor = nc;
			_special = sp;
			if (sp == "Flip")
			{
				_willFlip = true;
			}
			if (sp == "Rotate 90 right")
			{
				_willRotate = 90;
			}
			if (sp == "Rotate 90 left")
			{
				_willRotate = -90;
			}
			if (sp == "Trans 50 r")
			{
				_willTranslateX = 100;
			}
			if (sp == "Trans 50 l")
			{
				_willTranslateX = -100;
			}
			if (sp == "Trans 50 u")
			{
				_willTranslateY = -100;
			}
			if (sp == "Trans 50 d")
			{
				_willTranslateY = 100;
			}
			init();
		}
		
		private function init():void {
			// init block shape
			// We use weak references because blockShape is an element of this class, and would
			// therefore never be garbage collected with a strong reference
			_blockShape.addEventListener(MouseEvent.MOUSE_OVER, blockShapeMouseOver, false, 0, true);
			_blockShape.addEventListener(MouseEvent.MOUSE_OUT, blockShapeMouseOut, false, 0, true);
			
			// init effect area
			_effectArea.visible = false;
			
			// init note letter textfield
			_noteLetter.selectable = false;
			_noteLetter.mouseEnabled = false;
			_noteLetter.visible = false;
			reformatNoteLetter();
			
			
			// init rotate handle
			_rotateHandle.addEventListener(MouseEvent.MOUSE_DOWN, rotateHandleMouseDown);
			_rotateHandle.visible = false;
			
			// add children in order of display from bottom -> top
			addChild(_effectArea);
			addChild(_rotateHandle);
			addChild(_blockShape);
			addChild(_noteLetter);
			
		}
		
		public function clone():Block {
			var b:Block = new Block(blockShape.sideLength, effectArea.radius,
									effectArea.angle, noteColor, _special );
			b.x = this.x;
			b.y = this.y;
			b.rotation = this.rotation;
			return b;
		}
		public function get special():String {
			return _special;
		}
		public function set special(s:String):void {
			_special = s;
		}
		public function get willTranslateX():Number {
			return _willTranslateX;
		}
		public function set willTranslateX(n:Number):void {
			_willTranslateX = n;
		}
		public function get willTranslateY():Number {
			return _willTranslateY;
		}
		public function set willTranslateY(n:Number):void {
			_willTranslateY = n;
		}
		public function get willFlip():Boolean {
			return _willFlip;
		}
		public function set willFlip(b:Boolean):void {
			_willFlip = b;
		}
		public function get willRotate():Number {
			return _willRotate;
		}
		public function set willRotate(n:Number):void {
			_willRotate = n;
		}
		public function get blockShape():BlockShape {
			return _blockShape;
		}
		
		public function get effectArea():EffectArea {
			return _effectArea;
		}
		
		public function get rotateHandle():RotateHandle {
			return _rotateHandle;
		}
		
		public function get rotating():Boolean {
			return _rotating;
		}
		
		public function get dragging():Boolean {
			return _dragging;
		}
		
		public function set dragging(b:Boolean):void {
			_dragging = b;
			if (b)
				startDrag();
			else
				stopDrag();
		}
		
		override public function get rotation():Number {
			return _rotation;
		}
		
		override public function set rotation(value:Number):void {
			_rotation = value;
			// rotate all display children except the note letter, which should 
			// remain upright for easy readability
			// somewhat of a hack but it works
			_blockShape.rotation = _rotation;
			_effectArea.rotation = _rotation;
			_rotateHandle.rotation = _rotation;
		}
		
		// No need for a setter, as we always want note to be non-null
		public function get note():Note {
			return _note;
		}
		
		public function get noteColor():NoteColor {
			return _noteColor;
		}
		
		public function set noteColor(nc:NoteColor):void {
			_noteColor = nc;
			_blockShape.color = nc.color;
			_effectArea.color = nc.color;
			_note.frequency = nc.frequency;
			reformatNoteLetter();
		}
		
		public function get sideLength():Number {
			return _blockShape.sideLength;
		}
		
		public function set sideLength(n:Number):void {
			_blockShape.sideLength = n;
			// Reformat note letter text field to fit new size
			reformatNoteLetter();
		}
		
		// Positions the noteLetter field and makes the first character large
		private function reformatNoteLetter():void {
			var fmt:TextFormat = new TextFormat();
			fmt.size = Math.min(25, sideLength * 0.7);
			fmt.align = TextFormatAlign.CENTER;
			_noteLetter.text = _noteColor.letter;
			_noteLetter.setTextFormat(fmt, 0, 1);
			_noteLetter.x = -_noteLetter.width / 2;
			_noteLetter.y = -_noteLetter.textHeight / 2;
		}
		
		private function blockShapeMouseOver(evt:MouseEvent):void {
			_noteLetter.visible = true;
		}
		
		private function blockShapeMouseOut(evt:MouseEvent):void {
			_noteLetter.visible = false;
		}
		
		private function rotateHandleMouseDown(evt:MouseEvent):void {
			_rotating = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
			// stop from propagating to block, which will begin dragging
			evt.stopPropagation();
		}
		
		private function stageMouseMove(evt:MouseEvent):void {
			if (_rotating) {
				var angle:Number = Math.atan2(stage.mouseY - y, stage.mouseX - x);
				// convert to degrees, offset by 90 to account for the rotate handle's
				// position being at -90
				rotation =  angle * 180 / Math.PI + 90;
			}
		}
		
		private function stageMouseUp(evt:MouseEvent):void {
			if (_rotating) {
				_rotating = false;
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
			}
		}
	}

}