package
{
	
	/**
	 * ...
	 * @author Vitor Rozsa
	 */
	public class SPF
	{
		private var _graph:Array;
		
		public function loadGraph(graph:Array) : void
		{
			_graph = graph;
		}
		
		public function dumpGraph() : void
		{
			if (_graph == null)
			{
				trace("First load a grap through loadGraph function.");
				return;
			}

			trace("Printing graph with " + _graph.length + " nodes.");
			
			for (var i:int = 0; i < _graph.length; i++)
			{
				var node:SPFNode = _graph[i];
				
				trace("Node " + node.uid + "");
				trace("Neighbors: ");
				
				for (var j:int = 0; j < node.neighborList.length; j++)
				{
					trace("\t[" + node.neighborList[j].uid + "] weight: " + node.neighborList[j].weight);
				}
			}
		}
		
		public function findSPF(from:int, to:int) : void
		{
			var graph:Array = _graph.concat();
			var openList:Vector.<SPFNodeLink> = new Vector.<SPFNodeLink>;
			var closedList:Vector.<SPFNodeLink> = new Vector.<SPFNodeLink>;
			
			var fromNodeLink:SPFNodeLink = new SPFNodeLink(graph[from], null, 0);
			var toNode:SPFNode = graph[to];
			
			trace("Find SPF from node " + fromNodeLink.node.uid + " to node " + toNode.uid);
			
			closedList.push(fromNodeLink);
			
			updateOpenList(fromNodeLink, openList, closedList);
			
			while ( openList.length > 0)
			{
				var leastCostLink:SPFNodeLink = getLeastCostLink(openList, closedList);
				trace("\n#############\nleastCostLink: " + leastCostLink.node.uid +
				" nodeFrom: " + ( (leastCostLink.nodeFrom != null)? leastCostLink.nodeFrom.uid : "null") + " weight: " + leastCostLink.weightTo);
				for each (var node:SPFNode in leastCostLink.node.neighborList)
				{
					trace("Node " + node.uid + " is inside node " + leastCostLink.node.uid);
				}
			
				// Add the element into the closed list.
				closedList.push(leastCostLink);
				
				updateOpenList(leastCostLink, openList, closedList);
			}
			
			trace("Closed list:");
			for each (var nodeLink:SPFNodeLink in closedList)
			{
				trace("node: " + nodeLink.node.uid +
				" nodeFrom: " + ( (nodeLink.nodeFrom != null)? nodeLink.nodeFrom.uid : "null") + " weight: " + nodeLink.weightTo);
			}
		}
		
		/**
		 * Find the least cost element from the open list, remove from it and add into the open list.
		 * @param	openList
		 * @param	closedList
		 * @return The least cost item found in the open list.
		 */
		private function getLeastCostLink(openList:Vector.<SPFNodeLink>, closedList:Vector.<SPFNodeLink>) : SPFNodeLink
		{
			var leastCostLink:SPFNodeLink;
			
			// Find the least cost element in the open list.
			for each (var link:SPFNodeLink in openList)
			{
				// First iteration.
				if (leastCostLink == null)
				{
					leastCostLink = link;
					continue;
				}
				
				// If weight to this link is less than the currently stored.
				if (link.weightTo < leastCostLink.weightTo)
				{
					leastCostLink = link;
				}
			}
			
			// Remove the least cost element from the open list.
			openList.splice(openList.indexOf(leastCostLink), 1);
			
			return leastCostLink;
		}
		
		/**
		 * For the given node, add its neightbors into the open list if not preset, or update if the
		 * neighbor is already on the open list and have a higher weight.
		 * @param	node
		 * @param	openList
		 * @param	closedList
		 */
		public function updateOpenList(nodeLink:SPFNodeLink, openList:Vector.<SPFNodeLink>, closedList:Vector.<SPFNodeLink>) : void
		{
			var neighborFound:Boolean = false;
			var link:SPFNodeLink;
			
			trace("\nupdate neighbors from node " + nodeLink.node.uid);
			for each (var node:SPFNode in nodeLink.node.neighborList)
			{
				trace("Node " + node.uid + " is inside node " + nodeLink.node.uid);
			}
			
			trace("open list before:");
			for each (var nodeLink2:SPFNodeLink in openList)
			{
				trace("node: " + nodeLink2.node.uid +
				" nodeFrom: " + ( (nodeLink2.nodeFrom != null)? nodeLink2.nodeFrom.uid : "null") + " weight: " + nodeLink2.weightTo);
			}
			
			// For each neighbor.
			for each (var neighbor:SPFNode in nodeLink.node.neighborList)
			{
				trace("\nNode " + neighbor.uid + " is inside node " + nodeLink.node.uid);
				trace("Checking neighbor " + neighbor.uid);
//#1 START +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				// Check if neighbor is already in the closed list.
				for each (link in closedList)
				{
					neighborFound = false;
					if (neighbor.uid != link.node.uid)
					{
						continue;
					}
					neighborFound = true;
					break;
				}
				
				// If neighbor already in closed list.
				if (neighborFound)
				{
					trace("neighbor found on closed list " + neighbor.uid);
					continue;
				}
//#1 END +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//#2 START +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				// Check if neightbor is already in the open list.
				for each (link in openList)
				{
					neighborFound = false;
					if (neighbor.uid != link.node.uid)
					{
						continue;
					}
					neighborFound = true;
					
					// If the node weight of the node in the list is higher than the new one.
					trace("neighbor found in the open list.\ncurr weight: " + link.weightTo);
					trace("nodeLink weight: " + nodeLink.weightTo);
					trace("neighbor weight: " + neighbor.weight);
					if (link.weightTo > (nodeLink.weightTo + neighbor.weight) )
					{
						link.weightTo = (nodeLink.weightTo + neighbor.weight);
						link.nodeFrom = nodeLink.node;
					}
					
					break;
				}
				
				// If neighbor found in open list and was updated.
				if (neighborFound)
				{
					continue;
				}
				
				// Add neightbor in the open list.
				openList.push(new SPFNodeLink(neighbor, nodeLink.node, nodeLink.weightTo + neighbor.weight))
			}
			
			
			trace("open list after:");
			for each (var nodeLink2:SPFNodeLink in openList)
			{
				trace("node: " + nodeLink2.node.uid +
				" nodeFrom: " + ( (nodeLink2.nodeFrom != null)? nodeLink2.nodeFrom.uid : "null") + " weight: " + nodeLink2.weightTo);
			}
		}
	}
	
}