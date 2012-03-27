package canzam.mblocks {
	
	public class NoteColor {
		
		public static const COLORS:Array = [
			new NoteColor(0xFFFFFF,0,"Rest"), //rest
			new NoteColor(0x000000,-1,"Snare"), // percussion
			// First octave, dark colors
			new NoteColor(0xB40404, 261.63, "C3"), // Red
			new NoteColor(0xB45F04, 293.66, "D3"), // Orange
			new NoteColor(0xAEB404, 329.63, "E3"), // Yellow
			new NoteColor(0x5FB404, 349.23, "F3"), // Green
			new NoteColor(0x045FB4, 392.00, "G3"), // Blue
			new NoteColor(0x0404B4, 440.00, "A4"), // Violet
			new NoteColor(0xB404AE, 493.88, "B4"), // Purple
			// Second octave, light colors
			new NoteColor(0xFA5858, 523.25, "C4"), // Red
			new NoteColor(0xFAAC58, 587.33, "D4"), // Orange
			new NoteColor(0xF4FA58, 659.26, "E4"), // Yellow
			new NoteColor(0x58FA58, 698.46, "F4"), // Green
			new NoteColor(0x58ACFA, 783.99, "G4"), // Blue
			new NoteColor(0x5858FA, 880.00, "A5"), // Indigo
			new NoteColor(0xAC58FA, 987.77, "B5")  // Purple
		]
		
		
		private var _color:uint;
		private var _freq:Number;
		private var _letter:String;
		
		public function NoteColor(color:uint, frequency:Number, noteLetter:String) {
			_color = color;
			_freq = frequency;
			_letter = noteLetter;
		}
		
		public function get color():uint {
			return _color;
		}
		
		public function get frequency():Number {
			return _freq;
		}
		
		public function get letter():String {
			return _letter;
		}

	}
	
}
