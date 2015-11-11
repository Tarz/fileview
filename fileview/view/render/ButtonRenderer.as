/**
*Tarvo Tiivits
*08-11.11.2015
*/

package fileview.view.render {
	
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.*;
	import flash.geom.Point;
	import flash.filters.BlurFilter;
	import fileview.structure.composite.SystemCounter;
	import fileview.structure.composite.SystemEnum;
	import fileview.view.buttons.TreeButton;
	import fileview.view.events.VisibilityChangedEvent;

	public class ButtonRenderer extends Sprite {
		
		private var _container:Sprite;
		private var _buttonArray:Array;
		private var _displayArray:Array;
		
		private var dtr:Number = Math.PI/180;
		private var minZ:Number = -200;
		private var buttonHeight:Number = 22;
		private var startAngle:Number = -Math.PI/2; // * dtr;
		private var lastlyClickedButton:TreeButton = null;
		private var lastlyClickedAngle:Number = 0;
		private var count:uint = 0;
		private var radius:Number = 0;
		
		//Worldcenter
		private var globalX:uint = 400; //CenterX
		private var globalY:uint = 300; //CenterY
		private var globalZ:int = 0;
		
		//Phys
		private var maxVelocity:Number = 10;
		private var velocity:Number = 0;
		private var mass:Number = Math.max(count * 2, 30); //Total mass of Carousel
		private var speed:Number = 0;
		private var friction:Number = .993;
		
		//Mouse
		private var endMouseY:Number = 0;
		private var isMouseDown:Boolean = false;

		public function ButtonRenderer() {
			_container = new Sprite();
			addChild(_container);
		}

		public function update(buttonArray:Array = null):void {
			_buttonArray = _buttonArray || buttonArray;
			prepareProperties();
			makeButtonsGeometrical();
			findAndSetAngleDelta();
			if(!hasEventListener(Event.ENTER_FRAME)){
				addEventListener(Event.ENTER_FRAME, enterFramehandler); //start animation
			}		
		}

		private function prepareProperties():void {
			unloadCurrentView();
			count = findVisibleButtons();
			radius = Math.max(30,(count * buttonHeight)/2); //r = d/2
			globalZ = minZ + radius; //Z according to radius
			mass = Math.max(count * 2, 30);
		}

		private function unloadCurrentView():void {
			if(!_displayArray) return;
			lastlyClickedButton = memorizeLastlyClickedButton();
			lastlyClickedAngle = lastlyClickedButton.angle;
			
			var length = _displayArray.length;
			for(var i:uint = 0; i<length; i++){
				_container.removeChild(_displayArray[i]);
			}
			_displayArray = null;
		}

		private function findVisibleButtons():uint {
			var c:uint = 0;
			var button:TreeButton;
			var length = _buttonArray.length;
			_displayArray = new Array();
			
			SystemCounter.reset();
			
			for(var i:uint = 0; i<length; i++){
				
				button = _buttonArray[i];
				button.updateSign(); //Set button +/i sign according to it's visibility
				
				//Count visible buttons
				if(button.node.visible){
					if(button.node.type == SystemEnum.FOLDER){
						SystemCounter.VISIBLE_FOLDERCOUNT++;
					}else{
						SystemCounter.VISIBLE_FILECOUNT++;
					}
					_displayArray.push(button);
					c++;
				}
			}
			//Dispatch event to View
			dispatchEvent(new VisibilityChangedEvent(VisibilityChangedEvent.FILESYSTEM_VISIBILITY_CHANGED));
			return c;
		}

		//For angle calculations
		private function memorizeLastlyClickedButton():TreeButton {
			var button:TreeButton = findLastlyClickedButton()
			return button;
		}

		private function findLastlyClickedButton():TreeButton {
			var length = _displayArray.length;
			for(var i:uint = 0; i<length; i++){
				if(_displayArray[i].clickedForMe){
					_displayArray[i].restoreClickedForMe();
					return _displayArray[i];
				}
			}
			return null;
		}
		
		//Add x, y, z and angle according to buttons count
		private function makeButtonsGeometrical(): void{
			
			for (var i:uint = 0; i<count; i++){
				var button = _displayArray[i];
				var angle = startAngle + ((360/count) * i) * dtr;
				var cos = Math.cos(angle);
				var sin = Math.sin(angle);
				button.x = globalX;
				button.y = globalY +  cos  * radius;
				button.z = globalZ +  sin * radius;
				button.angle = angle; //Dynamic property
				_container.addChild(button);
			}
			sortDepthsAndAddBlur();
		}

		//Set carousel angle according to lastly clicked button 
		private function findAndSetAngleDelta():void {
			if(!lastlyClickedButton) return;
			var lastlyClickedAngle = lastlyClickedAngle;
			var buttonNow = _displayArray[_displayArray.indexOf(lastlyClickedButton)];
			var angleDelta = (-Math.PI/2) - buttonNow.angle;
		    render(angleDelta);
		    sortDepthsAndAddBlur();
		    lastlyClickedButton = null;
		    lastlyClickedAngle = 0;
		}

		//Calculate in every frame
		private function enterFramehandler(e:Event):void {
			//If scrollin
			if(isMouseDown){
				var newY = mouseY;
				var dist = mouseY - endMouseY;
				velocity = Math.max(-maxVelocity, Math.min(maxVelocity, velocity + (dist * .1)));
				endMouseY = newY;
			}
			
			velocity *= friction;
			speed = velocity * (radius/mass/count);
			speed *= dtr; //to radians
			
			render(speed);
			sortDepthsAndAddBlur();
		}

		//render new position
		private function render(speed):void {
			
			for(var i = 0;i < count; i++){
				var button = _displayArray[i];
				var angle = button.angle + (speed);
				button.angle = angle;
				button.y = globalY + Math.cos(angle) * radius;
				button.z = globalZ + Math.sin(angle) * radius;
			}	
		}
		
		private function sortDepthsAndAddBlur():void {
			_displayArray.sortOn("z", Array.NUMERIC | Array.DESCENDING);
			for(var i = 0; i< count; i++){
				var button = _displayArray[i];
				button.filters  = [];
				var inFov = testFieldOfView(button);
				if(inFov) {
					_container.setChildIndex(button, i);
					addBlur(button, i);
					button.visible = true;
				}else{
					button.visible = false;
				}
			}
		}

		//When button is far away it hazy
		private function addBlur(button, i):void {
			button.filters = [new BlurFilter((count-i)/5,(count-i)/5,1)];
		}

		//Some kind of optimization
		private function testFieldOfView(button:TreeButton):Boolean {
			if(button.y < -300 && button.z<-globalZ - radius) return false;
			if(button.y >  600 && button.z< globalZ - radius) return false;
			if(button.z > 10000) return false;
			return true;
		}

		//Scroll
		private function stageMouseDown(e:MouseEvent):void{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
		    stage.addEventListener(MouseEvent.RELEASE_OUTSIDE, stageMouseUp);
			isMouseDown = true;
			velocity = 0;
			endMouseY = mouseY;
		}
		
		private function stageMouseUp(e:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
			 stage.removeEventListener(MouseEvent.RELEASE_OUTSIDE, stageMouseUp);
			isMouseDown = false;
		}

		//Stop for new calculations
		public function stop():void {
			removeEventListener(Event.ENTER_FRAME, enterFramehandler); //stop animation	
		}

		public function get container():Sprite {
			return _container;
		}

		//Only after instatiation  
		public function addStageMouseListener():void {
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);	
		}
		
		//Add mouseListener to stage for scrolling
		private function addedToStage(e:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseDown);  //For scrolling
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

	}
}