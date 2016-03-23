
list_to_tree <- function(x) {
    treeify <- function(x) {
        if ( (length(names(x)) == 2) & all(c("value", "children") %in% names(x)) ) {
            x <- x[c("value", "children")] ## python dict changes up order
            class(x) <- "Tree"
        }
        x
    }
    y <- NLP::Tree_apply(x, treeify, recursive = TRUE)
    structure(list(value=x$value, children=y), class="Tree")
}

Rify <- function(x, class=NULL) {
    if (class == "nltk.tree") {
        return(list_to_tree(x))
    }
    return(x)
}

