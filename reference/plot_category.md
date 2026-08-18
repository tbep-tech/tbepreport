# Sunburst plot of indicator outcomes for one category, bay segment, and year

Sunburst plot of indicator outcomes for one category, bay segment, and
year

## Usage

``` r
plot_category(
  ...,
  bay_segment,
  yr,
  bay_segments = c("OTB", "HB", "MTB", "LTB"),
  yr_min = 2000,
  wt = NULL
)
```

## Arguments

- ...:

  named data.frames, passed to
  [`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md).
  See its documentation (and
  [`anlz_indicators`](https://tbep-tech.github.io/tbepreport/reference/anlz_indicators.md))
  for the expected shape

- bay_segment:

  chr string, single bay segment to plot, must be one of `bay_segments`

- yr:

  integer, single year to plot

- bay_segments:

  chr vector of bay segments to include, passed to
  [`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md),
  defaults to `c('OTB', 'HB', 'MTB', 'LTB')`

- yr_min:

  integer, minimum year to include, passed to
  [`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md),
  defaults to `2000`

- wt:

  named numeric vector of indicator weights, passed to
  [`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md)

## Value

A `plotly` htmlwidget

## Details

Calls
[`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md)
on `...` to get both the per-indicator outcomes (one wide column per
indicator) and the overall category score for `bay_segment`/`yr`, then
plots a two-ring sunburst using a colored center for the category's
overall `outcome` and an outer ring with one equal-size wedge per
indicator colored by that indicator's own outcome. Both rings use the
same continuous red/yellow/green outcome scale, and an indicator missing
for `bay_segment`/`yr` still gets an equal-size wedge, rendered gray
rather than dropped. Thematically identical to
[`plot_score`](https://tbep-tech.github.io/tbepreport/reference/plot_score.md),
which extends this same two-ring layout with a third ring combining
several categories.

## Examples

``` r
plot_category(
  wq_attain = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8),
  fib = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.4),
  bay_segment = 'OTB', yr = 2020
)

{"x":{"visdat":{"1d88502e49ea":["function () ","plotlyVisDat"]},"cur_data":"1d88502e49ea","attrs":{"1d88502e49ea":{"ids":["score","wq_attain","fib"],"labels":["Score","Targets","Fecal"],"parents":["","score","score"],"values":[2,1,1],"branchvalues":"total","marker":{"colors":["#CEC620","#90C92D","#E5A923"],"line":{"color":"white","width":1}},"text":["Score: 60%","Targets: 80%","Fecal: 40%"],"hoverinfo":"text","textinfo":"text","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"sunburst"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":{"text":"OTB: 2020","x":0.5},"paper_bgcolor":"#fcfcfb","hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"ids":["score","wq_attain","fib"],"labels":["Score","Targets","Fecal"],"parents":["","score","score"],"values":[2,1,1],"branchvalues":"total","marker":{"color":"rgba(31,119,180,1)","colors":["#CEC620","#90C92D","#E5A923"],"line":{"color":"white","width":1}},"text":["Score: 60%","Targets: 80%","Fecal: 40%"],"hoverinfo":["text","text","text"],"textinfo":"text","type":"sunburst","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
