// C program for array implementation of stack
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum kind {FUNC, VAR, PAR};
enum type {type_char, type_int, type_float, type_double, type_string, type_void, type_bool};
const char* kinds[] = {"FUNC", "VAR", "PAR"};
const char* types[] = {"CHAR", "INT", "FLOAT", "DOUBLE", "STRING", "VOID", "BOOL"};
const char* bool_str[] = {"False", "True"};

struct attributes{
	char name [40];
	enum kind kind;
	enum type type;
	char value[100];
	int const_flag;
	enum type params[100];
	int no_of_usages;

};
struct identifier{
	struct attributes *attr;
	struct identifier *prev;
	struct identifier *next;
};

// Scope Heirarchy
struct symbol_table{
	struct identifier* head;
	struct symbol_table *parent;
	struct symbol_table * first_child;
	struct symbol_table *next_sibling;
	struct symbol_table *prev_sibling;
};


struct scope_tree{
	struct symbol_table* root;
	struct symbol_table* current_scope;
};


// Linked List functions

void print_to_file(struct symbol_table* table, FILE* file){
	struct identifier* curr = table->head;
	if (curr == NULL) {
		fprintf(file, "Empty symbol table.\n");

	}
	else{
		fprintf(file, "Name \t Kind \t Type \t Const \n------------------------------------------\n");
		while (curr != NULL){
			fprintf(file, "%s \t %s \t %s \t %s \t\n", curr->attr->name, kinds[curr->attr->kind], types[curr->attr->type], 
			bool_str[curr->attr->const_flag]);
			curr = curr->next;
		}
		fprintf(file,"\n\n");
	
	}
}

void print(struct symbol_table* table){
	struct identifier* curr = table->head;
	if (curr == NULL) {
		printf("Empty symbol table.\n");
	}
	else{
		printf("Name \t Kind \t Type \t Const \n------------------------------------------\n");
		while (curr != NULL){
			printf("%s \t %s \t %s \t %s \t", curr->attr->name, kinds[curr->attr->kind], types[curr->attr->type], 
			bool_str[curr->attr->const_flag]);
			if(curr->attr->kind == VAR){
				printf("%s \n\n",  (char*)curr->attr->value);
				// switch(curr->attr->type){
				// 	case type_char: printf("%c \n", *(char*)curr->attr->value); break;
				// 	case type_float: printf("%f \n", *(float*)curr->attr->value); break;
				// 	case type_double: printf("%d \n", *(double*)curr->attr->value); break;
				// 	case type_string: printf("%s \n", (char*)curr->attr->value); break;
				// 	case type_bool: printf("%d \n", *(int*)curr->attr->value); break;
				// 	default: printf("%p", curr->attr->value); break;
				// }
			}
			curr = curr->next;
		}

		printf("\n\n");
	}
	
}

struct identifier* search(struct symbol_table* table, char* name){
	struct identifier* curr = table->head;
	while (curr != NULL){
		if(strcmp(curr->attr->name, name) == 0){
			return curr;
		}
		curr = curr->next;
	}
	return NULL;
}

struct identifier* search_tree(struct scope_tree* tree, char* name){
	struct symbol_table* curr_table = tree->current_scope;
	struct identifier* result; 
	while (curr_table != NULL) {
		result = search(curr_table, name);
		if(result == NULL){
			curr_table = curr_table->parent;
		}
		else{
			return result;
		}
	}
	return NULL;
}

void append(struct symbol_table* table, char* name, enum kind kind, enum type type, int const_flag, char* value){
	struct attributes* row = (struct attributes*)malloc(sizeof(struct attributes));
	strcpy(row->name, name);
	row->kind = kind;
	row->type = type;
	row->const_flag = const_flag;
	row->no_of_usages = 0;
	strcpy(row->value, value);

	struct identifier* id = (struct identifier*)malloc(sizeof(struct identifier));
	id->attr = row;


	if (table->head == NULL){
		table->head = id;
		table->head->next = NULL;
		return;
	}

	else{
		struct identifier* curr = table->head;
		while (curr->next != NULL){
			curr = curr->next;
		}
		curr->next = id;
		id->next =NULL;
	}
	return;
}






void create_scope(struct scope_tree* tree){
	struct symbol_table* new_table = (struct symbol_table*) malloc(sizeof(struct symbol_table));
	new_table->parent = tree->current_scope;
	if(tree->current_scope->first_child == NULL){
		new_table->prev_sibling = NULL;
		new_table->next_sibling = NULL;
		tree->current_scope->first_child = new_table;
	}
	else{
		struct symbol_table* curr = tree->current_scope->first_child;
		while(curr->next_sibling != NULL){
			curr = curr->next_sibling;
		}
		curr->next_sibling = new_table;
		new_table->prev_sibling = curr;
		new_table->next_sibling = NULL;
	}
	//Set current scope to the newly created scope
	tree->current_scope = new_table;
}


void close_current_scope(struct scope_tree* tree){
	tree->current_scope = tree->current_scope->parent;
}


