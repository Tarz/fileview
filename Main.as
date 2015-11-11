/**
*MAIN class Client
*/

package {
 
 import flash.display.Sprite;
 import fileview.loaders.JsonLoader;
 import fileview.loaders.events.JsonLoadedEvent;
 import fileview.structure.StructureBuilder;
 import fileview.structure.events.*;
 import fileview.view.View;
 import fileview.view.events.*;
 
 	public class Main extends Sprite {
		
		private var _structureBuilder:StructureBuilder; 
		private var _view:View;

		public function Main() {
			var filePath = "filelist.json"
			startLoadingJSON(filePath);
		}

		//JsonLoader
		private function startLoadingJSON(filepath:String): void {
			var jsonLoader:JsonLoader = new JsonLoader();
			jsonLoader.addEventListener(JsonLoadedEvent.JSON_IS_LOADED, collectJSONData);
			jsonLoader.startLoading(filepath);
		}

		private function collectJSONData(e:JsonLoadedEvent):void {
			var jsonData:String = e.data;
			destroyJSONLoader(e);
			createStructureBuilder(jsonData);
		}

		private function destroyJSONLoader(e:JsonLoadedEvent):void {
			e.currentTarget.removeEventListener(JsonLoadedEvent.JSON_IS_LOADED, collectJSONData);
			e.currentTarget.destroy();
		}

		//StructureBuilder
		private function createStructureBuilder(jsonData:String):void {
			_structureBuilder = new StructureBuilder();
			_structureBuilder.addEventListener(StructureUpdatedEvent.STRUCTURE_UPDATED, structureIsUpdated);
			_structureBuilder.init(jsonData);
		}

		private function structureIsUpdated(e:StructureUpdatedEvent):void {
				_view = _view || new View();
				_view.update(e.structure);
				_structureBuilder.removeEventListener(StructureUpdatedEvent.STRUCTURE_UPDATED, structureIsUpdated);
				addChild(_view);
				_view.addEventListener(ShowEvent.SHOW_NODE_CHILDREN, updateStructure); 
		}

		private function updateStructure(e:ShowEvent):void {
			_view.removeEventListener(ShowEvent.SHOW_NODE_CHILDREN, updateStructure); 
			_structureBuilder.addEventListener(StructureUpdatedEvent.STRUCTURE_UPDATED, structureIsUpdated);
			_structureBuilder.setNodeChildrenVisible(e.node, e.visible);
		}

	}
}