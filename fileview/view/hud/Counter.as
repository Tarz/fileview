/**
*TARVO TIIVITS
*11.11.2015
*/

package fileview.view.hud {
	
	import flash.display.Sprite; 
	import flash.display.MovieClip;
	import flash.events.Event;
	import fileview.structure.composite.SystemCounter;
	

	public class Counter extends Sprite {

		private var counter:MovieClip = new FFCounter();
		private var easing:Number = .1;
		private var totalFoldersStartNum:Number = 0;
		private var totalFilesStartNum:Number = 0;
		private var openedFilesStartNum:Number = 0;
		private var openedFoldersStartNum:Number = 0;
		
		public function Counter() {
			counter.x = 630;
			counter.y = 20;
			counter.totalFolders.text = 0;
			counter.totalFiles.text = 0;
			counter.openedFolders.text = 0;
			counter.openedFiles.text = 0;
			addChild(counter);
			addEventListener(Event.ENTER_FRAME, countToTotalFolders);
			addEventListener(Event.ENTER_FRAME, countToTotalFiles);
		}

		public function update():void {
			addEventListener(Event.ENTER_FRAME, countToOpenedFolders);
			addEventListener(Event.ENTER_FRAME, countToOpenedFiles);
		}

		//Ease to total folders
		private function countToTotalFolders(e:Event):void {
			var d:Number = SystemCounter.FOLDERCOUNT - totalFoldersStartNum;
			var step:Number = d * easing;
			totalFoldersStartNum += step;
			if(d<1){
				counter.totalFolders.text = SystemCounter.FOLDERCOUNT;
				removeEventListener(Event.ENTER_FRAME, countToTotalFolders);
				return;
			}
			counter.totalFolders.text = Math.floor(totalFoldersStartNum);
		}
		//Ease to total files
		private function countToTotalFiles(e:Event):void {
			var d:Number = SystemCounter.FILECOUNT - totalFilesStartNum;
			var step:Number = d * easing;
			totalFilesStartNum += step;
			if(d<1){
				counter.totalFiles.text = SystemCounter.FILECOUNT;
				removeEventListener(Event.ENTER_FRAME, countToTotalFiles);
				return;
			}
			counter.totalFiles.text = Math.floor(totalFilesStartNum);
		}

		//Ease to current opened folders
		private function countToOpenedFolders(e:Event):void {
			var d:Number = SystemCounter.VISIBLE_FOLDERCOUNT - openedFoldersStartNum;
			var step:Number = d * easing;
			openedFoldersStartNum += step;
			if(d<1){
				counter.openedFolders.text = SystemCounter.VISIBLE_FOLDERCOUNT;
				openedFoldersStartNum =  SystemCounter.VISIBLE_FOLDERCOUNT;
				removeEventListener(Event.ENTER_FRAME, countToOpenedFolders);
				return;
			}
			counter.openedFolders.text = Math.floor(openedFoldersStartNum);
		}
		
		//Ease to current opened files
		private function countToOpenedFiles(e:Event):void {
			var d:Number = SystemCounter.VISIBLE_FILECOUNT - openedFilesStartNum;
			var step:Number = d * easing;
			openedFilesStartNum += step;
			if(d<1){
				counter.openedFiles.text = SystemCounter.VISIBLE_FILECOUNT;
				openedFilesStartNum =  SystemCounter.VISIBLE_FILECOUNT;
				removeEventListener(Event.ENTER_FRAME, countToOpenedFiles);
				return;
			}
			counter.openedFiles.text = Math.floor(openedFilesStartNum);
		}

	}
}