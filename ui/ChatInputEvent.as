package src.as3.ui
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vitor Rozsa
	 */
	public class ChatInputEvent extends Event
	{
		public static const EVT_CHAT_INPUT:String = "chat input";
		
		// Event data.
		private var _input:String;
		
		public function ChatInputEvent(input:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(ChatInputEvent.EVT_CHAT_INPUT, bubbles, cancelable);
			_input = input;
		}

		public override function clone() : Event
		{
			return new ChatInputEvent(_input, bubbles, cancelable);
		}
		
		/**
		 * @return The user input.
		 */
		public function get input():String 
		{
			return _input;
		}
	}
}
	