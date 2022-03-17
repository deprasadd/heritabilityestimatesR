library(tidyverse)
library(dplyr)
library(ggplot2)
inflammatory %>% 
  mutate(VG.Vp.ratio.SE = sprintf("%0.1f", VG.Vp.ratio.SE ))
sort(inflammatory$VG.Vp.ratio.SE)

data = inflammatory

se=format(round(inflammatory$VG.Vp.ratio.SE, 2), nsmall = 2)
vg = format(round(inflammatory$VG.Vp.ratio.var, 2), nsmall = 2)
vg=paste(vg, "(", se,")",  sep = "")

num_data = seq(1, 4)


label_data = data
number_of_bars=nrow(label_data)
angle = 90 - 360 * (num_data-0.5)/number_of_bars
label_data$hjust <- ifelse(angle < -90, 1, 0)
label_data$angle <- ifelse(angle < -90, angle+180, angle)
label_data$hjust2 <- ifelse(angle > 90, 2, 0)
label_data$angle2 <- ifelse(angle < -90, angle+180, angle)



p = ggplot(data = inflammatory, aes(x = as.factor(num_data),y = inflammatory$VG.Vp.ratio.var, reorder(inflammatory$VG.Vp.ratio.SE, -value))) + 
  geom_hline(yintercept = seq(0,0.1,by=.1), color="black", size=0.2, alpha=.2) +                                     
  geom_hline(yintercept = seq(0.5,1,by=.5), color="black", size=0.2, alpha=0.2) +                                     
  geom_hline(yintercept = 0)+
  
  geom_bar(aes(fill=inflammatory$Pval), stat = "identity")+
  ylim(-1,1)+
  theme_minimal()+
  theme(
    axis.text = element_blank(),
    axis.title = element_blank(),
    panel.grid = element_blank()
  )+
  guides(fill=guide_legend(title = "P-Values"))+
  theme(plot.title = element_text(hjust = 0.1))+
  scale_fill_gradient(low = "red",high = "purple") +
  geom_text(data=label_data, aes(x=num_data, y=inflammatory$VG.Vp.ratio.var+.02, label=inflammatory$lab.name, hjust=hjust), color="black", fontface="bold",alpha=0.6, size=3, angle= label_data$angle, inherit.aes = FALSE )+
  geom_text(x=0, y=-1, label="Heritability Estimates of Inflammatory-Based Biomarkers", size=4)+

  geom_text(data=label_data, aes(x=num_data, y=-.15, label=vg, hjust=hjust), color="black", fontface="bold",alpha=1, size=2, angle= label_data$angle, inherit.aes = FALSE )+coord_polar(start=0)+
  annotate("text", label="0.5", x=0, y=.5)+
  annotate("text", label="1.0", x=0, y=1)+
  annotate("text", label="0.1", x=0, y=.1)


p
ggsave(filename = "inflammatory.jpg", p, width = 25.6, height = 14.4, units = "in", dpi=800)
