/**
*COMPOSITE PATTERN, COMPOSITE NODE
*Tarvo Tiivits
*07.11.2015
*/
package fileview.structure.composite {

	import fileview.structure.composite.NodeCreator;
	import fileview.structure.composite.iterators.*;

	public class FolderNode extends AComponent {

		private var _children:Array;
		
		public function FolderNode() {
			super();
			_children = new Array();
		}

		override public function getChild(index:uint):AComponent {
			return _children[index];
		}
		
		override public function prepareChildren(path:Array):void {
			var nodeCreator:NodeCreator = new NodeCreator(this, path);
		}
		
		internal function addChild(node:AComponent):void{
			node.index = _children.length;
			_children.push(node);
		}
		
		internal function getChildren():Array {
			return _children;
		}
		
		override public function get length():uint {
			return _children.length;
		}
		
		override public function iterator():IIterator {
			return new Iterator(_children);
		}

		//Push files to the end	
		override public function sortTypes():void {
			
			for(var i:uint = 0; i < _children.length; i++) {
				
				var node:AComponent = _children[i];
				if(node.type == SystemEnum.FILE) {
					var splicedNode = _children.splice(i, 1);
					_children.push(node);
					node.sortTypes();
				}
			}
			repairIndexies();
		}

		override internal function repairIndexies():void {
			for(var i:uint = 0; i< _children.length; i++){
				_children[i].index = i;
				_children[i].repairIndexies();
			}
		}

		override public function precountFilesAndFolders():void {
			
			SystemCounter.FOLDERCOUNT++;
			for(var i:uint; i<_children.length; i++){
				_children[i].precountFilesAndFolders();
			}
		}

		override public function set visible(visible:Boolean):void {
			super.visible = visible;
			if(!visible && length > 0){
				for(var i:uint = 0; i<length; i++){
					_children[i].visible = visible;
				}
			}
		}

		
		override public function traverse():void {
			var string = " ";
			for(var i:uint = 0; i< depth; i++) {
				string += "  ";
			}
			
			trace(string + name, " depth:" + depth, "index: " + index);
			
			for(var j:uint = 0; j < _children.length; j++){
				_children[j].traverse();
			} 
		}
	} 
}