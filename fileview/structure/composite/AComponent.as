/**
*COMPOSITE PATTERN, ABSTRACT
*Tarvo Tiivits
*07.11.2015
*/

package fileview.structure.composite{

	import fileview.structure.composite.iterators.IIterator;
	
	public class AComponent{

		protected var _parent:AComponent = null;
		protected var _name:String = "";
		protected var _index:uint = 0;
		protected var _depth:uint = 0;
		protected var _visible:Boolean = false;

		public function AComponent() {}
		
		public function getChild(index:uint):AComponent {
			return null;
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(name:String):void {
			_name = name;
		}

		public function get parent():AComponent {
			return _parent;
		}

		public function set parent(parent:AComponent) {
			_parent = parent;
		}

		public function set visible(visible:Boolean):void {
			_visible = visible;
		}

		public function get visible():Boolean {
			return _visible;
		}

		public function get depth():uint {
			return _depth;
		}

		public function set depth(depth:uint):void {
			_depth = depth;
		}
		
		public function set index(index:uint):void {
			_index = index;
		}
		
		public function get index():uint {
			return _index;
		}
		//Override
		public function get length():uint {
			return 0;
		}
		public function iterator():IIterator { return null; }
		public function prepareChildren(path:Array):void {}
		public function traverse():void {}
		public function get type():uint { return null;}
		public function sortTypes():void {}
		public function precountFilesAndFolders():void {}
		internal function repairIndexies():void {}
	} 
}