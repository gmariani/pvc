/*
 PureMVC AS3 / Flash Demo - HelloFlash
 By Cliff Hall <clifford.hall@puremvc.org>
 Copyright(c) 2007-08, Some rights reserved.
 */
package helloflash {
	
	import cv.pvc.PVC;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import cv.pvc.events.PVCEvent;
	import helloflash.events.Notifications;
	import helloflash.view.StageMediator;
    import helloflash.model.SpriteDataProxy;
    
    public class ApplicationFacade extends MovieClip {
		
		protected var facade:PVC;
		
		public function ApplicationFacade() {
			facade = PVC.getInstance("helloflash");
			
			facade.registerCommand(Notifications.STARTUP, startupCommand);
			
			facade.sendNotification(Notifications.STARTUP, stage);
		}
		
		/**
         * Register the Proxies and Mediators.
         * 
         * Get the View Components for the Mediators from the app,
         * which passed a reference to itself on the notification.
         */
        protected function startupCommand(note:PVCEvent):void {
			facade.registerProxy(new SpriteDataProxy());
	    	var stage:Stage = note.getBody() as Stage;
            facade.registerMediator(new StageMediator(stage));
			facade.sendNotification(Notifications.STAGE_ADD_SPRITE);
        }
    }
}