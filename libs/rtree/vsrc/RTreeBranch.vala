using aroop;
using shotodol;

/** \addtogroup rtree
 *  @{
 */
public delegate int roopkotha.rtree.searchHitCallback(Replicable target);

public class roopkotha.rtree.RTreeBranch : Replicable {

	internal RTreeRect2DInt rect;
	internal RTreeNode child;
	Replicable?target;
	bool isRoot;
	static Factory<RTreeBranch> factory;
	
	public RTreeBranch() {
		factory = Factory<RTreeBranch>.for_type();
		factoryBuild();
		isRoot = true;
	}
	
	~RTreeBranch() {
		child.destroy();
		factory.destroy();
	}
	
	void factoryBuild() {
		memclean_raw();
		rect = RTreeRect2DInt();
		child = RTreeNode();
		child.level = 0; // leaf
		isRoot = false;
	}

	static RTreeBranch create() {
		RTreeBranch b = factory.alloc_full();
		//core.memclean_raw(&b.child,sizeof(RTreeNode));
		b.factoryBuild();
		return b;
	}

	// Search in an index tree or subtree for all data retangles that
	// overlap the argument rectangle.
	// Return the number of qualifying data rects.
	//
	public int search(RTreeRect2DInt *r, searchHitCallback ?shcb) {
		int hitCount = 0;

		core.assert(child.level >= 0);

		if (child.level > 0) /* this is an internal node in the tree */
		{
			Iterator<container<RTreeBranch>> it = Iterator<container<RTreeBranch>>.EMPTY();
			child.branch.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
			while(it.next()) {
				container<RTreeBranch> can = it.get();
				RTreeBranch b = can.get();
				if(b.rect.overlaps(r)) {
					hitCount += b.search(r, shcb);
				}
			}
			it.destroy();
		}
		else /* this is a leaf node */
		{
			Iterator<container<RTreeBranch>> it = Iterator<container<RTreeBranch>>.EMPTY();
			child.branch.iterator_hacked(&it, Replica_flags.ALL, 0, 0);
			while(it.next()) {
				container<RTreeBranch> can = it.get();
				RTreeBranch b = can.get();
				if(b.rect.overlaps(r)) {
					hitCount ++;
					if(shcb != null)// call the user-provided callback
						if(shcb(b.target) == 0)
							return hitCount;// callback wants to terminate search early
				}
			}
			it.destroy();
		}
		return hitCount;
	}



	// Inserts a new data rectangle into the index structure.
	// Recursively descends tree, propagates splits back up.
	// Returns 0 if node was not split.  Old node updated.
	// If node was split, returns 1 and sets the pointer pointed to by
	// new_node to point to the new node.  Old node updated to become one of two.
	// The level argument specifies the number of steps up from the leaf
	// level to insert; e.g. a data rectangle goes in at level = 0.
	//
	public int insertRect2(RTreeRect2DInt *r, int atLevel, Replicable?hook) {
		RTreeBranch b;
		core.assert(atLevel >= 0 && atLevel <= child.level);

		// Still above level for insertion, go down tree recursively
		//
		if (child.level > atLevel)
		{
			b = child.pickBranch(r);
			b.insertRect2(r, atLevel, hook);
			// child was not split
			//
			b.rect.combine(r);
			return 0;
		}

		// Have reached level for insertion. Add rect, split if necessary
		//
		else if (child.level == atLevel)
		{
			RTreeBranch nBranch = RTreeBranch.create();
			nBranch.rect.copyFrom(r);
			nBranch.target = hook;
			//nBranch.child = (struct Node *) tid;
			child.addBranch(nBranch);
			/* child field of leaves contains tid of data record */
			return 0;
		}
		else
		{
			/* Not supposed to happen */
			core.assert ("We should not reach here" == null);
			return 0;
		}
	}

	void cover() {
		child.cover(&rect);
	}
	// Insert a data rectangle into an index structure.
	// RTreeInsertRect provides for splitting the root;
	// returns 1 if root was split, 0 if it was not.
	// The level argument specifies the number of steps up from the leaf
	// level to insert; e.g. a data rectangle goes in at level = 0.
	// RTreeInsertRect2 does the recursion.
	//
	public int insertRect(RTreeRect2DInt *r, int atLevel, Replicable?hook)
	{
		int result = 0;
		//core.assert(child.level >= 0);
		//core.assert(r.xmin <= r.xmax && r.ymin <= r.ymax);

		if (insertRect2(r, atLevel, hook) != 0)  /* root split */
		{
			RTreeBranch cascadingBranch = RTreeBranch.create();
			cascadingBranch.child = child;
			cascadingBranch.cover();
			core.memclean_raw(&child, sizeof(RTreeNode));
			child = RTreeNode();
			child.level = cascadingBranch.child.level + 1;
			child.addBranch(cascadingBranch);
			cover();
		}
		else
			result = 0;

		return result;
	}

}
/** @} */
