add_library(rbtree STATIC
    "misc.c"
    "red_black_tree.c"
    "stack.c")

set_property(TARGET rbtree PROPERTY POSITION_INDEPENDENT_CODE 1)