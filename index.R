## ----setup, echo = FALSE-------------------------------------------------
options(width = 90)

## ----pkgs-slides, eval = FALSE-------------------------------------------
## ## for reproducing the slides
## install.packages("revealjs")
## ## for following examples
## install.packages(
##     c("bookdown", "data.table", "dplyr", "fortunes", "ggplot2",
##       "microbenchmark", "plotly", "profvis", "Rcpp", "shiny")
## )

## ----need-packages, echo = FALSE-----------------------------------------
##' Check, Install and Attach Multiple R packages Specified
##'
##' The function first Checks whether the packages given were installed. Then
##' install them if they are not, then attach them to the search path.
##'
##' @usage need.packages(pkg)
##' @param pkg A character vector specifying the packages needed to reproduce
##'     this document.
##' @param ... Other arguments passed to function \code{\link[base]require}.
##' @return NULL invisibly.
##' @examples
##' need.pacakges(c("ggplot2", "geepack"))
need.packages <- function(pkg, ...)
{
    new.pkg <- pkg[! (pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg))
        install.packages(new.pkg, repos = "https://cloud.r-project.org")
    foo <- function(a, ...) suppressMessages(require(a, ...))
    sapply(pkg, foo, character.only = TRUE)
    invisible(NULL)
}
need.packages(
    c("bookdown", "data.table", "dplyr", "fortunes", "ggplot2",
      "microbenchmark", "plotly", "profvis", "Rcpp", "shiny")
)

## ----help, eval = FALSE--------------------------------------------------
## ?help                         # details on using the `help` function
## help(package = "stats")       # information about the stats package

## ----help-search, eval = FALSE-------------------------------------------
## ??splines                     # search "splines"
## help.search("row mean")       # search "row mean"

## ----calculator, eval = FALSE--------------------------------------------
## x = (1 + 2) * 3 / 4                   # x = 2.25
## x ^ 2                                 # 5.0625
## x %% 2                                # 0.25
## x %/% 2                               # 1
## z <- y <- 4:1 - 1                     # z = y = (3, 2, 1, 0)
## log(y)                                # (1.099, 0.693, 0.000, -∞)
## y[1]                                  # 3
## y[c(1, 2)]                            # (3, 2)
## y[- 1]                                # (2, 1, 0)
## y[- c(2, 3)]                          # (3, 0)
## c(x, y)                               # (2.25, 3, 2, 1, 0)
## c(exp(1), pi)                         # (2.718282, 3.141593)

## ----vectors, eval = FALSE-----------------------------------------------
## dbl_var <- c(1, 2.5, 4.5)                 # double
## int_var <- c(1L, 6L, 10L)                 # integer (with `L` suffix)
## log_var <- c(TRUE, FALSE, T, F)           # logical (avoid using `T`, `F`)
## chr_var <- c("these are", "some strings") # character

## ----na, eval = FALSE----------------------------------------------------
## is.na(c(NA, NaN))                         # (TRUE, TRUE)
## is.nan(c(NA, NaN))                        # (FALSE, TRUE)
## is.null(NA)                               # FALSE
## is.null(NaN)                              # FALSE
## is.null(NULL)                             # TRUE

## ----vector-examples, eval = FALSE---------------------------------------
## ## e.g.,
## x <- 1:3                         # (1, 2, 3)
## length(x)                        # 3
## names(x) <- letters[x]           # add names to x: "a", "b", and "c"
## y <- setNames(x, LETTERS[x])     # (1, 2, 3) with names "A", "B", and "C"
## names(y)                         # "A", "B", and "C"
## y["A"]                           # 1 with name "A"
## head(y, 2)                       # (1, 2) with names "A", "B"
## head(y, - 1)                     # the same with `head(y, 2)`
## y[c("B", "C")] <- c(4, 6)        # y = (1, 4, 6) with names "A", "B", "C"
## rev(y)                           # (4, 2, 1) with names "C", "B", and "A"
## c("A", "B") %in% names(y)        # (TRUE, TRUE)
## z <- rep(letters[x], x)          # z = ("a", "b", "b", "c", "c", "c")
## paste0(z, 1:6)                   # "a1", "b2", "b3", "c4", "c5", and "c6"

## ----matrix-examples, eval = FALSE---------------------------------------
## a <- matrix(LETTERS[1:6], nrow = 2)  # 2 x 3 matrix ("A"-"F" by columns)
## dim(a)                               # (2, 3)
## a[2]                                 # "B"
## a[1, ]                               # the first row
## a[, 2]                               # the second column
## a[1, 1:2]                            # "A" and "C"
## a[rbind(c(1, 3), c(2, 1), c(2, 2))]  # "E", "B", "D"
## b <- array(1:12, c(2, 3, 2))         # a 2 x 3 x 2 array
## dim(b)                               # (2, 3, 2)

## ----data-frame-examples-------------------------------------------------
dat <- data.frame(x = 1:3, y = c("a", "b", "c"))
dat$z <- as.character(dat$x + 10)
dat$fac_z <- factor(dat$z)
str(dat)

## ----list-examples-------------------------------------------------------
x <- list(1:3, "a", c(TRUE, FALSE, TRUE), c(2.3, 5.9))
names(x) <- c("foo", "bar", "alpha", "beta")
str(x)
y <- list(x, sum)
str(y)
y[[2]](1:10)

## ----nested-list-example-------------------------------------------------
z <- list(list(list()))
str(z)

## ----function-examples, echo = -9----------------------------------------
## e.g.,
foo <- function(x) x + 1
bar <- function(x, y = "alpha") {
    x <- x + 1
    list(x = x, y = y)
}
`%+%` <- function(e1, e2) paste0(e1, e2)
"foo" %+% "bar"
rm("%+%")               # remove it for using ggplot2 later

## ----lazy-evaluation-----------------------------------------------------
f <- function(a, b) {
    a + 1
}
f(2)                    # without any error/warning/message

## ----lazy-evaluation-error-example, eval = FALSE-------------------------
## f <- function(a, b) {
##     return(a + b)
## }
## f(2)                     # error: argument "b" is missing, with no default

## ----dots-argument-myplot, eval = FALSE----------------------------------
## my_plot <- function(x, y, type = "l", ...) {
##     plot(x, y, type = type, ...)
## }
## ## the first function call leads to the second one
## my_plot(x, y, col = "red", lty = 2)
## plot(x, y, type = "l", col = "red", lty = 2)

## ----dots-argument-------------------------------------------------------
f <- function(x, ...) list(...)
str(f(1, a = "alpha", b = TRUE))
f()

## ----dots-example-1------------------------------------------------------
str(paste)
str(cat)

## ----dots-example-2------------------------------------------------------
paste(letters[1:3], c(2, 4, 5), sep = " = ", collapse = ", ")

## ----lexical-scoping-example-1-------------------------------------------
f <- function(x, y) {
    x * 3 + y / z                       # z is called a free variable
}
z <- 10
f(1, 20)

## ----lexical-scoping-example-2-------------------------------------------
power <- function(pow) {
    function(x) x ^ pow
}
square <- power(2)
square(3)
cube <- power(3)
cube(2)

## ----lexical-scoping-example-3-------------------------------------------
ls(environment(square))
get("pow", environment(square))
ls(environment(cube))
get("pow", environment(cube))
search()

## ----lexical-scoping-example-4, eval = FALSE-----------------------------
## y <- 10
## f <- function(x) {
##     y <- 2
##     y ^ 2 + g(x)
## }
## g <- function(x) x * y                # what is the value of `y` here?
## f(3)

## ----a-bad-loop----------------------------------------------------------
## a simple loop that seems to be okay
## however, it is a not necessary loop in R!
x <- 0; y <- c(4, 3, 9)
for (i in 1:3) {
    x <- x + y[i]
}
x == sum(y)

## ----apply-example-1-----------------------------------------------------
str(apply)
set.seed(123)
mat <- matrix(rnorm(200), nrow = 10)
apply(mat, 1, quantile, probs = c(0.25, 0.75))
apply(mat, 2, function(a) max(a) - min(a))

## ----apply-example-2-----------------------------------------------------
x <- array(rnorm(200), dim = c(2, 2, 10))
apply(x, c(1, 2), mean)
rowMeans(x, dims = 2)                # better performance as shown later
apply(x, c(1, 2), sum)
rowSums(x, dims = 2)                 # better performance as shown later

## ----lapply-sapply-example-1---------------------------------------------
a <- 1:3
(foo <- lapply(a, function(b) rnorm(b)))
sapply(foo, mean)

## ----lapply-sapply-example-2---------------------------------------------
dat <- subset(iris, subset = Species %in% levels(iris$Species)[1],
              select = - Species)
str(dat)
str(lapply(dat, quantile, probs = c(0.25, 0.75)))
sapply(dat, quantile, probs = c(0.25, 0.75))

## ----vectorized-example-1------------------------------------------------
x <- 1:3; y <- 4:9; x + y               # x is recycled
x > 2
pmax(x, 2)

## ----vectorized-example-2------------------------------------------------
x <- matrix(1:4, nrow = 2); y <- matrix(10, 2, 2)
x * y                                   # element-wise multiplication
x %*% y                                 # true matrix multiplication
rep(1:3, times = 2:4)
rnorm(10, mean = 1:5, sd = 0.1)         # mean is recycled
paste0("No.", 1:3)                      # "No." is recycled

## ----sum-aggregation-data------------------------------------------------
set.seed(123)
dat <- data.frame(x = rpois(200, lambda = 5),
                  y = round(runif(200, max = 10)))
str(dat)

## ----sum-aggregation-solutions-------------------------------------------
res_1 <- with(dat, by(y, x, sum))                   # `base::by`

res_2 <- with(dat, tapply(y, x, sum))               # `base::tapply`

res_3 <- aggregate(y ~ x, data = dat, FUN = sum)    # `stats::aggregate`

res_4 <- xtabs(y ~ x, data = dat)                   # `stats::xtabs`

suppressMessages(library(plyr))                     # `plyr::ddply`
res_5 <- ddply(dat, "x", summarise, sum = sum(y))

suppressMessages(library(dplyr))                    # dplyr package
res_6 <- dat %>% group_by(x) %>% summarise(sum = sum(y))

suppressMessages(library(data.table))               # data.table package
dat <- as.data.table(dat)
res_7 <- dat[, .(sum = sum(y)), keyby = x]

## ----debugging-foo-------------------------------------------------------
foo <- function(x) {
    x2 <- x * 2
    sum(log(x2))
}
foo(1:3)

## ----debugging-test, eval = FALSE----------------------------------------
## foo("a")                                # leads to error
## set.seed(123); foo(rnorm(100))          # leads to warning

## ----debugging-browser, eval = FALSE-------------------------------------
## foo <- function(x) {
##     x2 <- x * 2
##     browser()
##     sum(log(x2))
## }

## ----debugging-traceback, eval = FALSE-----------------------------------
## f <- function(x) {
##     x - g(x + 1)
## }
## g <- function(y) {
##     h(2 * y)
## }
## h <- function(z) {
##     a <- log(z)
##     if (all(a < 10))
##         a ^ 2
##     else
##         a
## }
## f(rnorm(10))          # Error: missing value where TRUE/FALSE needed
## traceback()

## ----tryCatch-example----------------------------------------------------
bar <- function(x) {
    res <- tryCatch(as.numeric(x), warning = function(w) w)
    if ("warning" %in% class(res)) x else res
}
str(bar("123"))
str(bar("abc"))

## ----rowsum-examples-----------------------------------------------------
mat <- matrix(rnorm(200), nrow = 10)
a <- vector(mode = "numeric", length = nrow(mat))
for (i in 1:nrow(mat)) a[i] <- sum(mat[i, ]) # 1. using a for loop
a
apply(mat, 1, sum)                      # 2. using the apply function
rowSums(mat)                            # 3. using the rowSums function

## ----rowsum-benchmark, cache = FALSE-------------------------------------
library(microbenchmark)
microbenchmark(
    "for loop" = { a <- vector(mode = "numeric", length = nrow(mat));
        for (i in 1:nrow(mat)) a[i] <- sum(mat[i, ]) },
    "apply" = apply(mat, 1, sum),
    "rowSums" = rowSums(mat),
    times = 200, unit = "relative"
)

## ----sessionInfo---------------------------------------------------------
sessionInfo()

## ----performance-tip-1, cache = TRUE-------------------------------------
vec <- rnorm(50)
stopifnot(all.equal(1:length(vec), seq_along(vec)))
microbenchmark(1:length(vec), seq_along(vec),
               times = 1e3, unit = "relative")

## ----performance-tip-2, cache = TRUE-------------------------------------
stopifnot(all.equal(1:100, seq_len(100)))
microbenchmark(1:100, seq_len(100), times = 1e3, unit = "relative")

## ----performance-tip-3, cache = TRUE-------------------------------------
mat1 <- matrix(rnorm(1e4), 1e2)
stopifnot(all.equal(mat1 %*% t(mat1), tcrossprod(mat1)))
microbenchmark(t(mat1) %*% mat1, crossprod(mat1), unit = "relative")

## ----performance-tip-4, cache = TRUE-------------------------------------
stopifnot(all.equal(mat1 %*% t(mat1), tcrossprod(mat1)))
microbenchmark(mat1 %*% t(mat1), tcrossprod(mat1), unit = "relative")

## ----performance-tip-5, cache = TRUE-------------------------------------
mat2 <- matrix(rnorm(1e4), 1e2)
stopifnot(all.equal(t(mat1) %*% mat2, crossprod(mat1, mat2)))
microbenchmark(t(mat1) %*% mat2, crossprod(mat1, mat2), unit = "relative")

## ----performance-tip-6, cache = TRUE-------------------------------------
stopifnot(all.equal(mat1 %*% t(mat2), tcrossprod(mat1, mat2)))
microbenchmark(mat1 %*% t(mat2), tcrossprod(mat1, mat2), unit = "relative")

## ----performance-tip-7, cache = TRUE-------------------------------------
x <- 1:1e4; x[5e3] <- NaN               # coerces x to be double
stopifnot(all.equal(any(is.na(x)), anyNA(x)))
microbenchmark(any(is.na(x)), anyNA(x), unit = "relative")

## ----performance-tip-8, cache = TRUE-------------------------------------
stopifnot(all.equal(apply(mat1, 2, mean), colMeans(mat1)))
microbenchmark(apply(mat1, 2, mean), colMeans(mat1), unit = "relative")

## ----sum-aggregation-benchmark, cache = TRUE-----------------------------
microbenchmark(
    "by" = with(dat, by(y, x, sum)),
    "tapply" = with(dat, tapply(y, x, sum)),
    "aggregate" = aggregate(y ~ x, data = dat, FUN = sum),
    "xtabs" = xtabs(y ~ x, data = dat),
    "ddply" = ddply(dat, "x", summarise, sum = sum(y)),
    "dplyr" = dat %>% group_by(x) %>% summarise(sum = sum(y)),
    "data.table" = dat[, .(sum = sum(y)), keyby = x],
    times = 1e3, unit = "relative"
)

## ----profvis-example-----------------------------------------------------
## example of `profvis`
if (interactive()) {
    profvis({
        dat <- data.frame(x = rnorm(5e4),
                          y = rnorm(5e4))
        plot(x ~ y, data = dat)
        m <- lm(x ~ y, data = dat)
        abline(m, col = "red")
    })
}

## ----sum-aggregation-rcpp, cache = TRUE----------------------------------
library(Rcpp)
sourceCpp("src/aggregateSum.cpp")     # available at the source repository
res_8 <- with(dat, aggregateSum(y, x))
microbenchmark(
    "tapply" = with(dat, tapply(y, x, sum)),
    "rcpp_wi_names" = with(dat, aggregateSum(y, x)),
    "rcpp_wo_names" = with(dat, aggregateSum(y, x, addNames = FALSE)),
    times = 1e3, unit = "relative"
)

## ----base-graphics-examples----------------------------------------------
## a simple example of using base plotting system
par(mfrow = c(1, 2), mgp = c(2, 1, 0), mar = c(3, 3, 2, 0.1))
x <- 1:22; plot(x, pch = x, col = x, cex = 2)
abline(a = 0, b = 1, lty = 3, col = "#64C7C9")
abline(h = 21, col = "#BDC0C3", lty = 2)
hist(rnorm(200), breaks = 30, col = "#85B3CC", freq = FALSE)

## ----ggplot2-example-1---------------------------------------------------
## example boxplots of using ggplot2
library(ggplot2)
p <- ggplot(mpg, aes(class, hwy))
(p1 <- p + geom_boxplot(aes(colour = drv)))

## ----ggplot2-example-2---------------------------------------------------
## flip the coordinate and use the classic dark-on-light theme
p1 + coord_flip() + theme_bw()

## ----vertical-diff, echo = -1--------------------------------------------
par(mfrow = c(1, 1), mgp = c(2, 1, 0), mar = c(3, 3, 0.1, 0.1))
x <- seq(0.1, 10, 0.1)
plot(x, 1/x, type = "l", lwd = 2)
lines(x, 1/x + 2, col = "red", lwd = 2)

## ----good-practices------------------------------------------------------
library(fortunes)
fortune(250)

## ----hello-shiny, eval = FALSE-------------------------------------------
## library("shiny")
## ui <- fluidPage(
##     titlePanel("Hello Shiny!"),
##     sidebarLayout(
##         sidebarPanel(sliderInput("bins", "Number of bins:",
##                                  min = 1, max = 50, value = 30)),
##         mainPanel(plotOutput("distPlot"))
##     )
## )
## server <- function(input, output) {
##     output$distPlot = renderPlot({
##         x = faithful[, 2]
##         bins = seq(min(x), max(x), length.out = input$bins + 1)
##         hist(x, breaks = bins, col = 'darkgray', border = 'white')
##     })
## }
## shinyApp(ui = ui, server = server)

## ----shiny-splines2, echo = FALSE----------------------------------------
knitr::include_app("https://wenjie-stat.shinyapps.io/minisplines2/", "500px")

