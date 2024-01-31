/*
 PureMVC AS3 / Flash Demo - HelloFlash
 By Cliff Hall <clifford.hall@puremvc.org>
 Copyright(c) 2007-08, Some rights reserved.
 */
package helloflash.view {
	
    import flash.events.Event;
	import flash.geom.Rectangle;
	
    import cv.pvc.interfaces.IMediator;

    import cv.pvc.PVC;
	import cv.pvc.events.PVCEvent;
	import helloflash.events.Notifications;
	import helloflash.model.SpriteDataProxy;
	import helloflash.view.components.HelloSprite;
    
    /**
     * A Mediator for interacting with the HelloSprite.
     */
    public class HelloSpriteMediator implements IMediator {
		
		private var spriteDataProxy:SpriteDataProxy;
		protected var facade:PVC;
		
		// The view component
		protected var viewComponent:Object;
       
	    /**
         * Constructor. 
         */
        public function HelloSpriteMediator(viewComponent:Object) {
            // pass the viewComponent to the superclass where 
            // it will be stored in the inherited viewComponent property
            //
            // *** Note that the name of the mediator is the same as the
            // *** id of the HelloSprite it stewards. It does not use a
            // *** fixed 'NAME' constant as most single-use mediators do
			this.viewComponent = viewComponent;	
			
			// Listen for events from the view component 
            helloSprite.addEventListener(HelloSprite.SPRITE_DIVIDE, onSpriteDivide);
        }
		
		/**
		 * Get the name of the <code>Mediator</code>.
		 * @return the Mediator name
		 */		
		public function getMediatorName():String {	
			return helloSprite.id;
		}
		
		/**
		 * Called by the View when the Mediator is registered
		 */ 
		public function onRegister(facade:PVC):void {
			this.facade = facade;
			facade.addEventListener(Notifications.SPRITE_DROP, onSpriteDrop, false, 0, true);
			facade.addEventListener(Notifications.SPRITE_SCALE, onSpriteDrop, false, 0, true);
			
			// Retrieve reference to frequently consulted Proxies
			spriteDataProxy = facade.retrieveProxy(SpriteDataProxy.NAME) as SpriteDataProxy;
		}
		
		/**
		 * Called by the View when the Mediator is removed
		 */ 
		public function onRemove():void {
			facade.removeEventListener(Notifications.SPRITE_DROP, onSpriteDrop);
			facade.removeEventListener(Notifications.SPRITE_SCALE, onSpriteDrop);
			facade = null;
		}
		
		protected function onSpriteDrop(note:PVCEvent):void {
			helloSprite.dropSprite();
		}
		
		protected function onSpriteScale(note:PVCEvent):void {
			var delta:Number = note.getBody() as Number;
			helloSprite.scaleSprite(delta);
		}
		
		/**
		 * Sprite divide.
		 * <P>
		 * User is dragging the sprite, send a notification to create a new sprite
		 * and pass the state the new sprite should inherit.
		 */
		private function onSpriteDivide(event:Event):void {
			helloSprite.color = spriteDataProxy.nextSpriteColor(helloSprite.color);
			facade.sendNotification(Notifications.STAGE_ADD_SPRITE, helloSprite.newSpriteState);
		}
		
        /**
         * Cast the viewComponent to its actual type.
         * 
         * <P>
         * This is a useful idiom for mediators. The
         * PureMVC Mediator class defines a viewComponent
         * property of type Object. </P>
         * 
         * <P>
         * Here, we cast the generic viewComponent to 
         * its actual type in a protected mode. This 
         * retains encapsulation, while allowing the instance
         * (and subclassed instance) access to a 
         * strongly typed reference with a meaningful
         * name.</P>
         * 
         * @return stage the viewComponent cast to HelloSprite
         */
        protected function get helloSprite():HelloSprite {
            return viewComponent as HelloSprite;
        }
    }
}