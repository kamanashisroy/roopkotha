using aroop;
using shotodol;
using roopkotha.gui;

public class roopkotha.gui.TextFormat : Replicable {
	public static int wrap_next(etxt*str, Font? font, int pos, int width) {
#if true
	  int i = pos,start = pos;
	  if(str.is_empty_magical() || font == null || width <= 0 ) {
		return -1;
	  }
	  int len = str.length();
	  if(pos == len) {
		return -1;
	  }
	  while (true) {
		while (i < len && str.char_at(i) > ' ')i++;
		int w = font.subStringWidth(str, start, i - start);
		if (pos == start) {
			if (w > width) {
			  while (font.subStringWidth (str, start, (--i - start )) > width);
			  pos = i;
			  break;
			}
		  }

		  if (w <= width) pos = i;

		if (w > width || i >= len || str.char_at(i) == '\n') break;
		i++;
	  }
	  pos += (pos >= len) ? 0 : 1;
	  return pos;
#else
	  return pos == 0 ? str.length() :-1;
#endif
	}
}

