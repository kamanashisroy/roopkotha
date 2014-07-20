using aroop;
using shotodol;
using roopkotha.rtree;

/** \addtogroup rtree
 *  @{
 */
public struct roopkotha.rtree.RTreeNode {
	int count;
	internal int level; /* 0 is leaf, others positive */
	internal ArrayList<RTreeBranch> branch;

	// Initialize a Node structure.
	//
	public RTreeNode()
	{
		count = 0;
		level = -1;
		branch = ArrayList<RTreeBranch>();
	}

	public void destroy() {
		count = 0; 
		branch.destroy();
	}

	// Find the smallest rectangle that includes all rectangles in
	// branches of a node.
	//
	public void cover(RTreeRect2DInt*cvr)
	{
		bool first_time=true;
		*cvr = RTreeRect2DInt();

		Iterator<AroopPointer<RTreeBranch>> it = Iterator<AroopPointer<RTreeBranch>>.EMPTY();
		branch.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			AroopPointer<RTreeBranch> can = it.get();
			RTreeBranch b = can.get();
			if (first_time) {
				cvr.copyFrom(&b.rect);
				first_time = false;
			} else
				cvr.combine(&b.rect);
		}
		it.destroy();
	}

	// Pick a branch.  Pick the one that will need the smallest increase
	// in area to accomodate the new rectangle.  This will result in the
	// least total area for the covering rectangles in the current node.
	// In case of a tie, pick the one which was smaller before, to get
	// the best resolution when searching.
	//
	public RTreeBranch pickBranch(RTreeRect2DInt*r)
	{
		bool first_time = true;
		int increase, bestIncr=-1, area, bestArea;
		RTreeRect2DInt tmp_rect = RTreeRect2DInt();
		RTreeBranch ?best = null;
		bestArea = 0;
		area = 0;
		increase = 0;


		Iterator<AroopPointer<RTreeBranch>> it = Iterator<AroopPointer<RTreeBranch>>.EMPTY();
		branch.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
		while(it.next()) {
			AroopPointer<RTreeBranch> can = it.get();
			RTreeBranch b = can.get();
			area = b.rect.sphericalVolume();
			tmp_rect.copyFrom(r);
			tmp_rect.combine(&b.rect);
			increase = tmp_rect.sphericalVolume() - area;
			if (increase < bestIncr || first_time)
			{
				best = b;
				bestArea = area;
				bestIncr = increase;
				first_time = false;
			}
			else if (increase == bestIncr && area < bestArea)
			{
				best = b;
				bestArea = area;
				bestIncr = increase;
			}
		}
		it.destroy();
		return best;
	}



	// Add a branch to a node.  Split the node if necessary.
	// Returns 0 if node not split.  Old node updated.
	// Returns 1 if node split, sets *new_node to address of new node.
	// Old node updated, becomes one of two.
	//
	public int addBranch(RTreeBranch b)
	{
		//branch.add((b.rect.ymax-b.rect.ymin)+(b.rect.xmax-b.rect.xmin) ,b);
		branch.add(b);
		count++;
		return 0;
	}
}
/** @} */
