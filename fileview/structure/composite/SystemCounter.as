package fileview.structure.composite {

	public class SystemCounter {
	
		static public var FOLDERCOUNT:uint = 0-1; //Don't count the ROOT
		static public var FILECOUNT:uint = 0;
		static public var VISIBLE_FOLDERCOUNT:uint = 0; //Don't count the ROOT
		static public var VISIBLE_FILECOUNT:uint = 0;

		static public function reset(): void{
			SystemCounter.VISIBLE_FILECOUNT = 0;
			SystemCounter.VISIBLE_FOLDERCOUNT = 0;
		}

	}
}