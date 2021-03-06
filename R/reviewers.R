#' Invite reviewer(s).
#' 
#' Once you have added reviewers to the DESCRIPTION file, you can use
#' this function to draft invite emails to them all. As well as drafting
#' the emails, it also caches them locally in the \code{correspodence/}
#' directory of the corresponding article.
#' 
#' @param article article id, like \code{"2014-01"}
#' @param reviewer_id invite just a single reviewer
#' @param prefix prefix added to start file name - used to distinguish
#'   between multiple rounds of reviewers (if needed)
#' @export
invite_reviewers <- function(article, prefix = "1") {
  article <- as.article(article)
  update_status(article, "out for review")
  
  for(i in seq_along(article$reviewers)) {
    invite_reviewer(article, i, prefix = prefix)
  }
}

#' @export
#' @rdname invite_reviewers
invite_reviewer <- function(article, reviewer_id, prefix = "1") {
  article <- as.article(article)
  
  dest <- file.path(article$path, "correspondence")
  if (!file.exists(dest)) dir.create(dest)
  
  reviewer <- article$reviewers[[reviewer_id]]
  name <- paste0(prefix, "-invite-", reviewer_id, ".txt")
  path <- file.path(dest, name)
  
  if (!file.exists(path)) {
    data <- as.data(article)
    data$email <- reviewer$email
    data$name <- reviewer$name
    data$date <- format(Sys.Date() + 30, "%d %b %Y")
    
    template <- find_template("review")
    email <- whisker.render(readLines(template), data)
    
    writeLines(email, path)
  } else {
    message("Already invited - resending")
    email <- paste0(readLines(path), collapse = "\n")
  }
  
  email_text(email)
}
