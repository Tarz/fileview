/**
*Main class for structure
*Tarvo Tiivits
*07.11.2015
*/

package fileview.structure{

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import fileview.structure.composite.*;
	import fileview.structure.events.*;


	public class StructureBuilder extends EventDispatcher {

		private var _structure:AComponent;
		
		public function StructureBuilder() {}

		public function init(jsonString:String):void {
			_structure = initStructure();
			var sortedArrayFromJSON:Array = parseJSON(jsonString).sort();
			createCompositeStructure(sortedArrayFromJSON, _structure);
			//_structure.traverse(); //trace all structure to output panel
			_structure.sortTypes(); //If files and folders are mixed in same folder, push files to the end
			setTreeFirstLevelToVisible(); 
			_structure.precountFilesAndFolders();
			dispatchEvent(new StructureUpdatedEvent(StructureUpdatedEvent.STRUCTURE_UPDATED, _structure));
		}

		private function initStructure():AComponent {
			var structure = new FolderNode();
			structure.visible = true;
			structure.name = "ROOT";
			return structure;
		}

		private function parseJSON(jsonString):Array {
			return JSON.parse(jsonString).filelist;
		}

		//Use Composite Pattern for data storage and path calculations
		private function createCompositeStructure(folderArray:Array, _structure):void {
			var length:uint = folderArray.length;
			for (var i:uint = 0; i < length; i++ ) {
				var splittedPathComponents:Array = folderArray[i].split("/");
				var splittedPathComponentsCheckLastSlash = checkAndCorrectSplittedPath(splittedPathComponents);
				_structure.prepareChildren(splittedPathComponentsCheckLastSlash);
			}
		}
		//Correct path array if last char is "/"
		private function checkAndCorrectSplittedPath(splittedPathComponents:Array):Array {
			if(splittedPathComponents[splittedPathComponents.length-1]==""){
				splittedPathComponents.pop();
			}
			return splittedPathComponents;
		}

		private function setTreeFirstLevelToVisible():void {
			var iterator = _structure.iterator();
			while(iterator.hasNext()){
				var node = iterator.next();
				node.visible = true;
			}
		}

		public function setNodeChildrenVisible(node:AComponent, visible:Boolean):void {
			var iterator = node.iterator();
			var nNode:AComponent;
			if(iterator != null){
				while(iterator.hasNext()){
					nNode = iterator.next();
					nNode.visible = visible;
				}
			}
			dispatchUpdated();
		}

		//Dispatch to client as structure is updated
		private function dispatchUpdated():void{
			dispatchEvent(new StructureUpdatedEvent(StructureUpdatedEvent.STRUCTURE_UPDATED, _structure));
		}

	}
}