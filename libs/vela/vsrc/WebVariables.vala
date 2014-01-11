/*
 * xultb_web_variables.c
 *
 *  Created on: Jan 12, 2012
 *      Author: kamanashisroy
 */

#include "opp/opp_factory.h"
#include "opp/opp_salt.h"
#include "io/xultb_ml_common.h"
#include "ui/page/xultb_web_variables.h"
#include "core/logger.h"
#include "opp/opp_hash_table.h"

static struct opp_factory variables;
struct opp_factory*xultb_get_web_variables(struct xultb_ml_node*root) {
	int i;
	struct xultb_ml_node*node;

	// TODO cleanup all the old variables ..

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
}

int xultb_web_variables_init() {
	SYNC_ASSERT(!opp_hash_table_create(
				&variables
				, 4
				, 0));
	return 0;
}

int xultb_web_variables_deinit() {
	opp_factory_destroy(&variables);
	return 0;
}
