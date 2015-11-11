/**
*TARVO TIIVITS
*09.11.2015
*/
package fileview.view.events {

	import flash.events.Event;
	import fileview.structure.composite.AComponent;

	public class ShowEvent extends Event {

		public static const SHOW_NODE_CHILDREN:String = "showNodeChildren";
		private var _node:AComponent;
		private var _visible:Boolean;
		
		public function ShowEvent(
										type:String,
										node:AComponent,
										visible:Boolean, 
										bubbles:Boolean = false,
								   		cancelable:Boolean = false
								   		) 
		{
			super(type, bubbles, cancelable);
			_node = node;
			_visible = visible;
		}

		public function get node():AComponent {
			return _node;
		}

		public function get visible():Boolean {
			return _visible;
		}

		override public function clone():Event {
			return new ShowEvent(ShowEvent.SHOW_NODE_CHILDREN, _node, _visible);
		}

	}
}