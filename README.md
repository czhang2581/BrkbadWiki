
<!-- README.md is generated from README.Rmd. Please edit that file -->

# BrkbadWiki
A Breaking Bad Wiki

The goal of BrkbadWiki is to provide a "search engine" that provide detailed information about the characters and scenes in Breaking Bad (TV series)

## Installation

You can install the released version of BrkbadWiki from [Github](https://github.com) with:

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


## Usage

The __option__ function allows the user to see the full character list. The output table will include some basic information about all the characters appeared in the show.
The __character__ function allows the user to search for information they want to know about a character, like his or her occupation, status, the name of the actor or actress that portrayed this character, etc. 
If the user is particularly interested in one of the actor or actresss appeared in the show, he or she can use the __cast__ function to search for some detailed information about that actor or actress.
Last but not least, the __death__ function allows the user to retrieve some information about the death scenarios happened in the Breaking Bad

## Contact
If you have any question, please e-mail me at <cz2581@columbia.edu> 

