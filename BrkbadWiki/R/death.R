#' Helper Function Search Death Scenarios by the Cause
#'
#' This function is a helper function that helps the main function to search for death scenarios by a specific cause
#'
#' @param df A data table that contains all the death scenarios
#' @param weapon Specify the cause of death, select from gun, knive, bomb, poison, strangle, crush, beat, decapitate, overdose, slit and collide
#' @return All death senarios caused by *weapon*
#' @author Chuze Zhang <\url{https://github.com/QMSS-G5072-2019/Zhang_Chuze}>
#'
#' @importFrom dplyr %>%
#' @importFrom purrr map
#' @importFrom stringr str_detect
#'
#' @keywords internal



cause <- function(df, weapon){
  if (weapon == 'gun'|weapon=='shot'){
    pattern = "(S|s)hots?"
  }

  if (weapon == "stab"|weapon=="knive"){
    pattern = "(S|s)tabbed"
  }

  if (weapon == "bomb"){
    pattern = "(B|b)omb"
  }

  if (weapon == "poison"){
    pattern = "(P|p)oisone?d?"
  }

  if (weapon == "strangle"|weapon=="garrote"){
    pattern = "(S|s)trangled?"
  }

  if (weapon == "crush"){
    pattern = "(C|c)rushe?d?"
  }

  if (weapon=="beat"){
    pattern = "Beaten"
  }

  if (weapon=="decapitate"){
    pattern = "Decapitate"
  }

  if(weapon == "overdose"){
    pattern = "overdose"
  }

  if (weapon == "slit"){
    pattern = "(T|t)hroat\\sslit"
  }

  if (weapon == "collide"){
    pattern = "(F|f)lights?\\scollided?"
  }

  else if (!weapon %in% c("gun","shot","stab","knive","bomb","poison","strangle","garrote","crush","beat","decapitate","overdose","slit","collide")){
    stop("Please specify the cause of death, try : gun, poison, bomb, strangle, etc")
  }


  df<-df[map(df$Cause, function(x)str_detect(x, pattern))%>%unlist(),]

  rownames(df)<-NULL

  return(df)
}

#' All Death Scenarios
#'
#' This function allows the user to retrieve some information about the death scenarios happened in the Breaking Bad
#'
#' @param func Specify what the user wants this function to perform, valid inputs include random(some information about a death at random), all(retrieve information about every death in Breaking Bad) and search(search for death scenarios by a specific cause)
#' @param weapon The casue of death, valid input include ("gun","shot","stab","knive","bomb","poison","strangle","garrote","crush","beat","decapitate","overdose","slit","collide")
#' @return A table includes the requested(specified by *func*) information.
#' @author Chuze Zhang <\url{https://github.com/QMSS-G5072-2019/Zhang_Chuze}>
#'
#' @importFrom dplyr %>% arrange
#' @importFrom stringr str_replace str_c
#' @importFrom httr GET http_error content
#' @importFrom jsonlite fromJSON
#'
#'
#' @export
#' @examples
#' death()
#' death("random")
#' death("all")
#' death("search", "bomb")


death <- function(func = 'random', weapon = "gun"){

  weapon = tolower(weapon)

  if (func == 'random'){
    endpoint<-"https://www.breakingbadapi.com/api/random-death"
    response <- GET(endpoint)
    cont <-content(response)

    keys <-c("Death", "Cause", "Responsible", "Last Words", "Occur")

    values <-c(cont$death, cont$cause, cont$responsible, cont$last_words, str_c("Season ",cont$season," | Episode", cont$episode ))

    df <- data.frame("Key"=keys,"Value"=values)

    return (df)
  }

  if (func == "all"|func == "search"){
    endpoint <- "https://www.breakingbadapi.com/api/deaths"
    response <- GET(endpoint)
    cont <-content(response)
    df <- fromJSON(content(response, as = "text"))
    colnames(df) <- c("ID", "Death", "Cause", "Responsible", "Last Words", "Season", "Episode", "Number of Deaths")
    df<-df%>%arrange(df$ID)

  }

  if (func=="all"){
    return (df)
  }

  if (func == "search"){
    cause(df, weapon)
  }

  else if (!func %in%c("all", "random", "search")){

    stop("Please check the function input, try all, random, or search")
  }
}
