package  
{
	/**
	 * ...
	 * @author Vitor Rozsa
	 */
	public class SPFNodeLink 
	{
		private var _weightTo:int;
		private var _node:SPFNode;
		private var _nodeFrom:SPFNode;
		
		public function SPFNodeLink(node:SPFNode, nodeFrom:SPFNode, weightTo:int) 
		{
			_node = node;
			_nodeFrom = nodeFrom;
			_weightTo = weightTo;
		}
		
		public function get weightTo():int 
		{
			return _weightTo;
		}
		
		public function set weightTo(value:int):void 
		{
			_weightTo = value;
		}
		
		public function get nodeFrom():SPFNode 
		{
			return _nodeFrom;
		}
		
		public function set nodeFrom(value:SPFNode):void 
		{
			_nodeFrom = value;
		}
		
		public function get node():SPFNode 
		{
			return _node;
		}
		
		public function set node(value:SPFNode):void 
		{
			_node = value;
		}
		
	}

}