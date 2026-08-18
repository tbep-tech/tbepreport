# Sunburst plot of indicator, category, and overall outcomes for one bay segment and year

Sunburst plot of indicator, category, and overall outcomes for one bay
segment and year

## Usage

``` r
plot_score(
  wqoverall,
  sedoverall,
  fwoverall,
  haboverall,
  bay_segment,
  yr,
  wt = NULL
)
```

## Arguments

- wqoverall:

  output of
  [`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md)
  for water quality

- sedoverall:

  output of
  [`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md)
  for sediment

- fwoverall:

  output of
  [`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md)
  for fish/wildlife

- haboverall:

  output of
  [`anlz_category`](https://tbep-tech.github.io/tbepreport/reference/anlz_category.md)
  for habitat

- bay_segment:

  chr string, single bay segment to plot

- yr:

  integer, single year to plot

- wt:

  named numeric vector of category weights, passed to
  [`anlz_score`](https://tbep-tech.github.io/tbepreport/reference/anlz_score.md)

## Value

A `plotly` htmlwidget

## Details

Calls
[`anlz_score`](https://tbep-tech.github.io/tbepreport/reference/anlz_score.md)
on the four category data.frames to get the overall bay segment score
and each category's own score for `bay_segment`/`yr`, then plots a
three-ring sunburst using a colored center for the overall score, a
middle ring with one equal-size wedge per category (`wq`, `sed`, `fw`,
`hab`), and an outer ring with the indicator columns of each of
`wqoverall`, `sedoverall`, `fwoverall`, `haboverall` split evenly within
their own category's wedge, regardless of how many indicators another
category has. Every ring is colored on the same continuous
red/yellow/green outcome scale used by
[`plot_category`](https://tbep-tech.github.io/tbepreport/reference/plot_category.md),
with missing indicators/categories rendered gray rather than dropped.

## Examples

``` r
wqoverall <- anlz_category(
  wq_attain = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.8)
)
sedoverall <- anlz_category(
  sed_tbbi = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.6)
)
fwoverall <- anlz_category(
  tbni = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.7)
)
haboverall <- anlz_category(
  seagrass = data.frame(bay_segment = 'OTB', yr = 2020, outcome = 0.5)
)
plot_score(wqoverall, sedoverall, fwoverall, haboverall, bay_segment = 'OTB', yr = 2020)

{"x":{"visdat":{"1e47694221f5":["function () ","plotlyVisDat"]},"cur_data":"1e47694221f5","attrs":{"1e47694221f5":{"ids":["overall","wq","wq_wq_attain","sed","sed_sed_tbbi","fw","fw_tbni","hab","hab_seagrass"],"labels":["Overall","Water Quality","Targets","Sediment","Benthic Index","Fish and Wildlife","Nekton Index","Habitat","Seagrass"],"parents":["","overall","wq","overall","sed","overall","fw","overall","hab"],"values":[4,1,1,1,1,1,1,1,1],"branchvalues":"total","marker":{"colors":["#BFC724","#90C92D","#90C92D","#CEC620","#CEC620","#B0C827","#B0C827","#E9C318","#E9C318"],"line":{"color":"white","width":1}},"text":["Overall: 65%","Water Quality: 80%","Targets: 80%","Sediment: 60%","Benthic Index: 60%","Fish and Wildlife: 70%","Nekton Index: 70%","Habitat: 50%","Seagrass: 50%"],"hoverinfo":"text","textinfo":"text","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"sunburst"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":{"text":"OTB: 2020","x":0.5,"xanchor":"center","xref":"paper"},"paper_bgcolor":"#fcfcfb","hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"ids":["overall","wq","wq_wq_attain","sed","sed_sed_tbbi","fw","fw_tbni","hab","hab_seagrass"],"labels":["Overall","Water Quality","Targets","Sediment","Benthic Index","Fish and Wildlife","Nekton Index","Habitat","Seagrass"],"parents":["","overall","wq","overall","sed","overall","fw","overall","hab"],"values":[4,1,1,1,1,1,1,1,1],"branchvalues":"total","marker":{"color":"rgba(31,119,180,1)","colors":["#BFC724","#90C92D","#90C92D","#CEC620","#CEC620","#B0C827","#B0C827","#E9C318","#E9C318"],"line":{"color":"white","width":1}},"text":["Overall: 65%","Water Quality: 80%","Targets: 80%","Sediment: 60%","Benthic Index: 60%","Fish and Wildlife: 70%","Nekton Index: 70%","Habitat: 50%","Seagrass: 50%"],"hoverinfo":["text","text","text","text","text","text","text","text","text"],"textinfo":"text","type":"sunburst","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
