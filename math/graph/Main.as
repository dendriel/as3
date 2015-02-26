package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Vitor Rozsa
	 */
	public class Main extends Sprite 
	{
		var SPFAlgo:SPF;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			trace("hello!");
			// entry point
			
			SPFAlgo = new SPF();
			var graph01:Array = generateGraph01();
			
			SPFAlgo.loadGraph(graph01);
			//SPFAlgo.dumpGraph();
			
			//SPFAlgo.findSPF(0, 3);
			//SPFAlgo.findSPF(0, 5);
			var shortestPath:Array = SPFAlgo.findSPF(0, 4);
			
			
			trace("Shortest path: ");
			for each (var node:SPFNode in shortestPath)
			{
				trace("Node: " + node.uid);
			}
			
			trace("\nShortest path: ");		
			var node:SPFNode;
			while ( (node = shortestPath.pop()) )
			{
				trace("Node: " + node.uid);
			}
		}
		
		private function generateGraph01() : Array
		{
			const number_of_nodes:int = 6;
			var graph:Array = new Array(number_of_nodes);
			
			// Generate nodes.
			graph[0] = new SPFNode(0);
			graph[1] = new SPFNode(1);
			graph[2] = new SPFNode(2);
			graph[3] = new SPFNode(3);
			graph[4] = new SPFNode(4);
			graph[5] = new SPFNode(5);
			
			var A:SPFNode = graph[0];
			var B:SPFNode = graph[1];
			var C:SPFNode = graph[2];
			var D:SPFNode = graph[3];
			var E:SPFNode = graph[4];
			var F:SPFNode = graph[5];
			
			
			// Weight nodes.
			A.weight = 1;
			B.weight = 1;
			C.weight = 2;
			D.weight = 5;
			E.weight = 1;
			F.weight = 2;
			
			// Connect everyone.
			A.neighborList.push(B);
			A.neighborList.push(C);
			A.neighborList.push(D);
			
			B.neighborList.push(A);
			B.neighborList.push(D);
			B.neighborList.push(F);
			
			C.neighborList.push(A);
			C.neighborList.push(D);
			C.neighborList.push(F);
			
			D.neighborList.push(A);
			D.neighborList.push(B);
			D.neighborList.push(C);
			D.neighborList.push(E);
			
			E.neighborList.push(D);
			
			F.neighborList.push(B);
			F.neighborList.push(C);
			
			return graph;
		}
		
	}
	
}