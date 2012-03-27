package canzam.mblocks {
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.events.SampleDataEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.media.SoundMixer;

	public class Note {
		// Wave constants
		private static const SAMPLING_RATE:Number = 44100;
		private static const TWO_PI:Number = 2 * Math.PI;
		private static const TWO_PI_OVER_SR:Number = TWO_PI / SAMPLING_RATE;
		private static const MAX_SAMPLES:Number = 8192;
		private var _block:Block;
		public var frequency:Number;
		public var amplitude:Number;

		private var _sound:Sound = new Sound();
		private var _soundChannel:SoundChannel;
		
		public function Note(frequency:Number, amplitude:Number, block:Block){
			this.frequency = frequency;
			this.amplitude = amplitude;
			_block = block;
			_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, generateSineWave);
		}

		public function play():void {
			stop();
			_soundChannel = _sound.play();
			
		}

		public function stop():void {
			if (_soundChannel != null){
				_soundChannel.stop();
			}
			
			
			//canzam
		}

		private function generateSineWave(evt:SampleDataEvent):void {
			if(frequency >= 0)
			{
			var calculateVolume:Function = evt.position == 0 ? sinIncrease : linearDecrease;
			var sample:Number;
			// End the note by returning fewer than 2048 samples after it plays for 1 second
			var end:Number = Math.min(SAMPLING_RATE, evt.position + MAX_SAMPLES);
			
			for (var i:Number = evt.position; i < end; i++) {
				sample = calculateVolume(i) * amplitude * Math.sin(i * TWO_PI_OVER_SR * frequency);
				evt.data.writeFloat(sample);
				evt.data.writeFloat(sample);
			}
			}
			else
			{
			var mySound:CleanSnare = new CleanSnare();
			var _soundChannel = mySound.play(50);
			}
		}
		
		// Increase the volume to from 0 to 1 along a sin wave over a duration of MAX_SAMPLES
		private function sinIncrease(n:Number):Number {
			return Math.sin( (Math.PI / 2) * (n / MAX_SAMPLES) );
		}
		
		// Decrease the volume from 1 to 0 along a decreasing linear function over a
		// duration of SAMPLING_RATE - MAX_SAMPLES
		private function linearDecrease(n:Number):Number {
			return 1 - ( (n - MAX_SAMPLES) / (SAMPLING_RATE - MAX_SAMPLES) );
		}

	}
}