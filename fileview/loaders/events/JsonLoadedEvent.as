package fileview.loaders.events {

	import flash.events.Event;
	import fileview.loaders.JsonLoader;

	public class JsonLoadedEvent extends Event {

		public static const JSON_IS_LOADED:String = "jsonLoaded";
		private var _data:String;
		
		public function JsonLoadedEvent(
										type:String,
										data:String, 
										bubbles:Boolean = false,
								   		cancelable:Boolean = false
								   		) 
		{
			super(type, bubbles, cancelable);
			_data = data;
		}

	public function get data():String {
			return _data;
		}
	}
}