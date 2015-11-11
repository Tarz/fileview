/**
*Interface of iterator pattern
*Tarvo Tiivits
*07.11.2015
*/
package fileview.structure.composite.iterators {

	import fileview.structure.composite.AComponent;

	public class Iterator implements IIterator {

		private var _index:uint;
		private var _array:Array;

		public function Iterator(array:Array) {

			_array = array;
			_index = 0;
		}

		public function hasNext():Boolean {
			return _index < _array.length;
		}

		public function next():AComponent {
			return _array[_index++];
		}

		public function get prevIndex():uint {
			return Math.max(_index-1,0);
		} 
	}
}