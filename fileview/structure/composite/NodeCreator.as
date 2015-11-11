/**
*Helper, separated from FileNode instance
*Path to Tree logic here
*Tarvo Tiivits
*07.11.2015
**/

package fileview.structure.composite {

	import fileview.structure.composite.AComponent;
	import fileview.structure.composite.FileNode;
	import fileview.structure.composite.FolderNode;

	public class NodeCreator {

		private var _folderNode:FolderNode;

		public function NodeCreator(folderNode:FolderNode, path:Array){
			
			_folderNode = folderNode;

			var pathComponent:String = path[_folderNode.depth];
			var componentIndex = componentIndexInArray(pathComponent);
			createAndAddChildHereOrGoDeeper(componentIndex,pathComponent, path);
		}

		private function componentIndexInArray(pathComponent:String):int {
			var iterator = _folderNode.iterator();
			while(iterator.hasNext()){
				var next = iterator.next();
				if(next.name == pathComponent) {
					return iterator.prevIndex; //One step back;
				}
			}
			return -1;
		}

		private function createAndAddChildHereOrGoDeeper(componentIndex, pathComponent, path):void {
			if(componentIndex > -1) {
				_folderNode.getChildren()[componentIndex].prepareChildren(path);
			}else{
				var isLeaf = isNewChildIsLeaf(path);
				var newChild = createNewChild(pathComponent, isLeaf);
				_folderNode.addChild(newChild);
				newChild.prepareChildren(path); 
			}
		}

		private function isNewChildIsLeaf(path:Array):Boolean {
			return path.length - 1 == _folderNode.depth;
		}

		private function createNewChild(pathComponent, isLeaf): AComponent {
			var node:AComponent = isLeaf ? new FileNode() : new FolderNode();
			node.name = pathComponent;
			node.parent = _folderNode;
			node.depth = _folderNode.depth + 1;
			return node;
		}
	}
}
