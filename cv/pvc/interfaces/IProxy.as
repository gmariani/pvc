package cv.pvc.interfaces {
	
	import cv.pvc.interfaces.INotifier;
	
	public interface IProxy {
		
		/**
		 * Get the <code>IProxy</code> instance name
		 * 
		 * @return the <code>IProxy</code> instance name
		 */
		function getProxyName():String;
		
		/**
		 * Called when the Proxy is registered
		 */ 
		function onRegister(notifier:INotifier):void;
		
		/**
		 * Called when the Proxy is removed
		 */ 
		function onRemove():void;
	}
}