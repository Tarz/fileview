/**
*TARVO TIIVITS
*07-08.11.2015
*/

package fileview.view.buttons {

	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import fileview.structure.composite.AComponent;
	import fileview.structure.composite.iterators.IIterator;
	import fileview.view.buttons.TreeButton;
	import fileview.view.events.*;

	public class ButtonOrganizer extends EventDispatcher {

		
		var _buttonArray:Array;
		
		public function ButtonOrganizer(
										structure:AComponent, 
										buttonArray:Array
										) 
		{
			_buttonArray = buttonArray; //Memorize buttons 
			createAndRenderButtons(structure); //Start
		}

		//Start recursive traversing from here
		public function createAndRenderButtons(node:AComponent):void {
			var iterator:IIterator = node.iterator();
			while(iterator.hasNext()) {
				var nNode:AComponent = iterator.next();
				createButton(nNode);
			}
		}
		
		private function createButton(node:AComponent):void {
			var button:TreeButton = new TreeButton(node);
			button.addEventListener(ShowEvent.SHOW_NODE_CHILDREN, listenButton);
			_buttonArray.push(button); //Memorize
			recursivelyTraverse(node);
		}

		private function recursivelyTraverse(node:AComponent):void {
			if(node.length > 0){
				createAndRenderButtons(node); //Start over
			}
		}
		//////////////////////////////////////////////////////////////7
		private function listenButton(e:ShowEvent):void {
			dispatchEvent(e.clone());
		}

	}
}