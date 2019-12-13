#' Helper Function Clean Up
#'
#' This function is a helper function that helps the main function to clean up the children section
#'
#' @param value Digits indicating how many children an individual has, or just the name of a child in character string
#' @return Keep the digits and remove all explanations after that.
#' @author Chuze Zhang <\url{https://github.com/QMSS-G5072-2019/Zhang_Chuze}>
#'
#' @importFrom stringr str_detect str_extract str_replace_all
#'
#' @keywords internal


child_cleanup <- function(value){

  pattern <- "^[:digit:]+.*"

  if (str_detect(value, pattern)==TRUE){
    pattern_desired = str_extract(value, '[:digit:]+')
    value = str_replace_all(value, pattern, pattern_desired)
    return (as.numeric(value))

  }

  else{
    return (value)
  }


}

#' Search for Cast Memebers
#'
#' If the user is particularly interested in one of the actors or actresses that appeared in the show, he or she can use this function to search for some detailed information about that actor or actress.
#'
#' @param id The id of the character (portrayed by the actor/actress the user is interested in) the user wants to search for, it can also be the full name of the character. (like "Walter White")
#' @return A table with some detailed information about an actor or actress who portrayed the character the user gave input to the function.
#' @author Chuze Zhang <\url{https://github.com/QMSS-G5072-2019/Zhang_Chuze}>
#'
#' @importFrom dplyr %>%
#' @importFrom stringr str_replace str_detect str_c str_replace_all
#' @importFrom httr GET http_error content
#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes html_table
#' @importFrom purrr map
#'
#' @export
#' @examples
#' cast()
#' cast("10")
#' cast("38")
#' cast("Jesse Pinkman")


cast <- function(id='1'){

  pattern1 <- "^[:digit:]+.*"

  pattern2 <- "^[:alpha:]+.*"

  if (str_detect(id, pattern1)==TRUE){


    endpoint <- str_c('https://www.breakingbadapi.com/api/characters/',id)
    response <- GET(endpoint)

    if (http_error(response)){
      stop("The request produced an error")
    }

    cont <- content(response)

    if (length(cont)==0){
      stop("The ID input is not valid, please check your input")
    }

  }

  if (str_detect(id, pattern2)==TRUE){

    cont<- convert_url(id, 'https://www.breakingbadapi.com/api/characters')

  }

  act <- cont[[1]]$portrayed
  act <- act%>%str_replace(' ', '_')

  url <- str_c('https://en.wikipedia.org/wiki/', act)

  tryCatch(read_html(url), error = function(e) stop("It seems like he/she does not have a wiki page"))

  wiki <- read_html(url)

  info_box <-html_nodes(wiki, "#mw-content-text > div > table.infobox.biography.vcard")

  if (length(info_box)==0){
    stop("Fail to find an info box")
  }

  table_df <- html_table(info_box, header = TRUE, dec = ',')[[1]]
  name <- table_df%>%colnames
  name[1] = 'Name'

  colnames(table_df) <- c("Key","Value")

  table_df$Key = map(table_df$Key, function(x) return(x<-x%>%str_replace_all("\\s",'-')))%>%unlist()


  table_df <- subset(table_df, table_df$Key %in% c("Born", "Residence","Education","Alma-mater","Occupation","Year-active", "Years-active", "Partner(s)","Spouse(s)" ,"Children", "Known-for"))

  table_df<-rbind(name, table_df)
  table_df<-rbind(table_df, c("Web Page", url))

  rownames(table_df)=NULL

  table_df[table_df$Key=="Occupation",]$Value<- table_df[table_df$Key=="Occupation",]$Value%>%str_replace_all("\n",", ")
  table_df[table_df$Key=="Children",]$Value<-table_df[table_df$Key=="Children",]$Value%>%map(function(x)child_cleanup(x))%>%unlist()
  table_df[table_df$Key=="Born",]$Value<- table_df[table_df$Key=="Born",]$Value%>%str_replace_all("\\)","\\) | ")
  table_df[table_df$Key=="Education",]$Value<- table_df[table_df$Key=="Education",]$Value%>%str_replace_all("\\)","\\) | ")

  return (table_df)

}
