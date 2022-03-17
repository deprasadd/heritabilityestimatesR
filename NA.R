library(tidyverse)
library(dplyr)
library(ggplot2)
NA_ %>% 
  mutate(VG.Vp.ratio.SE = sprintf("%0.1f", VG.Vp.ratio.SE ))
sort(NA_$VG.Vp.ratio.SE)

data = NA_
se=format(round(NA_$VG.Vp.ratio.SE, 2), nsmall = 2)
vg = format(round(NA_$VG.Vp.ratio.var, 2), nsmall = 2)
vg=paste(vg, "(", se,")",  sep = "")

num_data = seq(1, 112)


label_data = data
number_of_bars=nrow(label_data)
angle = 90 - 360 * (num_data-0.5)/number_of_bars
label_data$hjust <- ifelse(angle < -90, 1, 0)
label_data$angle <- ifelse(angle < -90, angle+180, angle)
label_data$hjust2 <- ifelse(angle > 90, 2, 0)
label_data$angle2 <- ifelse(angle < -90, angle+180, angle)



p = ggplot(data = NA_, aes(x = as.factor(num_data),y = NA_$VG.Vp.ratio.var, reorder(NA_$VG.Vp.ratio.SE, -value))) + 
  geom_hline(yintercept = seq(0,0.1,by=.1), color="black", size=0.2, alpha=.2) +                                     
  geom_hline(yintercept = seq(0.5,1,by=.5), color="black", size=0.2, alpha=0.2) +                                     
  geom_hline(yintercept = 0)+
  
  geom_bar(aes(fill=NA_$Pval), stat = "identity")+
  ylim(-3,2)+
  theme_minimal()+
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank()
  )+
  guides(fill=guide_legend(title = "P-Values"))+
  theme(plot.title = element_text(hjust = 0.1))+
  scale_fill_gradient2(low = "#ff0000",mid="#ff00f2",high = "#5400ff", midpoint=0.20, breaks=c(0.0,0.01,0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45)) +
  geom_text(data=label_data, aes(x=num_data, y=NA_$VG.Vp.ratio.var+.02, label=NA_$lab.name, hjust=hjust), color="black", fontface="bold",alpha=0.6, size=3, angle= label_data$angle, inherit.aes = FALSE )+
 
  geom_text(data=label_data, aes(x=num_data, y=-.4, label=vg, hjust=hjust), color="black", fontface="bold",alpha=1, size=2, angle= label_data$angle, inherit.aes = FALSE )+
  coord_polar(start=0)+
  annotate("text", label="0.5", x=0, y=.5, alpha=0.5)+
  annotate("text", label="1.0", x=0, y=1, alpha=0.5)+
  annotate("text", label="0.1", x=0, y=.1, alpha=0.5)+
  geom_text(x=0, y=-3, label="Heritability Estimates of NA Biomarkers", size=4)

p
ggsave(filename = "NA.jpg", width = 25.6, height = 14.4, units = "in", dpi=700)