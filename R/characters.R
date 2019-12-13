#' Full Character List
#'
#' This function allows the user to see the full character list. The output table will include some basic information about the characters that appeared in the show.
#'
#' @param limit limit the amount of characters you receive. default to the full list (63).
#' @return A table includes some basic information about the characters that appeared in the show.
#' @author Chuze Zhang <\url{https://github.com/QMSS-G5072-2019/Zhang_Chuze}>
#'
#' @importFrom dplyr %>%
#' @importFrom httr GET http_error content http_type
#'
#'
#' @export
#' @examples
#' option()
#' option("10")

option <- function(limit=63){

  if (63<as.numeric(limit)|as.numeric(limit)<1|is.na(as.numeric(limit))){
    stop("Your limit input is invalid, try integer number >= 1 but <= 63")
  }

  endpoint <- 'https://www.breakingbadapi.com/api/characters'
  query_param <- list("limit" = limit)
  response <- GET(endpoint, query = query_param)

  if (http_error(response)){
    stop("The request produced an error")
  }

  if (http_type(response) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  cont <-content(response)

  names<-c()
  ids <- c()
  nicknames <-c()
  actors <- c()

  i=1

  for (item in cont){
    name<-item$name%>%unlist()
    id <- item$char_id%>%unlist()
    nickname <- item$nickname%>%unlist()
    actor <- item$portrayed%>%unlist

    names[i] = name
    ids[i] = id
    nicknames[i] = nickname
    actors [i] = actor

    i=i+1
  }

  df <- data.frame("Name" = names, "ID" = ids, "Nickname" = nicknames, "Actor" = actors)

  return (df)
}



#' Helper Function Convert
#'
#' This function is a helper function that helps the main function to convert character inputs to readable API addresses.
#'
#' @param na character input, the name of the character
#' @param endp specify the API endpoint of the search
#' @return content of the search in list form
#' @author Chuze Zhang <\url{https://github.com/QMSS-G5072-2019/Zhang_Chuze}>
#'
#' @importFrom dplyr %>%
#' @importFrom stringr str_replace
#' @importFrom httr GET http_error content
#'
#' @keywords internal

convert_url <- function(na, endp){

  na <- na%>%str_replace(' ','+')

  endpoint <- endp

  query_parameter <- list(name = na)

  response<- GET(endpoint, query = query_parameter)

  if (http_error(response)){
    stop("The request produced an error")
  }


  url<-response$url%>%str_replace('%2B','+')

  response<-GET(url)

  if (http_error(response)){
    stop("The request produced an error")
  }

  if (length(content(response))==0){
    stop ("The name input is not valid, please check your input")
  }


  return(content(response))

}


#' Information Search
#'
#' This function allows the user to search for some detailed information they want to know about a character.
#'
#' @param id The id of the character the user wants to search for, it can also be the full name of the character. (like 'Walter White')
#' @param func Specify what exactly the user wants to know about this character, valid inputs include display(all available information), occupation, status, death count, portrayed and image. Display is the default.
#' @return A table includes the requested(specified by *func*) information about a character.
#' @author Chuze Zhang <\url{https://github.com/QMSS-G5072-2019/Zhang_Chuze}>
#'
#' @importFrom stringr str_c str_detect
#' @importFrom httr GET http_error content
#' @importFrom utils download.file
#' @importFrom graphics plot
#' @importFrom imager load.image
#'
#'
#' @export
#' @examples
#' characters()
#' characters(5, "display")
#' characters(7, "occupation")
#' characters("Jesse Pinkman", "image")


characters <- function(id = '1', func = "display"){

  func = tolower(func)

  pattern1 <- "^[:digit:]+.*"

  pattern2 <- "^[:alpha:]+.*"

  if (str_detect(id, pattern1)==TRUE){

    endpoint <- str_c('https://www.breakingbadapi.com/api/characters/',id)
    response <- GET(endpoint)

    if (http_error(response)){
      stop("The request produced an error")
    }

    cont <-content(response)

    if (length(cont)==0){
      stop("The ID input is not valid, please check your input")
    }
  }

  if (str_detect(id, pattern2)==TRUE){

    cont<- convert_url(id, 'https://www.breakingbadapi.com/api/characters')
  }


  keys <- c()
  values<-c()

  sear <- cont[[1]]$name
  ct <- convert_url(sear, 'https://www.breakingbadapi.com/api/characters')

  ct2 <- convert_url(sear, 'https://www.breakingbadapi.com/api/death-count')
  death <- ct2[[1]]$deathCount

  occu = ''
  i = 1

  for (item in ct[[1]]$occupation){
    if (i == 1){
      occu<-item
      i=2
    }
    else{
      occu<-str_c(occu,item, sep = ', ')
    }
  }

  if (func == "display"){

    keys <-c("Names", "Birthday", "Occupation", "Status", "Nickname","Death Count","Portrayed")

    values <-c(cont[[1]]$name, cont[[1]]$birthday, occu, cont[[1]]$status, cont[[1]]$nickname, death, cont[[1]]$portrayed)

    df <- data.frame("Key"=keys,"Value"=values)

    return(df)

  }

  if (func == "occupation"){
    keys <-c("Names", "Nickname", "Occupation")

    values <-c(cont[[1]]$name,cont[[1]]$nickname, occu)

    df <- data.frame("Key"=keys,"Value"=values)

    return(df)
  }

  if (func == "status"){

    keys <-c("Names", "Nickname", "Status")

    values <-c(cont[[1]]$name,cont[[1]]$nickname, cont[[1]]$status)

    df <- data.frame("Key"=keys,"Value"=values)

    return(df)
  }

  if (func == "death count"){

    keys <-c("Names", "Nickname", "Death Count")

    values <-c(cont[[1]]$name,cont[[1]]$nickname, death)

    df <- data.frame("Key"=keys,"Value"=values)

    return(df)
  }

  if (func == "portrayed"){

    keys <-c("Names", "Nickname", "Portrayed")

    values <-c(cont[[1]]$name,cont[[1]]$nickname, cont[[1]]$portrayed)

    df <- data.frame("Key"=keys,"Value"=values)

    return(df)
  }

  if (func == "image"){

    img <- cont[[1]]$img
    download.file(img,'img.jpg', mode = 'wb')

    jj <- load.image("img.jpg")
    plot(jj,ann=FALSE,axes=FALSE)
  }

  else if (!func %in%c("display", "occupation", "status", "death count", "portrayed", "image")){

    stop("Please check the function input, try display, status, death count, portrayed, occupation or image")
  }

}































