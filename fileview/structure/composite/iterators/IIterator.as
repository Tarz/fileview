/**
*Part of iterator pattern
*Tarvo Tiivits
*07.11.2015
**/

package fileview.structure.composite.iterators {

	import fileview.structure.composite.AComponent;

	public interface IIterator {
		function next():AComponent;
		function hasNext(): Boolean;
		function get prevIndex():uint;
	}
}