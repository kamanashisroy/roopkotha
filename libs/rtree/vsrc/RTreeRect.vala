using aroop;
using shotodol;
using roopkotha.rtree;

/**
 * \ingroup gui
 * \defgroup rtree 2 dimentional RTree implementation
 * 
 */

/** \addtogroup rtree
 *  @{
 */
public struct roopkotha.rtree.RTreeRect2DInt {
	int xmin;
	int ymin;
	int xmax;
	int ymax;

	public RTreeRect2DInt.boundary(int xMin, int xMax, int yMin, int yMax) {
		xmin = xMin;
		ymin = yMin;
		xmax = xMax;
		ymax = yMax;
	}

	public RTreeRect2DInt() {
		xmin = ymin = xmax = ymax = 0;
	}

	public RTreeRect2DInt.from_rect(RTreeRect2DInt*other) {
		xmin = other.xmin;
		ymin = other.ymin;
		xmax = other.xmax;
		ymax = other.ymax;
	}

	public void copyFrom(RTreeRect2DInt*other) {
		xmin = other.xmin;
		ymin = other.ymin;
		xmax = other.xmax;
		ymax = other.ymax;
	}

	/*-----------------------------------------------------------------------------
	| Calculate the n-dimensional volume of a rectangle
	-----------------------------------------------------------------------------*/
	int volume() {
		return (ymax - ymin)*(xmax - xmin);
	}

	public int sphericalVolume()
	{
	#if false
		double sum_of_squares=0, radius;

		if(xmax == xmin && ymax == ymin) return 0;
		double extent = (((double)(ymax - ymin))/2);
		sum_of_squires += extent*extent;
		extent = (((double)(xmax - xmin))/2);
		sum_of_squires += extent*extent;
		
		radius = sqrt(sum_of_squares);
		return radius*radius;
	#else
		return volume();
	#endif
	}


	/*-----------------------------------------------------------------------------
	| Calculate the n-dimensional surface area of a rectangle
	-----------------------------------------------------------------------------*/
	int surfaceArea()
	{
		return 2*(ymax - ymin)*(xmax-xmin);
	}


	/*-----------------------------------------------------------------------------
	| Combine two rectangles, make one that includes both.
	-----------------------------------------------------------------------------*/
	public void combine(RTreeRect2DInt*other)
	{
		if(xmin > other.xmin) {
			xmin = other.xmin;
		}
		if(ymin > other.ymin) {
			ymin = other.ymin;
		}
		if(xmax < other.xmax) {
			xmax = other.xmax;
		}
		if(ymax < other.ymax) {
			ymax = other.ymax;
		}
	}


	/*-----------------------------------------------------------------------------
	| Decide whether two rectangles overlap.
	-----------------------------------------------------------------------------*/
	public bool overlaps(RTreeRect2DInt*other)
	{
		return !((xmin > other.xmax || other.xmin > xmax) || (ymin > other.ymax || other.ymin > ymax));
	}


	/*-----------------------------------------------------------------------------
	| Decide whether rectangle r is contained in rectangle s.
	-----------------------------------------------------------------------------*/
	public bool isContainedIn(RTreeRect2DInt*other)
	{
		return (xmin >= other.xmin) && (ymin >= other.ymin) && (xmax <= other.xmax) && (ymax <= other.ymax);
	}

}
/** @} */
