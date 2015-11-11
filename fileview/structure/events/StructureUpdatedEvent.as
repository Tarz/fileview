package fileview.structure.events {

	import flash.events.Event;
	import fileview.structure.composite.AComponent;
	
	public class StructureUpdatedEvent extends Event {

		public static const STRUCTURE_UPDATED:String = "structureUpdated";
		private var _structure:AComponent;
		
		public function StructureUpdatedEvent(
										type:String,
										structure:AComponent, 
										bubbles:Boolean = false,
								   		cancelable:Boolean = false
								   		) 
		{
			super(type, bubbles, cancelable);
			_structure = structure;
		}
		
		public function get structure():AComponent {
			return _structure;
		}
	}
}
