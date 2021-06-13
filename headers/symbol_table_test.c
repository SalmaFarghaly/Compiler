#include "symbol_table.h"
// Driver program to test above functions

int main()
{
    char* name;
    strcpy(name, "x");
	float val = 1.23;

    struct scope_tree* tree;
	tree->root = malloc(sizeof(struct symbol_table));
	tree->current_scope =tree->root;

    append(tree->current_scope, "x", VAR, FLOAT,  &val );
    print(tree->current_scope);


	struct identifier* result = search(tree->current_scope, "x");
	printf("%s\n", result->attr->name);


    create_scope(tree);
    append(tree->current_scope, "y", VAR, FLOAT,  &val );
    print(tree->current_scope);

    close_current_scope(tree);
    create_scope(tree);
    append(tree->current_scope, "z", VAR, FLOAT,  &val );
    print(tree->current_scope);


    print(tree->current_scope->parent);


    create_scope(tree);



    char* y;
    scanf("%s", y);
}


