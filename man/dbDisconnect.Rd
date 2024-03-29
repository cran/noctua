% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Connection.R
\docType{methods}
\name{dbDisconnect}
\alias{dbDisconnect}
\alias{dbDisconnect,AthenaConnection-method}
\title{Disconnect (close) an Athena connection}
\usage{
\S4method{dbDisconnect}{AthenaConnection}(conn, ...)
}
\arguments{
\item{conn}{A \linkS4class{DBIConnection} object, as returned by
\code{\link[DBI:dbConnect]{dbConnect()}}.}

\item{...}{Other parameters passed on to methods.}
}
\value{
\code{dbDisconnect()} returns \code{TRUE}, invisibly.
}
\description{
This closes the connection to Athena.
}
\examples{
\dontrun{
# Note:
# - Require AWS Account to run below example.
# - Different connection methods can be used please see `noctua::dbConnect` documnentation

library(DBI)

# Demo connection to Athena using profile name
con <- dbConnect(noctua::athena())

# Disconnect conenction
dbDisconnect(con)
}
}
\seealso{
\code{\link[DBI]{dbDisconnect}}
}
