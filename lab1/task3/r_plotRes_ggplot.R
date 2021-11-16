# Plot energy resolution of a detector as a function of energy
# and corresponding fits.

library(ggplot2)

# Read measured data
t <- read.csv("data_energyResolution.txt", sep = ";", header = T)

# Linear regression on log-log data
getPredictedDf <- function(x, y) {
  dfLn = data.frame(x = log(x), y = log(y))
  pred <- predict(lm(y ~ x, data = dfLn))
  return(data.frame(energy = exp(dfLn$x), R = exp(pred)))
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

plot1 <- ggplot(df, aes(energy, R)) +
  scale_x_log10() + scale_y_log10() + annotation_logticks() +
  geom_line(data = pred.CZT, mapping = aes(energy, R)) +
  geom_line(data = pred.NaI, mapping = aes(energy, R)) +
  geom_line(data = pred.HPGe, mapping = aes(energy, R)) +
  geom_point(aes(colour = factor(detector))) +
  labs(x = "E (keV)", y = "R  (%)") +
  theme_classic()

pdf(file = "fig_res_ggplot.pdf", width = 6, heigh = 3)
print(plot1)
dev.off()
