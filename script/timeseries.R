#- echo=F, results='hide', warning=F, error=F, message=F
library(reshape)
library(rCharts)
library(dplyr)
#- echo=T, results='markup', warning=T, error=T, message=T

#' # Bugs and violations over time

#' ## Data

klass.release.metrics <- readRDS("../data/klass-release-metrics.rds")
releases <- readRDS("../data/eclipse-releases.rds")

timeseries <- klass.release.metrics %.%
	inner_join(releases, by="release") %.%
	group_by(release) %.%
	summarise(bugs = sum(bugs),
		violations = sum(violations),
		time = max(initial.time),
		version = max(version)) %.%
	arrange(time) %.%
	mutate(time = as.character(time)) %.%
	select(version, time, bugs, violations)

timeseries

#' ## Visualization

#- vbtimeseries,results='asis'
options(rcharts.cdn = TRUE)
timeseries2 <- melt(timeseries, c("version", "time"))
h <- hPlot(value ~ version, group="variable", data=timeseries2, type="line") # like it!
h$save("../report/timeseries-plot.html")

# /*
# nPlot(value ~ version, group="variable", data=timeseries2, type="multiBarChart")
# xPlot(value ~ version, group="variable", data=timeseries2, type="line-dotted")

# df <- timeseries
# df$x <- 1:nrow(df)
# mPlot(x = "time", y = c("bugs", "violations"), type="Line", data = df)
# */