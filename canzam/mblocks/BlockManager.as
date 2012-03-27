package canzam.mblocks {
	import flash.display.Stage;
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import com.coreyoneil.collision.CollisionList;
	
	public class BlockManager {
		private var _selected:Block = null;
		private var blocks:Vector.<Block> = new Vector.<Block>();
		private var activated:Vector.<Block> = new Vector.<Block>();
		private var collisionList:CollisionList;
		private var playing:Vector.<Block> = new Vector.<Block>();
		private var _noteTimer:Timer = new Timer(1000);
		
		private var display:DisplayObjectContainer;
		private var stage:Stage;
		private var _bounds:Rectangle;

		public function BlockManager(display:DisplayObjectContainer, stage:Stage, bounds:Rectangle = null) {
			this.display = display;
			this.stage = stage;
			this.bounds = bounds;
			// display acts as a placeholder, it won't be used
			collisionList = new CollisionList(display);
			
			_noteTimer.addEventListener(TimerEvent.TIMER, playNextNote);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, stageKeyDown);
		}
		
		public function add(b:Block):void {
			if (blocks.indexOf(b) == -1) {
				blocks.push(b);
				collisionList.addItem(b.blockShape);
				display.addChild(b);
				b.blockShape.addEventListener(MouseEvent.MOUSE_DOWN, blockMouseDown);
				b.blockShape.addEventListener(MouseEvent.MOUSE_UP, blockMouseUp);
				b.blockShape.addEventListener(MouseEvent.DOUBLE_CLICK, blockMouseDoubleClick);
				b.blockShape.doubleClickEnabled = true;
			}
		}
		
		// Returned value is true if block found an removed, false if not found
		public function remove(b:Block):Boolean {
			var index:int = blocks.indexOf(b);
			if (index != -1) {
				// Undo changes made by "add" method
				collisionList.removeItem(b.blockShape);
				display.removeChild(b);
				b.blockShape.removeEventListener(MouseEvent.MOUSE_DOWN, blockMouseDown);
				b.blockShape.removeEventListener(MouseEvent.MOUSE_UP, blockMouseUp);
				b.blockShape.removeEventListener(MouseEvent.DOUBLE_CLICK, blockMouseDoubleClick);
				
				// Reset to initial values
				b.effectArea.visible = false;
				b.rotateHandle.visible = false;
				b.blockShape.doubleClickEnabled = false;
				
				// Remove block from arrays using "splice" method
				blocks.splice(index, 1);
				
				index = activated.indexOf(b);
				if (index != -1) {
					activated.splice(index, 1);
				}
				
				index = playing.indexOf(b);
				if (index != -1) {
					playing.splice(index, 1);
				}
				
				if (b == selected) {
					selected = null;
				}
				
				return true;
			}
			
			return false;
		}
		
		// Remove all blocks from the display
		public function clear():void {
			while (blocks.length > 0) {
				remove(blocks[blocks.length - 1]);
			}
		}
		
		public function stopPlaying():void {
			for each (var b:Block in playing) {
				b.note.stop();
			}
			playing.length = 0;
			_noteTimer.stop();
		}
		public function get noteTimer():Timer {
			return _noteTimer;
		}
		
		public function set noteTimer(n:Timer):void {
			_noteTimer = n;
		}
		
		public function get selected():Block {
			return _selected;
		}
		
		public function set selected(b:Block):void {
			if (b != selected && selected != null) {
				deactivate();
				selected.effectArea.visible = false;
				selected.rotateHandle.visible = false;
			}
			if (b != null) {
				_selected = b;
				b.effectArea.visible = true;
				b.rotateHandle.visible = true;
				b.dragging = true;
				activated.push(b);
				activateEffected(b);
				// put block on top
				display.setChildIndex(b, display.numChildren - 1);
			}
		}
		
		public function get bounds():Rectangle {
			return _bounds;
		}
		
		public function set bounds(r:Rectangle):void {
			_bounds = r;
		}
		
		private function activate():void {
			for (var i:int = 0; i < activated.length; i++) {
				activated[i].effectArea.visible = true;
			}
		}
		
		private function deactivate():void {
			for (var i:int = 0; i < activated.length; i++) {
				activated[i].effectArea.visible = false;
			}
			activated.length = 0;
		}
		
		private function activateEffected(b:Block):void {
			activated.length = 0;
			findEffected(b, activated, true);
			activate();
		}
		
		// recursive helper function
		private function findEffected(target:Block, effected:Vector.<Block>, recursive:Boolean = false):void {
			collisionList.swapTarget(target.effectArea);
			var collisions:Array = collisionList.checkCollisions();
			
			for (var i:int = 0; i < collisions.length; i++) {
				var a:Object = collisions[i];
				var b:Block = (a.object1 is BlockShape ? a.object1.parent : a.object2.parent);
				
				if (effected.indexOf(b) == -1) {
					effected.push(b);
					if (recursive) {
						findEffected(b, effected, true);
					}
				}
			}
		}
		
		private function blockMouseDown(evt:MouseEvent):void {
			selected = Block(evt.target.parent);
		}
		
		private function blockMouseUp(evt:MouseEvent):void {
			var b:Block = Block(evt.target.parent);
			b.dragging = false;
			if (bounds != null && bounds.contains(b.x, b.y) == false) {
				remove(b);
			}
		}
		
		private function blockMouseDoubleClick(evt:MouseEvent):void {
			if (playing.length == 0) {
				var b:Block = Block(evt.target.parent);
				b.note.play();
				b.effectArea.pulse();
				playing.length = 1;
				playing[0] = b;
				_noteTimer.start();
			} else {
				trace('say whhaaaat');
			}
		}
		
		private function playNextNote(evt:TimerEvent):void {
			var playingNext:Vector.<Block> = new Vector.<Block>();
			for (var i:int = 0; i < playing.length; i++) {
				var b:Block = playing[i];
				findEffected(b, playingNext, false);
				var pos:int = playingNext.indexOf(b);
				if (pos != -1) {
					playingNext.splice(pos, 1); // remove b
					
			playing[i].rotation = playing[i].rotation + (playing[i].willFlip ? 180 : 0);
			playing[i].rotation = playing[i].rotation + playing[i].willRotate;
			playing[i].x = playing[i].x + playing[i].willTranslateX;
			playing[i].y = playing[i].y + playing[i].willTranslateY;
				}
			}
			playing = playingNext;
			if (playing.length == 0) {
				_noteTimer.stop();
			} else {
				for (i = 0; i < playing.length; i++) {
					playing[i].note.play();
					playing[i].effectArea.pulse();
				}
			}
			
		}
		
		private function stageMouseDown(evt:MouseEvent):void {
			if ((selected != null)
				&& (evt.target != selected.blockShape)
				&& !selected.rotating)
			{
				deactivate();
				selected.rotateHandle.visible = false;
				selected = null;
			}
		}
		
		private function stageMouseMove(evt:MouseEvent):void {
			if (selected != null && (selected.dragging || selected.rotating)) {
				deactivate();
				activateEffected(selected);
			}
		}
		
		private function stageKeyDown(evt:KeyboardEvent):void {
			if (evt.keyCode == Keyboard.DELETE) {
				remove(selected);
			}
		}

	}
	
}
