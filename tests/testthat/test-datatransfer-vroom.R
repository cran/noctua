context("data transfer vroom")

# NOTE System variable format returned for Unit tests:
# Sys.getenv("noctua_arn"): "arn:aws:sts::123456789012:assumed-role/role_name/role_session_name"
# Sys.getenv("noctua_s3_query"): "s3://path/to/query/bucket/"
# Sys.getenv("noctua_s3_tbl"): "s3://path/to/bucket/"

s3.location1 <- paste0(Sys.getenv("noctua_s3_tbl"),"test_df/")
s3.location2 <- Sys.getenv("noctua_s3_tbl")

test_that("Testing data transfer between R and athena vroom", {
  skip_if_no_env()
  skip_if_package_not_avialable("vroom")
  
  noctua_options("vroom")
  # Test connection is using AWS CLI to set profile_name 
  con <- dbConnect(athena(),
                   s3_staging_dir = Sys.getenv("noctua_s3_query"))
  
  df <- data.frame(w = as.POSIXct((Sys.time() -9):Sys.time(), origin = "1970-01-01", tz = "UTC"),
                   x = 1:10,
                   y = c(letters[1:8], c(" \\t\\t\\n 123 \" \\t\\t\\n ", ",15 \"")), 
                   z = sample(c(TRUE, FALSE), 10, replace = T),
                   stringsAsFactors = F)
  
  # testing if bigint is transferred correctly
  df2 <- data.frame(var1 = sample(letters, 10, replace = T),
                    var2 = bit64::as.integer64(1:10),
                    stringsAsFactors = F)
  if (dbExistsTable(con, "test_df")) 
    suppressWarnings(dbRemoveTable(con, "test_df", confirm = T))
  
  DATE <- Sys.Date()
  dbWriteTable(con, "test_df", df,
               partition = c("timesTamp" = format(DATE, "%Y%m%d")),
               s3.location = s3.location1
  )
  dbWriteTable(con, "test_df2", df, 
               overwrite = T,
               partition = c("year" = format(DATE, "%Y"),
                             "month" = format(DATE, "%m"),
                             "DAY" = format(DATE, "%d")),
               s3.location = s3.location2
  )
  dbWriteTable(con, "df_bigint", df2, overwrite = T, s3.location = s3.location2)
  dbWriteTable(con, "mtcars2", mtcars, overwrite = T, compress = T) # mtcars used to test data.frame with row.names
  
  # if data.table is available in namespace result returned as data.table
  test_df <- as.data.frame(dbGetQuery(con, paste0("select w, x, y, z from test_df where timestamp ='", format(DATE, "%Y%m%d"),"'")))
  test_df2 <- as.data.frame(dbGetQuery(con, paste0("select w, x, y, z from test_df2 where year = '", format(DATE, "%Y"), "' and month = '",format(DATE, "%m"), "' and day = '", format(DATE, "%d"),"'")))
  test_df3 <- as.data.frame(dbGetQuery(con, "select * from df_bigint"))
  test_df4 <- as.data.frame(dbGetQuery(con, "select * from mtcars2"))
  
  # vroom adds attribute spec/problems. Attributes needs to be removed for unit test
  # attribute spec
  attributes(test_df)$spec <- NULL
  attributes(test_df2)$spec <- NULL
  attributes(test_df3)$spec <- NULL
  attributes(test_df4)$spec <- NULL
  
  # attribute problems
  attributes(test_df)$problems <- NULL
  attributes(test_df2)$problems <- NULL
  attributes(test_df3)$problems <- NULL
  attributes(test_df4)$problems <- NULL

  expect_equal(test_df, df)
  expect_equal(test_df2, df)
  expect_equal(test_df3,df2)
  expect_equal(test_df4, sqlData(con, mtcars))
})

test_that("Test unload athena query vroom",{
  skip_if_no_env()
  skip_if_package_not_avialable("arrow")
  skip_if_package_not_avialable("dplyr")
  
  con <- dbConnect(
    athena(),
    s3_staging_dir = Sys.getenv("noctua_s3_query"))
  
  noctua::noctua_options("vroom")
  
  df = dbGetQuery(con, "select 1 as n", unload = T)
  
  expect_s3_class(df, "tbl_df")
  expect_equal(df$n, 1)
})
