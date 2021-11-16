# Plot tabulated and measured data

library(lattice)

# Read tabulated data
tt <- read.csv("data_lacTabulated_Pb.txt", sep = ";", header = T)

# Read measured data
tm <- read.csv("data_lacMeasured_Pb.txt", sep = ";", header = T)

plot1 <- xyplot(lacV ~ energy, data=tm,
  xlab = "E (keV)",
  ylab = expression(paste(mu, " ", (cm^{-1}))),
  xlim = c(100, 700),
  ylim = c(0, 17),
  
  # Define the legend
  key = list(
    text = list(c("tabulated", "measured")),
    points = list(col = c("darkorange", "darkgreen"), pch = c(16, 18)),
    corner = c(0.95, 0.95)
  ),
  
  panel = function(...) {
    # Plot tabulated data as a cubic spline and markers
    panel.spline(tt$energy, tt$lac, col = "darkorange")
    panel.xyplot(tt$energy, tt$lac, col = "darkorange", pch = 16)
    
    # Plot measured data as markers with error bars
    panel.xyplot(tm$energy, tm$lacV, pch = 18, col = "darkgreen")
    panel.arrows(tm$energy, tm$lacV, tm$energy, tm$lacV+tm$lacS,
      length = 0.05, angle = 90, col = "darkgreen")
    panel.arrows(tm$energy, tm$lacV, tm$energy, tm$lacV-tm$lacS,
      length = 0.05, angle = 90, col = "darkgreen")
  }
)

# Save the plot to the PDF file
pdf(file = "fig_lac_Pb_lattice.pdf", width = 5, heigh = 3)
print(plot1)
dev.off()

