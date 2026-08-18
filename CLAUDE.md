# tbepreport project preferences

## Linking to tbeptools documentation

`tbeptools` is not on CRAN, so standard cross-package Rd links
(`\link[tbeptools]{topic}`) do not reliably resolve. In roxygen
documentation and vignettes, link to tbeptools functions and datasets
with an explicit markdown hyperlink to the tbeptools pkgdown site
instead:

    [`topic`](https://tbep-tech.github.io/tbeptools/reference/topic.html)

For example, a reference to `transect` should link to
<https://tbep-tech.github.io/tbeptools/reference/transect.html>. This
works because `Roxygen: list(markdown = TRUE)` is set in `DESCRIPTION`,
so markdown links compile to `\href{}{\code{}}` in the generated `.Rd`
files.
