/**
*Main class for view/UI
*Tarvo Tiivits
*07-11.10.2015
*/

package fileview.view {

	import flash.display.Sprite;
	import fileview.structure.composite.AComponent;
	import fileview.view.buttons.ButtonOrganizer;
	import fileview.view.render.ButtonRenderer;
	import fileview.view.events.*;
	import fileview.view.hud.*;

	public class View extends Sprite 
	{
		private var _firstTime:Boolean = true;
		private var _mainContainer = new Sprite();
		private var _buttonArray:Array;
		private var _buttonOrganizer:ButtonOrganizer;
		private var _buttonRenderer:ButtonRenderer;
		private var _counter:Counter;
		
		public function View(){}

		public function update(structure:AComponent):void {
			if(!_firstTime){
				stopRenderer();
				updateView(structure);
				return;
			}
			_firstTime = false;
			_counter = new Counter();
			addChild(_counter);
			startToCreatButtons(structure);
			
			
		}

		private function startToCreatButtons(rootNode:AComponent):void {
			_buttonArray = new Array();
			_buttonOrganizer = new ButtonOrganizer(rootNode, _buttonArray); //_buttonOrganizer fills _buttonArray
			_buttonOrganizer.addEventListener(ShowEvent.SHOW_NODE_CHILDREN, treeButtonClicked);
			
			_buttonRenderer = new ButtonRenderer();
			_buttonRenderer.addEventListener(VisibilityChangedEvent.FILESYSTEM_VISIBILITY_CHANGED, updateCounters);
			_buttonRenderer.update(_buttonArray);
			_buttonRenderer.addStageMouseListener();
			addChild(_buttonRenderer); 
		}

		private function stopRenderer():void{
			_buttonRenderer.stop();
		}

		private function updateView(structure:AComponent):void{
			_buttonRenderer.update();
		}

		private function treeButtonClicked(e:ShowEvent):void {
			dispatchEvent(e.clone());
		}

		private function updateCounters(e:VisibilityChangedEvent):void {
			_counter.update();
		}
	}
}