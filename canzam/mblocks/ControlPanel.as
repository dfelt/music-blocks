package canzam.mblocks {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.utils.Timer;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.display.DisplayObjectContainer;


	public class ControlPanel extends ControlPanel_Base {
		// Variables of ControlPanel_Base:
		// + sizeSlider:Slider
		// + sizeCombo:ComboBox
		// + pitchSlider:Slider
		// + pitchCombo:ComboBox
		// + removeBlocksButton:Button
		// + stopPlayingButton:Button
		// + helpButton:Button

		private var window:DisplayObjectContainer;
		private var manager:BlockManager;
		private var block:Block;
		private var helper:HelpDialog;
		private var deleter:DeleteDialog;
		private var samples:SampleDialog;
		private var startHere:StartHere;

		public function ControlPanel(window:DisplayObjectContainer, manager:BlockManager){
			this.window = window;
			this.manager = manager;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(evt:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Add bevel and drop shadow filters for 3D effect
			var bevel:BevelFilter = new BevelFilter();
			bevel.distance = 3.0;
			bevel.strength = 0.7;
			var shadow:DropShadowFilter = new DropShadowFilter();
			shadow.distance = 4.0;
			shadow.alpha = 0.5;
			this.filters = [bevel, shadow];
			
			// Add number to size combo box
			for (var i:int = 1; i <= 10; i++){
				sizeCombo.addItem({label: i});
			}
			
			
			// Add note letters to letter combo box
			for (i = 0; i < NoteColor.COLORS.length; i++){
				var letter:String = NoteColor.COLORS[i].letter;
				pitchCombo.addItem({label: letter});
			}
			
			
			// Add specialCombo items
			specialCombo.addItem({label:"None"});
			specialCombo.addItem({label:"Flip"});
			specialCombo.addItem({label:"Rotate 90"});
			specialCombo.addItem({label:"Trans 50 l"});
			specialCombo.addItem({label:"Trans 50 u"});
			specialCombo.addItem({label:"Trans 50 r"});
			specialCombo.addItem({label:"Trans 50 d"});
			
			// Configure size slider
			sizeSlider.minimum = 0;
			sizeSlider.maximum = sizeCombo.length - 1;
			sizeSlider.snapInterval = 1;
			sizeSlider.liveDragging = true;

			// Configure pitch slider
			pitchSlider.minimum = 0;
			pitchSlider.maximum = pitchCombo.length - 1;
			pitchSlider.snapInterval = 1;
			pitchSlider.liveDragging = true;
			
			// Configure tempo slider
			
			// Start at size 6 block, which is a nice size
			sizeSlider.value = 5;
			sizeCombo.selectedIndex = 5;
			// Start at C3, or middle C. Also, it shows up well against
			// the wood background compared to C4
			pitchSlider.value = 8;
			pitchCombo.selectedIndex = 8;

			// The contructor values are unimportant, as they will be modified anyway
			// by the values of the sliders
			block = new Block(50, 100, 30, NoteColor.COLORS[0],"");
			block.x = 75;
			block.y = 75;
			// We take out the filters because the ControlPanel already has filters
			// applied to it, so the effect is needlessly multiplied if the block
			// has filters as well
			block.blockShape.filters = [];
			modifyBlock();
			addChild(block);
			
			helper = new HelpDialog();
			deleter = new DeleteDialog();
			samples = new SampleDialog();
			startHere = new StartHere();
			
			block.addEventListener(MouseEvent.MOUSE_DOWN, genesis);
			sizeSlider.addEventListener(Event.CHANGE, sizeSliderChanged);
			sizeCombo.addEventListener(Event.CHANGE, sizeComboChanged);
			pitchCombo.addEventListener(Event.CHANGE, pitchComboChanged);
			pitchSlider.addEventListener(Event.CHANGE, pitchSliderChanged);
			removeBlocksButton.addEventListener(MouseEvent.CLICK, removeBlocksDialog);
			deleter.xButton.addEventListener(MouseEvent.CLICK,noDelete);
			deleter.noButton.addEventListener(MouseEvent.CLICK,noDelete);
			deleter.yesButton.addEventListener(MouseEvent.CLICK,yesDelete);
			stopPlayingButton.addEventListener(MouseEvent.CLICK, stopPlaying);
			helpButton.addEventListener(MouseEvent.CLICK, showHelp);
			helper.xButton.addEventListener(MouseEvent.CLICK, hideHelp);
			startHere.xButton.addEventListener(MouseEvent.CLICK, removeStartHereDialog);
			sampleSongsButton.addEventListener(MouseEvent.CLICK, showSamples);
			samples.xButton.addEventListener(MouseEvent.CLICK, hideSamples);
			samples.maryHadALittleLambButton.addEventListener(MouseEvent.CLICK, showSong1);
			samples.twinkleTwinkleLittleStarButton.addEventListener(MouseEvent.CLICK, showSong2);
			specialCombo.addEventListener(Event.CHANGE, specialComboChanged);
			
		}
		private function specialComboChanged(evt:Event) {
			modifyBlock();
		}
		
		private function startHereDialog(x:Number, y:Number):void {
			if (contains(startHere) == false) {
				startHere.x = x;
				startHere.y = y;
				window.addChild(startHere);
			}
		}
		private function removeStartHereDialog(evt:MouseEvent):void {
			window.removeChild(startHere);
		}		
		
		private function removeBlocksDialog(evt:MouseEvent):void {
			if (contains(deleter) == false) {
				deleter.x = 200;
				deleter.y = 200;
				window.addChild(deleter);
			}
		}
		private function showSamples(evt:MouseEvent):void{
			if (contains(samples) == false) {
				samples.x = 175;
				samples.y = 50;
				window.addChild(samples);
			}
		}
		private function hideSamples(evt:MouseEvent):void {
			window.removeChild(samples);
		}
		private function showSong1(evt:MouseEvent):void {
			window.removeChild(samples);
			removeBlocks(null);
			createBlock(4,200,125,90);
			createBlock(3,275,125,90);
			createBlock(2,375,125,90);	
			createBlock(3,450,125,90);
			createBlock(4,525,125,90);
			createBlock(4,600,125,180);
			createBlock(4,600,200,180);
			createBlock(0,600,275,180);
			createBlock(3,600,350,180);
			createBlock(3,600,425,270);
			createBlock(3,525,425,270);
			createBlock(0,450,425,270);
			createBlock(4,375,425,270);
			createBlock(6,300,425,270);
			createBlock(6,225,425,0);
			createBlock(0,225,350,0);
			createBlock(4,225,275,0);
			createBlock(3,225,200,90);
			createBlock(2,300,200,90);
			createBlock(3,375,200,90);
			createBlock(4,450,200,90);
			createBlock(4,525,200,180);
			createBlock(4,525,275,180);
			createBlock(4,525,350,270);
			createBlock(3,450,350,270);
			createBlock(3,375,350,270);
			createBlock(4,300,350,0);
			createBlock(3,300,275,90);
			createBlock(2,375,275,90);
			startHereDialog(200,125);
		}
		private function showSong2(evt:MouseEvent):void {
			window.removeChild(samples);
			removeBlocks(null);
			createBlockRotate90Right(4,200,400,90);
			createBlockFlip(3,275,400,90);
			createBlockFlip(2,350,400,90);
			createBlockFlip(0,425,400,0);
			createBlock(4,425,325,270);
			createBlock(3,350,325,270);
			createBlock(2,275,325,270);
			createBlockRotate90Left(0,200,325,0);
			createBlock(2,200,250,90);
			createBlock(2,275,250,90);
			createBlock(3,350,250,90);
			createBlock(3,425,250,180);
			startHereDialog(200,400);
		}
		
		private function createBlock(nc:Number, x:Number , y:Number , rotation:Number):void{
			var b;
			b = new Block(50, 100, 30, NoteColor.COLORS[nc], null);
			manager.add(b);
			b.x = x;
			b.y = y;
			b.rotation = rotation;
		}
		
		private function createBlockRotate90Right(nc:Number, x:Number , y:Number , rotation:Number):void{
			var b;
			b = new Block(50, 100, 30, NoteColor.COLORS[nc], "Rotate 90 right");
			manager.add(b);
			b.x = x;
			b.y = y;
			b.rotation = rotation;
		}
		
		private function createBlockRotate90Left(nc:Number, x:Number , y:Number , rotation:Number):void{
			var b;
			b = new Block(50, 100, 30, NoteColor.COLORS[nc], "Rotate 90 left");
			manager.add(b);
			b.x = x;
			b.y = y;
			b.rotation = rotation;
		}
		private function createBlockFlip(nc:Number, x:Number , y:Number , rotation:Number):void{
			var b;
			b = new Block(50, 100, 30, NoteColor.COLORS[nc], "Flip");
			manager.add(b);
			b.x = x;
			b.y = y;
			b.rotation = rotation;
		}
		
		private function yesDelete(evt:MouseEvent):void {
			window.removeChild(deleter);
			removeBlocks(evt);
		}
		private function noDelete(evt:MouseEvent):void {
			window.removeChild(deleter);
		}
		private function removeBlocks(evt:MouseEvent):void {
			manager.clear();
		}
		
		private function stopPlaying(evt:MouseEvent):void {
			manager.stopPlaying();
		}
		
		private function showHelp(evt:MouseEvent):void {
			if (contains(helper) == false) {
				window.addChild(helper);
				// The Helper is centered on the screen when helper.x = 175
				helper.x = 175;
				helper.y = -helper.height;
				addEventListener(Event.ENTER_FRAME, moveHelp);
			}
		}
		
		// Slide the help dialog into position
		private function moveHelp(evt:Event):void {
			// The helper is centered on the screen when helper.y = 7.5
			helper.y = Math.min(7.5 , helper.y + 40);
			if (helper.y == 7.5) {
				removeEventListener(Event.ENTER_FRAME, moveHelp);
			}
		}
		
		private function hideHelp(evt:MouseEvent):void {
			window.removeChild(helper);
		}

		private function genesis(evt:MouseEvent):void {
			var b:Block = block.clone();
			manager.add(b);
			manager.selected = b;
			// The target of this event is not the newly created block,
			// so it will be immediately deselected by the manager if
			// the event is allowed to bubble to the stage.
			evt.stopPropagation();
		}

		private function modifyBlock():void {
			var size:Number = 10 * (sizeCombo.selectedIndex + 1);
			block.sideLength = size;
			block.effectArea.radius = size * 2;
			block.note.amplitude = (sizeCombo.selectedIndex + 1) / 200;
			block.noteColor = NoteColor.COLORS[pitchCombo.selectedIndex];
			block.special = specialCombo.selectedLabel;
		}

		private function sizeSliderChanged(evt:Event):void {
			sizeCombo.selectedIndex = sizeSlider.value;
			modifyBlock();
		}

		private function sizeComboChanged(evt:Event):void {
			sizeSlider.value = sizeCombo.selectedIndex;
			modifyBlock();
		}

		private function pitchSliderChanged(evt:Event):void {
			pitchCombo.selectedIndex = pitchSlider.value;
			modifyBlock();
		}

		private function pitchComboChanged(evt:Event):void {
			pitchSlider.value = pitchCombo.selectedIndex;
			modifyBlock();
		}

	}
}