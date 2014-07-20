using aroop;

/*
 * xultb_web_variables.c
 *
 *  Created on: Jan 12, 2012
 *      Author: kamanashisroy
 */

/** \addtogroup vela
 *  @{
 */
public class roopkotha.vela.WebVariables : Replicable {
	HashTable<xtring,xtring> tbl;
	public WebVariables() {
		tbl = HashTable<xtring,xtring>(xtring.hCb,xtring.eCb,4);
	}
	~WebVariables() {
		tbl.destroy();
	}
#if false
	void getVariables(PageAppDocument doc) {
#if false
	for(i=0;;i++) {
		opp_at_ncode2(node, struct xultb_ml_node*, &root->children, i,
			xultb_str_t*var_name = NULL;
			xultb_str_t*var_value = NULL;
			if(xultb_str_equals_static(node->name, "t")
					&& (var_name = xultb_ml_get_attribute_value(node, "v"))
					&& (var_value = xultb_ml_get_text(node))) {
				SYNC_LOG(SYNC_VERB, "Variable name:%s, value:%s\n", var_name->str
						, (node->elem.content && node->elem.content->str)?node->elem.content->str:"");
				opp_hash_table_set(&variables, var_name, var_value);
			}
		) else {
			break;
		}
	}
	return &variables;
#endif
	}
#endif
}

/** @} */
