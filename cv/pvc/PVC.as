package cv.pvc {
	
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import cv.pvc.events.PVCEvent;
	import cv.pvc.interfaces.IProxy;
	import cv.pvc.interfaces.IMediator;
	
	public class PVC extends EventDispatcher {
		
		// The Multiton Facade instanceMap.
		protected static var instanceMap:Array = new Array();
		
		// References to Model, View and Controller
		protected var commandMap:Array = new Array();
		protected var proxyMap:Array = new Array();
		protected var mediatorMap:Array = new Array();
		
		// The Multiton Key for this app
		protected var _multitonKey:String;
		
		public function PVC(key:String) {
			if (hasCore(key)) throw Error("Facade instance for this Multiton key already constructed!");
			_multitonKey = key;
		}
		
		public function get multitonKey():String { return _multitonKey; }
		
		public static function getInstance(key:String):PVC {
			if (!hasCore(key)) instanceMap[key] = new PVC(key);
			return instanceMap[key];
		}
		
		/**
		 * Remove a Core.
		 * <P>
		 * Remove the Model, View, Controller and Facade 
		 * instances for the given key.</P>
		 * 
		 * @param multitonKey of the Core to remove
		 */
		public static function removeCore(key:String):void {
			if (!hasCore(key)) return;
			delete instanceMap[key];
		}
		
		/**
		 * Check if a Core is registered or not
		 * 
		 * @param key the multiton key for the Core in question
		 * @return whether a Core is registered with the given <code>key</code>.
		 */
		public static function hasCore(key:String):Boolean {
			return (instanceMap[key] != undefined);
		}
		
		/**
		 * Register an <code>ICommand</code> with the <code>Controller</code> by Notification name.
		 * 
		 * @param notificationName the name of the <code>INotification</code> to associate the <code>ICommand</code> with
		 * @param commandClassRef a reference to the Class of the <code>ICommand</code>
		 */
		public function registerCommand(notificationName:String, commandRef:Function):void {
			if (hasCommand(notificationName)) removeCommand(notificationName);
			commandMap[notificationName] = commandRef;
			addEventListener(notificationName, commandRef, false, 0, true);
		}
		
		/**
		 * Remove a previously registered <code>ICommand</code> to <code>INotification</code> mapping from the Controller.
		 * 
		 * @param notificationName the name of the <code>INotification</code> to remove the <code>ICommand</code> mapping for
		 */
		public function removeCommand(notificationName:String):void {
			removeEventListener(notificationName, commandMap[notificationName]);
			delete commandMap[notificationName];
		}
		
		/**
		 * Check if a Command is registered for a given Notification 
		 * 
		 * @param notificationName
		 * @return whether a Command is currently registered for the given <code>notificationName</code>.
		 */
		public function hasCommand(notificationName:String):Boolean	{
			return (commandMap[notificationName] != null);
		}
		
		/**
		 * Register an <code>IProxy</code> with the <code>Model</code> by name.
		 * 
		 * @param proxyName the name of the <code>IProxy</code>.
		 * @param proxy the <code>IProxy</code> instance to be registered with the <code>Model</code>.
		 */
		public function registerProxy(proxy:IProxy):void {
			if (hasProxy(proxy.getProxyName())) return;
			proxyMap[proxy.getProxyName()] = proxy;
			proxy.onRegister(this);
		}
		
		/**
		 * Retrieve an <code>IProxy</code> from the <code>Model</code> by name.
		 * 
		 * @param proxyName the name of the proxy to be retrieved.
		 * @return the <code>IProxy</code> instance previously registered with the given <code>proxyName</code>.
		 */
		public function retrieveProxy(proxyName:String):IProxy {
			return proxyMap[proxyName];
		}
		
		/**
		 * Remove an <code>IProxy</code> from the <code>Model</code> by name.
		 *
		 * @param proxyName the <code>IProxy</code> to remove from the <code>Model</code>.
		 * @return the <code>IProxy</code> that was removed from the <code>Model</code>
		 */
		public function removeProxy(proxyName:String):IProxy {
			var proxy:IProxy = proxyMap[proxyName] as IProxy;
			if (proxy) {
				delete proxyMap[proxyName];
				proxy.onRemove();
			}
			return proxy;
		}
		
		/**
		 * Check if a Proxy is registered
		 * 
		 * @param proxyName
		 * @return whether a Proxy is currently registered with the given <code>proxyName</code>.
		 */
		public function hasProxy(proxyName:String):Boolean {
			return (proxyMap[proxyName] != null);
		}
		
		/**
		 * Register a <code>IMediator</code> with the <code>View</code>.
		 * 
		 * @param mediatorName the name to associate with this <code>IMediator</code>
		 * @param mediator a reference to the <code>IMediator</code>
		 */
		public function registerMediator(mediator:IMediator):void {
			if (hasMediator(mediator.getMediatorName())) return;
			mediatorMap[mediator.getMediatorName()] = mediator;
			mediator.onRegister(this);
		}
		
		/**
		 * Retrieve an <code>IMediator</code> from the <code>View</code>.
		 * 
		 * @param mediatorName
		 * @return the <code>IMediator</code> previously registered with the given <code>mediatorName</code>.
		 */
		public function retrieveMediator(mediatorName:String):IMediator {
			return mediatorMap[mediatorName];
		}
		
		/**
		 * Remove an <code>IMediator</code> from the <code>View</code>.
		 * 
		 * @param mediatorName name of the <code>IMediator</code> to be removed.
		 * @return the <code>IMediator</code> that was removed from the <code>View</code>
		 */
		public function removeMediator(mediatorName:String):IMediator {
			// Retrieve the named mediator
			var mediator:IMediator = mediatorMap[mediatorName] as IMediator;
			if (mediator) {	
				delete mediatorMap[mediatorName];
				mediator.onRemove();
			}
			return mediator;
		}
		
		/**
		 * Check if a Mediator is registered or not
		 * 
		 * @param mediatorName
		 * @return whether a Mediator is registered with the given <code>mediatorName</code>.
		 */
		public function hasMediator(mediatorName:String):Boolean {
			return (mediatorMap[mediatorName] != null);
		}
		
		/**
		 * Create and send an <code>INotification</code>.
		 * 
		 * <P>
		 * Keeps us from having to construct new notification 
		 * instances in our implementation code.
		 * @param notificationName the name of the notiification to send
		 * @param body the body of the notification (optional)
		 * @param type the type of the notification (optional)
		 */ 
		public function sendNotification(notificationName:String, body:Object=null, type:String=null):void {
			dispatchEvent(new PVCEvent(notificationName, body, type));
		}
	}
}