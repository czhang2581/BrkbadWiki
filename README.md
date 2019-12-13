---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->

```{r, include = FALSE}
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "man/figures/README-",
  out.width = "100%"
)
```

# BrkbadWiki
A Breaking Bad Wiki

The goal of BrkbadWiki is to provide a wiki page for the Breaking Bad (TV series)

## Installation

You can install the released version of BrkbadWiki from [CRAN](https://github.com) with:

``` r
install.packages("devtools")
devtools::install_github("czhang2581/BrkbadWiki")
```

## Example

This is a basic example which shows you how to do some wiki search:

```{r example}
library(BrkbadWiki)
option(5)
character("Walter White","Occupation")
cast("Jesse Pinkman")
death("random")
```
