\name{status}
\alias{status}
\title{Create a S3 status object}
\usage{
status(status, date = Sys.Date(), comments = "")
}
\arguments{
  \item{status}{A string description the status. Must be
  listed in \code{\link{valid_status}}}

  \item{date}{Date, defaults to today. Must be after
  2002-01-01 and not in the future.}

  \item{comments}{any additional extra comments}
}
\description{
Create a S3 status object
}
\examples{
status("rejected")
c(status("rejected"), status("accepted"))
}
\keyword{internal}

