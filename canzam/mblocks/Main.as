package canzam.mblocks {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class Main extends Sprite {
		// Used to create the tiled background
		[Embed(source = 'wood_background.jpg')]
		private var WoodTile:Class;
		
		private var manager:BlockManager;
		private var control:ControlPanel;

		public function Main() {
			init();
		}
		
		private function init():void {
			manager = new BlockManager(this, stage);
			control = new ControlPanel(this, manager);
			
			// Set manager bounds to anywhere within the screen, excluding the control panel
			// so that when a block is dragged onto the control panel, it is deleted
			manager.bounds =  new Rectangle(control.width, 0, stage.stageWidth - control.width, stage.stageHeight);

			// Create a tiled wooden background
			var woodBG:Sprite = new Sprite();
			woodBG.graphics.beginBitmapFill(new WoodTile().bitmapData);
			woodBG.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			woodBG.graphics.endFill();
			
			// Add woodBG first so that it's underneath
			addChild(woodBG);
			addChild(control);
		}

	}


}