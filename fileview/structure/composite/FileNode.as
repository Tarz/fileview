/**
*COMPOSITE PATTERN, LEAF NODE
*Tarvo Tiivits
*07.11.2015
*/
package fileview.structure.composite{

	public class FileNode extends AComponent {
		
		private var _type:uint;
		
		public function FileNode() {
			super();
		}

		override public function set name(name:String):void {
			super.name = name;
			setType(name);
		}
		
		//_type: File or Folder
		private function setType(name:String):void {
			var nameSplit = name.split(".");
			if(nameSplit.length > 1) {
				_type = SystemEnum.FILE; 
			}else{
				_type = SystemEnum.FOLDER;
				_visible = false;
			}
		}

		override public function get type():uint {
			return _type;
		}

		//Prevent default behavior when folder is leaf e.g always hidden
		override public function set visible(visible:Boolean):void {
			if(_type == SystemEnum.FOLDER){
				_visible = false;
			}else{
				super.visible = visible;
			}
		}

		override public function precountFilesAndFolders():void
		{
			if(_type == SystemEnum.FOLDER){
				SystemCounter.FOLDERCOUNT++;
			}else{
				SystemCounter.FILECOUNT++;
			}
		}
		/*internal function setInvisible():void {
			visible = false;
		}*/
		override public function traverse():void {
			var string = " ";
			for(var i:uint = 0; i< depth; i++) {
				string += "  ";
			}
			trace(string + name, " depth:" + depth, "index: " + index);
		}
	} 
}