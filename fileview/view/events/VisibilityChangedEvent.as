/**
*TARVO TIIVITS
*11.11.2015
*/

package fileview.view.events {
	
	import flash.events.Event;

	public class VisibilityChangedEvent extends Event {
		
		public static const FILESYSTEM_VISIBILITY_CHANGED:String = "filesystemVisibilityChanged";

		public function VisibilityChangedEvent(
												type:String,
												bubbles:Boolean = false,
								   				cancelable:Boolean = false
								   			  ) 
		{
			super(type, bubbles, cancelable);
		}
	}
}