package  src.as3.math.graph
{
	/**
	 * ...
	 * @author Vitor Rozsa
	 */
	public class SPFNode
	{
		private var _uid:int;
		private var _weight:Number;
		private var _neighborList:Vector.<SPFNode>;
		
		public function SPFNode(uid:int) 
		{
			_uid = uid;
			_neighborList = new Vector.<SPFNode>;
		}
		
		public function get neighborList():Vector.<SPFNode> 
		{
			return _neighborList;
		}
		
		public function set neighborList(value:Vector.<SPFNode>):void 
		{
			_neighborList = value;
		}
		
		public function get weight():Number 
		{
			return _weight;
		}
		
		public function set weight(value:Number):void 
		{
			_weight = value;
		}
		
		public function get uid():int 
		{
			return _uid;
		}
	}

}