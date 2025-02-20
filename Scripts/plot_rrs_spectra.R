## Plot the Rrs Spectra generated by the test_asd_group.exe program

## Libraries
library(ggplot2)
library(tidyverse)

# List all rrs files
rrs_files <- list.files("Data/rrs_data")

## Ggplot theme
theme_sat <- theme(panel.grid = element_blank(),
                   plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"),
                   text = element_text(size= 14),
                   plot.background = element_rect(fill = "transparent", color= "transparent"), # bg of the plot
                   panel.background = element_rect(fill= "transparent", color= "transparent"),
                   panel.border= element_rect(fill= "transparent", color= "black", linetype= "solid", size= 0.5),
                   panel.ontop = TRUE,
                   axis.text = element_text(colour="black"),
                   axis.title.x = element_text(vjust = -0.75),
                   axis.title.y = element_text(vjust = 1.5),
                   legend.background = element_rect(size=0.25, color="black", fill= "transparent"),
                   legend.key = element_blank(),
                   strip.background=element_rect(fill="transparent", color="transparent"),
                   #axis.text.x = element_text(angle= 45, hjust= 1),
                   legend.position = "right")


## Plotting function
plot_rrs <- function(file_name){
  
# Read in spectra
rrs_spec <- suppressMessages(read_csv(str_c("Data/rrs_data/", file_name), skip= 31, col_names = FALSE)) %>% 
  rename(nm= X1, rrs= X2)

# Extract waterbody and pixel from filename
waterbody <- str_split(str_replace(file_name, ".txt", ""), "-")[[1]][2]
pix_site <- str_split(str_replace(file_name, ".txt", ""), "-")[[1]][3]


# Make plot
spec_plot <- ggplot(data= rrs_spec) +
  geom_vline(xintercept = c(620, 665, 681, 709), linetype= "dashed", size= 0.5) +
  scale_x_continuous(expand= c(0, 0), 
                     breaks= c(350, 400, 450, 500, 550, 600, 620, 650, 665, 681, 709, 750, 800, 850, 900), 
                     labels= c("", "400", "", "500", "", "600", "620", "", "665", "681", "709", "", "800", "", "900")) +
  scale_y_continuous(expand= c(0.02, 0)) +
  scale_x_continuous(limits= c(400, 800),
                     expand= c(0, 0)) +
  geom_line(aes(x= nm, y= rrs), size= 1) +
  labs(x= "nm", y= "Field rrs", title= waterbody, subtitle = pix_site) +
  theme_classic(base_size = 18) +
  theme_sat +
  theme(axis.text.x = element_text(angle= 90, vjust= 0.5),
        panel.border= element_rect(fill= "transparent", color= "transparent")
  )

# Save
ggsave(spec_plot, filename= str_c(waterbody, pix_site, "rrs.jpg", sep= "-"), height= 6, width= 8, units= "in", dpi= 300,
       path= "Data/spectral_shape_plots")

}

# Loop over all files
map(rrs_files, function(x) plot_rrs(file_name= x))




