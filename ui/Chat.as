package src.as3.ui
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Vitor Rozsa
	 */
	public class Chat extends MovieClip
	{
		/*  __________________________
		 * |                          |
		 * |                          |
		 * |                          |
		 * |                          |
		 * |__________________________|
		 *  __________________________
		 * |>_________________________|
		 * 
		 * Internal commands:
			 * /clear - clear the text box
			 * /plus - increase the text box width and height.
			 * /plus w - increase the text box width.
			 * /plus h - increase the text box height.
			 * /minus - decrease the text box width and height.
			 * /minus w - decrease the text box width.
			 * /minus h - decrease the text box height.
		 * 
		 * Custom commands:
			 * Register a command (as string) and the corresponding callback. The callback will
			 * receive the whole input line to process. So, the callback must fit the following
			 * template: function foo(text:String) : whatever_return_type.
			 * Use the function "registerCallback(command:String, callback:Function, displayInChat:Boolean=false)" to add
			 * a custom command.
		 */
		
		// Constants.
		private const widthDefault:int = 300;
		private const heightDefault:int = 100;
		private const colorDefault:uint = 0x006699;
		private const textColorDefault:uint = 0xffffff;
		private const alphaDefault:Number = 0.5;
		private const textSizeDefault:int = 14;
		private const inputHeightBase:int = 18;
		
		private const boxPosX:int = 0;
		private const boxPosY:int = 0;
		private const inputPosX:int = 0;
		private const boxesOffset:int = 2;
		
		// Commands.
		private const clearCommand:String = "/clear";
		private const plusCommand:String = "/plus";
		private const plusWidthCommand:String = plusCommand + " w";
		private const plusHeightCommand:String = plusCommand + " h";
		private const minusCommand:String = "/minus";
		private const minusWidthCommand:String = minusCommand + " w";
		private const minusHeightCommand:String = minusCommand + " h";
		private const plusMinusSize:int = 8;
		
		// Variables.
		private var widthInitial:int;
		private var heightInitial:int;
		private var _width:int;
		private var _height:int;
		private var _color:uint;
		private var _textColor:uint;
		
		private var boxTxt:TextField;
		private var boxBg:Shape;
		private var boxHeight:int;
		
		private var inputTxt:TextField;
		private var inputBg:Shape;
		private var inputPosY:int;
		private var inputHeight:int;
		
		private var format:TextFormat;
		private var lastUserInput:String;
		
		private var userCommands:Array;
		
		public function Chat(width:int=widthDefault, height:int=heightDefault, color:uint=colorDefault, textColor:uint=textColorDefault)
		{
			_width = width;
			widthInitial = _width;
			_height = height;
			heightInitial = _height;
			_color = color;
			_textColor = textColor;
			
			boxBg = new Shape();
			inputBg = new Shape();
			boxTxt = new TextField();
			inputTxt = new TextField();
			format = new TextFormat();
			lastUserInput = "";
			
			userCommands = new Array();
			
			drawSelf();
			
			addChild(boxBg);
			addChild(inputBg);
			addChild(boxTxt);
			addChild(inputTxt);
			
			this.enable = true;
		}
		
//##################################################################################################
// Private functions.
//##################################################################################################
		
		private function drawSelf() : void
		{
			// 12 is a magic number. Each increment (14, 16, 18) increase more less 2 pixels in the
			// character size.
			inputHeight = inputHeightBase + (textSizeDefault - 12);
			boxHeight = _height - inputHeight - boxesOffset;
			inputPosY = boxHeight + boxesOffset;
			
			drawShapes();
			drawText();
		}
		
		private function drawShapes() : void
		{
			// Draw box background.
			boxBg.x = boxPosX;
			boxBg.y = boxPosY;
			boxBg.graphics.clear();
			boxBg.graphics.beginFill(_color, alphaDefault);
			boxBg.graphics.drawRect(0, 0, _width, boxHeight);
			boxBg.graphics.endFill();
			
			// Draw input background.
			inputBg.x = inputPosX;
			inputBg.y = inputPosY;
			inputBg.graphics.clear();
			inputBg.graphics.beginFill(_color, alphaDefault);
			inputBg.graphics.drawRect(0, 0, _width, inputHeight);
			inputBg.graphics.endFill();
		}
		
		private function drawText() : void
		{
			// Setup text format.
			format.size = textSizeDefault;
			
			// Create display text box.
			boxTxt.x = boxBg.x;
			boxTxt.y = boxBg.y;
			boxTxt.width = boxBg.width;
			boxTxt.height = boxBg.height;
			boxTxt.textColor = _textColor;
			boxTxt.defaultTextFormat = format;
			//boxTxt.wordWrap = true;
			//boxTxt.text = "";
			
			// Create input box.
			inputTxt.x = inputBg.x;
			inputTxt.y = inputBg.y;
			inputTxt.width = inputBg.width;
			inputTxt.height = inputBg.height;
			inputTxt.textColor = _textColor;
			inputTxt.type = TextFieldType.INPUT;
			inputTxt.defaultTextFormat = format;
			inputTxt.multiline = false;
			// "- 1" to avoid scrolling the input field.
			inputTxt.maxChars = inputTxt.width / (int(format.size) / 2) - 1;
		}
		
		private function handleTextInput(e:KeyboardEvent) : void
		{
			if (e.keyCode == Keyboard.UP)
			{
				inputTxt.text = lastUserInput;
				return;
			}
			else if (e.keyCode == Keyboard.DOWN)
			{
				if (inputTxt.length > 0)
				{
					lastUserInput = inputTxt.text
				}
				
				inputTxt.text = "";
				return;
			}
			
			if (e.keyCode != Keyboard.ENTER)
			{
				return;
			}
			
			if ( (processInternalCommand(inputTxt.text) != true) &&
					(processUserCommand(inputTxt.text) != true) )
			{
				addText(inputTxt.text);
			}
			
			lastUserInput = inputTxt.text;
			inputTxt.text = "";
		}
		
		/**
		 * Check if there is one or more commands in the string and process if true.
		 * @param	text
		 * @return true if processed something; false otherwise.
		 */
		private function processInternalCommand(text:String) : Boolean
		{
			var found:Boolean = false;
			
			if (text.search(clearCommand) >= 0)
			{
				found = true;
				boxTxt.text = "";
			}
			
			if (text.search(plusCommand) >= 0)
			{
				found = true;
				
				if (text.search(plusWidthCommand) >= 0)
				{
					_width += plusMinusSize;
				}
				else if (text.search(plusHeightCommand) >= 0)
				{
					_height += plusMinusSize;
				}
				else
				{
					_width += plusMinusSize;
					_height += plusMinusSize;
				}
				drawSelf();
			}
			/**
			 * Can't minus the chat less than the starter size.
			 */
			else if (text.search(minusCommand) >= 0)
			{
				found = true;
				
				if (text.search(minusWidthCommand) >= 0)
				{
					if ( (_width - plusMinusSize) >= widthInitial)
					{
						_width -= plusMinusSize;
					}
				}
				else if (text.search(minusHeightCommand) >= 0)
				{
					if ( (_height - plusMinusSize) >= heightInitial)
					{
						_height -= plusMinusSize;
					}
				}
				else
				{
					if ( (_width - plusMinusSize) >= widthInitial)
					{
						_width -= plusMinusSize;
					}
					
					if ( (_height - plusMinusSize) >= heightInitial)
					{
						_height -= plusMinusSize;
					}
				}
				drawSelf();
			}
			
			return found;
		}
		
		private function processUserCommand(text:String) : Boolean
		{
			var found:Boolean = false;
			var display:Boolean = false;
			
			for (var i in userCommands)
			{
				var cmd:String = userCommands[i][0];
				var callback:Function = userCommands[i][1];
				var displayInChat:Boolean = userCommands[i][2];
				
				if (text.search(cmd) >= 0)
				{
					callback(text);
					found = true;
					display = displayInChat;
				}
			}
			
			if (display)
			{
				addText(inputTxt.text);
			}
			
			return found;
		}
		
//##################################################################################################
// Public functions.
//##################################################################################################
		public function set color(value:uint) : void
		{
			_color = value;
			drawShapes();
		}
		
		public function set textColor(value:uint) : void
		{
			_textColor = value;
			drawText();
		}
		
		public function addText(value:String, userInput:Boolean=true) : void
		{
			boxTxt.text = boxTxt.text.concat( (boxTxt.length > 0? "\r" : "") + value);
			boxTxt.scrollV = boxTxt.text.split('\r').length;
			if (userInput)
			{
				dispatchEvent(new ChatInputEvent(value));
			}
		}
		
		/**
		 * Enable text insertion.
		 * @param value - true: enable text insetion (default); false: disable text insertion.
		 */
		public function set enable(value:Boolean) : void
		{
			if (value)
			{
				inputTxt.addEventListener(KeyboardEvent.KEY_DOWN, handleTextInput, false, 0, true);
			}
			else
			{
				inputTxt.removeEventListener(KeyboardEvent.KEY_DOWN, handleTextInput); 
			}
		}
		
		/**
		 * Custom commands:
			 * Register a command (as string) and the corresponding callback. The callback will
			 * receive the whole input line to process. So, the callback must fit the following
			 * template: function foo(text:String) : whatever_return_type.
			 * Use the function "registerCallback(command:String, callback:Function, displayInChat:Boolean=false)" to add
			 * a custom command.
		 * @param command String that will be searched to trigger the callback.
		 * @param callback The function that will be called.
		 * @param displayInChat If the command line will be saved in the chat.
		*/ 
		public function registerCallback(command:String, callback:Function, displayInChat:Boolean=false) : void
		{
			userCommands.push([command, callback, displayInChat]);
		}
	}	
}