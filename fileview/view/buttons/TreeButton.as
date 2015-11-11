/**
*TARVO TIIVITS
*07-11.11.2015
*/

package fileview.view.buttons {
	
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;
	import fileview.structure.composite.AComponent;
	import fileview.view.events.*;
	
	public class TreeButton extends Sprite {
		
		public var angle:Number; //Memorize angle for renderer
		private var _node:AComponent; //Structure node
		private var _buttonContainer:MovieClip;
		private var _step:int = 0; //For animation
		private var _childVisible:Boolean = false; //Memorize state for structure node
		private var _clickedForThis:Boolean = false; //Marker for renderer
		private var _isLeaf:Boolean = false;
		
		public function TreeButton(node:AComponent){
			_node = node;
			createElements();
			buttonMode = true;
		}
		
		private function createElements():void{
			prepareButton();
		}

		private function prepareButton():void
		{
			var formattedName:String = formatText(); //Add spaces according to node depth

			_buttonContainer = new MenuButton();
			_buttonContainer.namefield.blendMode = BlendMode.LAYER;
			_buttonContainer.namefield.alpha = .15;
			_buttonContainer.namefield.text = formattedName;
			_buttonContainer.namefieldStrong.text = formattedName;
			_buttonContainer.plusminusBack.blendMode = BlendMode.LAYER;
			_buttonContainer.plusminusBack.alpha = .15;
			_buttonContainer.namefieldStrong.mouseEnabled = false;
			_buttonContainer.namefield.mouseEnabled = false;
			_buttonContainer.plusminusBack.mouseEnabled = false;
			_buttonContainer.plusminus.mouseEnabled = false;
			
			_isLeaf = isLeafOrComposite();
			updateSign();
			addChild(_buttonContainer);
		}

		//Add "-"  before string according to node depth in structure tree
		private function formatText():String {
			var string:String = "";
			for(var i:uint = 1; i<_node.depth;i++){
				string += "-";
			}
			return countTextLengthAndTakeSubString(string + _node.name); //If string is too long
		}

		//If name is too long..
		private function countTextLengthAndTakeSubString(str:String):String{
			if(str.length > 30){
				var subStr = str.substr(0, 30);
				str = subStr + ".."
			}
			return str;
		}


		private function isLeafOrComposite():Boolean {
			if(_node.length > 0){
				addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
				return false;
			}else{												//If file, remove +/- sign
				_buttonContainer.removeChild(_buttonContainer.plusminus);
				_buttonContainer.removeChild(_buttonContainer.plusminusBack);
				buttonMode = false;
				return true;
			}
		}

		private function mouseDown(e:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_UP, mouseClick);
			addEventListener(MouseEvent.RELEASE_OUTSIDE, releaseOutside);
		}

		private function mouseClick(e:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_UP, mouseClick);
			removeEventListener(MouseEvent.RELEASE_OUTSIDE, releaseOutside);
			if(_buttonContainer.plusminus.text == "+")
			{
				_buttonContainer.plusminus.text = "-";
				_buttonContainer.plusminusBack.text = "-";
				_childVisible = true;
			}else{
				_buttonContainer.plusminus.text = "+";
				_buttonContainer.plusminusBack.text = "+";
				_childVisible = false;
			}
			var bf:BlurFilter = new BlurFilter(1, 1, 5);
			this.filters = [bf];
			_clickedForThis = true;
			addEventListener(Event.ENTER_FRAME, blur);
		}

		//Effect
		private function blur(e:Event):void {
			_step+=8;
			var bf:BlurFilter = new BlurFilter(_step/3, _step, 5);
			this.filters = [bf];
			if(_step >= 70){
				_step = 0;
				this.filters = [];
				dispatchEvent(new ShowEvent(ShowEvent.SHOW_NODE_CHILDREN, _node, _childVisible));
				removeEventListener(Event.ENTER_FRAME, blur);
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			}
		}
		
		private function releaseOutside(e:MouseEvent):void {
			removeEventListener(MouseEvent.RELEASE_OUTSIDE, releaseOutside);
			removeEventListener(MouseEvent.MOUSE_UP, mouseClick);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		//Override positions. Give for ButtonRenderer MovieClip properties not this sprite properties.
		override public function get x():Number {
			return _buttonContainer.x;
		}
		
		override public function set x(number:Number):void {
			_buttonContainer.x = number;
		}
		
		override public function get y():Number {
			return _buttonContainer.y;
		}
		
		override public function set y(number:Number):void {
			_buttonContainer.y = number;
		}
		
		override public function get z():Number {
			return _buttonContainer.z;
		}
		
		override public function set z(number:Number):void {
		 	_buttonContainer.z = number;
		}

		public function get node():AComponent {
			return _node;
		}

		public function get clickedForMe():Boolean {
			return _clickedForThis;
		}

		//ButtonRenderer updates +/- signs when building new array for displaying buttons
		public function updateSign():void {
			if(!_isLeaf)
			{
				if(_node.getChild(0).visible){
					_buttonContainer.plusminus.text = "-";
					_buttonContainer.plusminusBack.text = "-";
				}else{
					_buttonContainer.plusminus.text = "+";
					_buttonContainer.plusminusBack.text = "+";
				}
			}
		}
		
		//After using _clikedForThis property, ButtonRenderer sets it false
		public function restoreClickedForMe() {
			_clickedForThis = false;
		}
	}
}