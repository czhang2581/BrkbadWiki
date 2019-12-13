library(BrkbadWiki)
context("Check for Valid Output")

test_that("Length of option", {
  expect_equal(nrow(option()), 63)
  expect_equal(nrow(option(5)), 5)
})


check_character_1 <- characters(3, "Occupation")
check_character_1 <- check_character_1[check_character_1$Key=="Occupation",]%>%.$Value%>%as.character()


check_character_2 <- characters(10, "death count")
check_character_2 <- check_character_2[check_character_2$Key=="Death Count",]%>%.$Value%>%as.character()


test_that("Results of character search are accurate", {
  expect_equal(check_character_1, 'House wife, Book Keeper, Car Wash Manager, Taxi Dispatcher')
  expect_equal(check_character_2, '3')
  expect_error(characters("Walter", "display"))
  expect_error(characters(3, "age"))
})

check_cast_1 <- cast(2)
check_cast_1 <- check_cast_1[check_cast_1$Key=="Name",]%>%.$Value%>%as.character()

check_cast_2 <- cast("Skyler White")
check_cast_2 <- check_cast_2[check_cast_2$Key=="Children",]%>%.$Value%>%as.character()

test_that("Results of cast search are accurate", {
  expect_equal(check_cast_1, 'Aaron Paul')
  expect_equal(check_cast_2, '2')
  expect_error(cast(13))
  expect_error(cast("Skyler"))
})

test_that("Results of death scenarios are accurate", {
  expect_equal(nrow(death("all")), 65)
  expect_equal(nrow(death("search", "bomb")), 4)
  expect_error(death("search","atomic bomb"))
})
