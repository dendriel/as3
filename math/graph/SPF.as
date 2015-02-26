package src.as3.math.graph
{
	/**
	 * ...
	 * @author Vitor Rozsa
	 * 
	 * WARNING:
		 * 
		 * The graph is a vector composed by SPFNode(s). Each node has its own weight and a list
		 * of neighbors. The SPFNode doesn't have any explicit link (edge). Any link to the given node
		 * have the same weight as it have. The SPF algorithm will build up the links and process
		 * of the vector list of SPFNodes.
		 * 
		 * *With this configuration, all the graphs are multidirectional.
		 * 
		 * For example:
		 * 
		 * A:
			 * weight: 2
			 * neighbors: B and C
		 *
		 * B: 
			 * weight: 1
			 * neighbors: A
		 *
		 * C:
			 * weight: 3
			 * neighbors: A
		 * 
		 * 
		 *     |<---2---|
		 *   A |----1-->|B
	 *      ^ |
	 *      2 3
	 *      | |
	 *      | \/
	 *       C
	 * 
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
		
		public function findSPF(from:int, to:int) : Vector.<SPFNode>
		{
			var graph:Array = _graph.concat();
			var openList:Vector.<SPFNodeLink> = new Vector.<SPFNodeLink>;
			var closedList:Vector.<SPFNodeLink> = new Vector.<SPFNodeLink>;
			var destinationReached:Boolean = false;
			var fromNodeLink:SPFNodeLink = new SPFNodeLink(graph[from], null, 0);
			var toNode:SPFNode = graph[to];
			
			//trace("Find SPF from node " + fromNodeLink.node.uid + " to node " + toNode.uid);
			
			closedList.push(fromNodeLink);
			
			updateOpenList(fromNodeLink, openList, closedList);
			
			while ( openList.length > 0)
			{
				var leastCostLink:SPFNodeLink = getLeastCostLink(openList, closedList);
			
				// Add the element into the closed list.
				closedList.push(leastCostLink);
				
				if (leastCostLink.node.uid == toNode.uid)
				{
					destinationReached = true;
					break;
				}
				
				updateOpenList(leastCostLink, openList, closedList);
			}
			
			if ( destinationReached != true)
			{
				return null;
			}
			
			/*trace("Closed list:");
			for each (var nodeLink:SPFNodeLink in closedList)
			{
				trace("node: " + nodeLink.node.uid +
				" nodeFrom: " + ( (nodeLink.nodeFrom != null)? nodeLink.nodeFrom.uid : "null") + " weight: " + nodeLink.weightTo);
			}*/
			
			return makeArrayFromClosedList(from, to, closedList);
		}
		
		private function makeArrayFromClosedList(from:int, to:int, list:Vector.<SPFNodeLink>) : Vector.<SPFNode>
		{
			var nodesList:Vector.<SPFNode> = new Vector.<SPFNode>;
			var nodeLink:SPFNodeLink;
			
			// Find destination;
			nodeLink = getNodeLinkOnList(to, list);
			
			// Add last node in the list.
			nodesList.push(nodeLink.node);
			
			// Find all nodes until "from" node.
			while (true)
			{
				nodeLink = getNodeLinkOnList(nodeLink.nodeFrom.uid, list);
				nodesList.push(nodeLink.node);
				
				// If found origin or there is no more nodes to go back.
				
				if ( (nodeLink.node.uid == from) || (nodeLink.nodeFrom == null) )
				{
					break;
				}
			}
			
			return nodesList;
		}
		
		/**
		 * Find the link for the given node.
		 * @param	uid
		 * @param	list
		 * @return
		 */
		private function getNodeLinkOnList(uid:int, list:Vector.<SPFNodeLink>) : SPFNodeLink
		{
			// Find destination.
			for each (var nodeLink:SPFNodeLink in list)
			{
				if (nodeLink.node.uid == uid)
				{
					return nodeLink;
				}
			}
			
			return null;
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
			
			// For each neighbor.
			for each (var neighbor:SPFNode in nodeLink.node.neighborList)
			{
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
		}
	}
	
}