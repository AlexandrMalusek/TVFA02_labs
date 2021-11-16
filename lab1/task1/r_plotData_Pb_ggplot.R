# Plot tabulated and measured data

library(ggplot2)

# Read tabulated data
tt <- read.csv("data_lacTabulated_Pb.txt", sep = ";", header = T)

# Read measured data
tm <- read.csv("data_lacMeasured_Pb.txt", sep = ";", header = T)

plot1 <- ggplot() +
  geom_errorbar(tm,
    mapping = aes(x = tm$energy, ymin=tm$lacV-tm$lacS, ymax=tm$lacV+tm$lacS, width=20),
    col = "darkgreen") +
  geom_point(tm,
    mapping = aes(x=tm$energy, y=tm$lacV),
    col = "darkgreen") +
  geom_point(tt,
    mapping = aes(x=tt$energy, y=tt$lac),
    col = "darkorange") + 
  geom_line(data = data.frame(spline(tt, n = 200)),
    aes(x, y), col = "darkorange") +
  labs(x = "E (keV)", y = expression(paste(mu, " ", (cm^{-1})))) +
  xlim(100, 700) + ylim(0, 17) +
  theme_classic()

pdf(file = "fig_lac_Pb_ggplot.pdf", width = 5, heigh = 3)
print(plot1)
dev.off()

