% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Connection.R
\docType{methods}
\name{Query}
\alias{Query}
\alias{dbSendQuery,AthenaConnection,character-method}
\alias{dbSendStatement,AthenaConnection,character-method}
\alias{dbExecute,AthenaConnection,character-method}
\title{Execute a query on Athena}
\usage{
\S4method{dbSendQuery}{AthenaConnection,character}(conn, statement, unload = athena_unload(), ...)

\S4method{dbSendStatement}{AthenaConnection,character}(conn, statement, unload = athena_unload(), ...)

\S4method{dbExecute}{AthenaConnection,character}(conn, statement, unload = athena_unload(), ...)
}
\arguments{
\item{conn}{A \linkS4class{DBIConnection} object, as returned by
\code{\link[DBI:dbConnect]{dbConnect()}}.}

\item{statement}{a character string containing SQL.}

\item{unload}{boolean input to modify `statement` to align with \href{https://docs.aws.amazon.com/athena/latest/ug/unload.html}{AWS Athena UNLOAD},
default is set to \code{FALSE}.}

\item{...}{Other parameters passed on to methods.}
}
\value{
Returns \code{AthenaResult} s4 class.
}
\description{
The \code{dbSendQuery()} and \code{dbSendStatement()} method submits a query to Athena but does not wait for query to execute.
             \code{\link{dbHasCompleted}} method will need to ran to check if query has been completed or not.
             The \code{dbExecute()} method submits a query to Athena and waits for the query to be executed.
}
\examples{
\dontrun{
# Note:
# - Require AWS Account to run below example.
# - Different connection methods can be used please see `noctua::dbConnect` documnentation

library(DBI)

# Demo connection to Athena using profile name
con <- dbConnect(noctua::athena())

# Sending Queries to Athena
res1 <- dbSendQuery(con, "show databases")
res2 <- dbSendStatement(con, "show databases")
res3 <- dbExecute(con, "show databases")

# Disconnect conenction
dbDisconnect(con)
}
}
\seealso{
\code{\link[DBI]{dbSendQuery}}, \code{\link[DBI]{dbSendStatement}}, \code{\link[DBI]{dbExecute}}
}
