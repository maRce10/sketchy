# internal helper function not to be called by users
# stop function that doesn't print call
stop2 <- function (...)
{
  stop(..., call. = FALSE)
}

message2 <- function (...)
{
  message(..., call. = FALSE)
}
