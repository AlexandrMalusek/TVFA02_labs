# Plot energy resolution of a detector as a function of energy
# and corresponding fits.

library(lattice)

# Read measured data
t <- read.csv("data_energyResolution.txt", sep = ";", header = T)

# Linear regression on log-log data
getPredictedDf <- function(x, y) {
  dfLg = data.frame(x = log10(x), y = log10(y))
  model <- lm(y ~ x, data = dfLg)
  print(model)
  pred <- predict(model)
  return(data.frame(lgEnergy = dfLg$x, lgR = pred))
}

# Calculate values predicted by the linear regression.
# Exclude the 511.0 keV peak.
pred.CZT <- getPredictedDf(t$energy[-2], t$R.CZT[-2])
pred.NaI <- getPredictedDf(t$energy[-2], t$R.NaI[-2])
pred.HPGe <- getPredictedDf(t$energy[-2], t$R.HPGe[-2])

# Define a new data frame for plotting
ne <- length(t$energy)
df <- data.frame(
  energy = rep(t$energy, 3),
  R = c(t$R.CZT, t$R.NaI, t$R.HPGe),
  detector = c(rep("CZT", ne), rep("NaI", ne),rep("HPGe", ne))
)

plot1 <- xyplot(R ~ energy, data = df, group = detector,
  scales = list(x = list(log = T, equispaced.log = FALSE),
    y = list(log = T, equispaced.log = FALSE)),
  xlab = "E (keV)",
  ylab = "R (%)",

  # Define the legend
  auto.key = list(points = T, space = "right"),

  panel = function(x, y, ...) {
    panel.xyplot(x, y, ...)
    col <- trellis.par.get("superpose.symbol")$col;
    panel.xyplot(pred.CZT$lgEnergy,  pred.CZT$lgR,  type="l", col = col[1])
    panel.xyplot(pred.HPGe$lgEnergy, pred.HPGe$lgR, type="l", col = col[2])
    panel.xyplot(pred.NaI$lgEnergy,  pred.NaI$lgR,  type="l", col = col[3])
  } 
)

pdf(file = "fig_res_lattice.pdf", width = 6, heigh = 3)
print(plot1)
dev.off()
