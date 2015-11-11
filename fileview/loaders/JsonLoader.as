package fileview.loaders {

	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import fileview.loaders.events.JsonLoadedEvent;

	public class JsonLoader extends URLLoader {
		
		public function JsonLoader() {}

		public function startLoading(path:String):void {
			
			configureListeners();

			var request:URLRequest=new URLRequest(path);
			this.dataFormat = "text";
			
			try {
				load(request);
			}catch(e:Error){
				trace(e + " Unable to load json!");
			}
		}

		private function configureListeners():void {
			this.addEventListener(Event.COMPLETE, completeHandler);
			
			//...more listeners !?
		}

		private function completeHandler(event:Event):void {
			dispatchEvent(new JsonLoadedEvent(JsonLoadedEvent.JSON_IS_LOADED, this.data));
			this.removeEventListener(Event.COMPLETE, completeHandler);
		}

		public function destroy():void {
			close();
		}
	}
}