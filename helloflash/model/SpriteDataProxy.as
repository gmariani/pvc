/*
 PureMVC AS3 / Flash Demo - HelloFlash
 By Cliff Hall <clifford.hall@puremvc.org>
 Copyright(c) 2007-08, Some rights reserved.
 */
package helloflash.model {
	
    import cv.pvc.interfaces.IProxy;
    import cv.pvc.interfaces.INotifier;

    public class SpriteDataProxy implements IProxy {
		
        public static const NAME:String = 'SpriteDataProxy';
		
		private var palette:Array;
		private var red:uint 	= 0xFF0000;
		private var green:uint  = 0x00FF00;
		private var blue:uint   = 0x0000FF;
		private var yellow:uint = 0xFFFF00;
		private var cyan:uint	= 0x00FFFF;
		
		// the data object
		protected var spriteCount:Number = Number(0);
		
        public function SpriteDataProxy() {
			palette = [ blue, red, yellow, green, cyan ];
        }
		
		// 
		public function nextSpriteColor(startColor:uint):uint {
			// identify color index
			var index:int;
			var found:Boolean = false;
			for ( var j:int=0; j<palette.length; j++) {
				index = j;
				if (startColor == palette[index]) break;
			}
			
			// select the next color in the palette
			index = (index == palette.length-1)?0:index+1;
			//return startColor;
			return palette[index];
		}
		
		/**
		 * Get the proxy name
		 */
		public function getProxyName():String {
			return NAME;
		}
		
		/**
		 * Called by the Model when the Proxy is registered
		 */ 
		public function onRegister(notifier:INotifier):void {}
		
		/**
		 * Called by the Model when the Proxy is removed
		 */ 
		public function onRemove( ):void {}
		
	    /**
		 * Get the next Sprite ID
		 */
		public function get nextSpriteID():String {
			return "sprite"+spriteCount++;
		}
    }
}