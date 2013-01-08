#' Parse a string into a rfc822 address list.
#'
#' EBNF at \url{http://tools.ietf.org/html/rfc2822#section-3.4}
#'
#' @param string to parse
#' @return a list of \code{\link{address}}es
#' @examples
#' parse_address_list("<a@@b.com> Alison, <c@@d.com> Colin")
parse_address_list <- function(x) {
  stopifnot(is.character(x), length(x) == 1)

  lapply(str_split(x, ",")[[1]], parse_address)
}

#' An S3 class to represent email addresses.
#'
#' @param email email address
#' @param name display name, optional
#' @export
#' @examples
#' address("h.wickham@@gmail.com")
#' address("h.wickham@@gmail.com", "Hadley Wickham")
#' parse_address("<h.wickham@@gmail.com> Hadley Wickham")
#' parse_address("<h.wickham@@gmail.com>")
address <- function(email = NULL, name = NULL) {
  if (is.null(email) && is.null(name)) {
    stop("Address must have name or email", call. = FALSE)
  }

  structure(list(name = name, email = email), class = "address")
}

print.address <- function(x, ...) {
  if (is.null(x$name)) {
    cat("<", x$email, ">\n", sep = "")
  } else {
    cat('"', x$name, '"', " <", x$email, ">\n", sep = "")
  }
}

#' @rdname address
parse_address <- function(x) {
  stopifnot(is.character(x), length(x) == 1)

  pieces <- str_match(x, "(?:<.*>) ?(.*)?")[1, ]

  email <- str_trim(pieces[2])
  email <- str_replace_all(email, "<|>", "")

  name <- str_trim(pieces[3])
  name <- str_replace_all(name, fixed('"'), "")
  if (is.na(name) || str_length(name) == 0) name <- NULL

  address(email, name)
}
