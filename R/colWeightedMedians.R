### ============================================================================
### colWeightedMedians
###

### ----------------------------------------------------------------------------
### Non-exported methods
###

.DelayedMatrix_block_colWeightedMedians <- function(x, w = NULL, rows = NULL,
                                                    cols = NULL, na.rm = FALSE,
                                                    ...) {
  # Check input type
  stopifnot(is(x, "DelayedMatrix"))
  DelayedArray:::.get_ans_type(x, must.be.numeric = TRUE)

  # Check and subset 'w' (must be either NULL, or a numeric vector of
  # length 1 or 'nrow(x)')
  if (!is.null(w)) {
    stopifnot(is.numeric(w))
    if (length(w) != 1L) {
      stopifnot(length(w) == nrow(x))
      if (!is.null(rows))
        w <- w[rows]
    }
  }

  # Subset 'x'
  x <- ..subset(x, rows, cols)

  # Compute result
  val <- colblock_APPLY(x = x,
                        FUN = colWeightedMedians,
                        w = w,
                        na.rm = na.rm,
                        ...)
  if (length(val) == 0L) {
    return(numeric(ncol(x)))
  }
  # NOTE: Return value of matrixStats::colWeightedMedians() has names
  unlist(val, recursive = FALSE, use.names = TRUE)
}

### ----------------------------------------------------------------------------
### Exported methods
###

# ------------------------------------------------------------------------------
# General method
#

#' @inherit MatrixGenerics::colWeightedMedians
#' @importMethodsFrom DelayedArray seed
#' @rdname colWeightedMedians
#' @template common_params
#' @template lowercase_x
#' @export
#' @template example_dm_Rle
#' @author Peter Hickey
#' @examples
#'
#' # Specifying weights inversely proportional to rowwise MADs
#' colWeightedMedians(dm_Rle, w = 1 / rowMads(dm_Rle))
setMethod("colWeightedMedians", "DelayedMatrix",
          function(x, w = NULL, rows = NULL, cols = NULL, na.rm = FALSE,
                   force_block_processing = FALSE, ...) {
            .smart_seed_dispatcher(x, generic = MatrixGenerics::colWeightedMedians, 
                                   blockfun = .DelayedMatrix_block_colWeightedMedians,
                                   force_block_processing = force_block_processing,
                                   w = w,
                                   rows = rows,
                                   cols = cols,
                                   na.rm = na.rm,
                                   ...)
          }
)
