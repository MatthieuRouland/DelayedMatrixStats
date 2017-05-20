DelayedMatrixStats
================

**DelayedMatrixStats** is a port of the [**matrixStats**](https://CRAN.R-project.org/package=matrixStats) API to work with *DelayedMatrix* objects from the [**DelayedArray**](http://bioconductor.org/packages/DelayedArray/) package.

For a *DelayedMatrix*, `x`, the simplest way to apply a function, `f()`, from **matrixStats** is`matrixStats::f(as.matrix(x))`. However, this of course realizes `x` in memory as a *base::matrix*, which typically defeats the entire purpose of using a *DelayedMatrix* for storing the data.

The **DelayedArray** package already implements a clever strategy called "block-processing" for certain common "matrix stats" operations (e.g. `colSums()`, `rowSums()`). This is a good start, but currently not all of the **matrixStats** API is currently supported. Furthermore, certain operations can be further operations with additional information about `x`. For example, if `x` is an *RleArray*, then `colSums(x)` can be very efficiently implemented by calling `sum,Rle-method()` on `x[, j]` for each `j`.
