#' Number of COVID cases by county in Illinois, early 2021
#'
#' A dataset containing the number of cases by ZIP code for Illinois
#' with observations taken roughly every week (although not 100% of
#' the time because of Wayback Machine data)
#'
#' @format A data frame with 1437 rows and 11 variables:
#' \describe{
#'   \item{ZIP}{ZIP code}
#'   \item{X1.Jun}{number of cumulative cases on Jun 1}
#'   \item{X15.May}{number of cumulative cases on May 15}
#'   \item{X1.May}{number of cumulative cases on May 1}
#'   \item{X24.Apr}{number of cumulative cases on Apr 24}
#'   \item{X14.Apr}{number of cumulative cases on Apr 14}
#'   \item{X3.Apr}{number of cumulative cases on Apr 3}
#'   \item{X27.Mar}{number of cumulative cases on Mar 27}
#'   \item{X20.Mar}{number of cumulative cases on Mar 20}
#'   \item{X13.Mar}{number of cumulative cases on Mar 13}
#'   \item{X6.Mar}{number of cumulative cases on Mar 6}
#' }
#' @source \url{https://www.dph.illinois.gov/covid19/covid19-statistics}
"IllinoisZIP"
