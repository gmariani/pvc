package cv.pvc.interfaces {
	
	import cv.pvc.PVC;
	
	public interface IMediator {
		
		/**
		 * Get the <code>IMediator</code> instance name
		 * 
		 * @return the <code>IMediator</code> instance name
		 */
		function getMediatorName():String;
		
		/**
		 * Called when the Mediator is registered
		 */ 
		function onRegister(facade:PVC):void;
		
		/**
		 * Called when the Mediator is removed
		 */ 
		function onRemove():void;
	}
}