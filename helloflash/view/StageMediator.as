/*
 PureMVC AS3 / Flash Demo - HelloFlash
 By Cliff Hall <clifford.hall@puremvc.org>
 Copyright(c) 2007-08, Some rights reserved.
 */
package helloflash.view {

    import flash.events.Event;
    import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;

    import cv.pvc.interfaces.IMediator;

    import cv.pvc.PVC;
    import cv.pvc.events.PVCEvent;
	import helloflash.events.Notifications;
	import helloflash.view.HelloSpriteMediator;
	import helloflash.view.components.HelloSprite;
	import helloflash.model.SpriteDataProxy;

    /**
     * A Mediator for interacting with the Stage.
     */
    public class StageMediator implements IMediator {
        // Canonical name of the Mediator
        public static const NAME:String = 'StageMediator';

		protected var facade:PVC;

		private var spriteDataProxy:SpriteDataProxy;

		// The view component
		protected var viewComponent:Object;

        /**
         * Constructor.
         */
        public function StageMediator( viewComponent:Object ) {
            // pass the viewComponent to the superclass where
            // it will be stored in the inherited viewComponent property
			this.viewComponent = viewComponent;

            // Listen for events from the view component
            stage.addEventListener( MouseEvent.MOUSE_UP, handleMouseUp );
            stage.addEventListener( MouseEvent.MOUSE_WHEEL, handleMouseWheel );
        }

		/**
		 * Get the name of the <code>Mediator</code>.
		 * @return the Mediator name
		 */
		public function getMediatorName():String {
			return NAME;
		}

		/**
		 * Called by the View when the Mediator is registered
		 */
		public function onRegister(facade:PVC):void {
			this.facade = facade;
			facade.addEventListener(Notifications.STAGE_ADD_SPRITE, onStageAddSprite, false, 0, true);

			// Retrieve reference to frequently consulted Proxies
			spriteDataProxy = facade.retrieveProxy( SpriteDataProxy.NAME ) as SpriteDataProxy;
		}

		/**
		 * Called by the View when the Mediator is removed
		 */
		public function onRemove():void {
			facade.removeEventListener(Notifications.STAGE_ADD_SPRITE, onStageAddSprite);
			facade = null;
		}

		protected function onStageAddSprite(note:PVCEvent):void {
			var params:Array = note.getBody() as Array;
			var helloSprite:HelloSprite = new HelloSprite( spriteDataProxy.nextSpriteID, params );
			facade.registerMediator(new HelloSpriteMediator( helloSprite ));
			stage.addChild( helloSprite );
		}

		// The user has released the mouse over the stage
        private function handleMouseUp(event:MouseEvent):void {
			facade.sendNotification(Notifications.SPRITE_DROP);
		}

		// The user has released the mouse over the stage
        private function handleMouseWheel(event:MouseEvent):void {
			facade.sendNotification(Notifications.SPRITE_SCALE, event.delta);
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
         * @return stage the viewComponent cast to flash.display.Stage
         */
        protected function get stage():Stage {
            return viewComponent as Stage;
        }
    }
}