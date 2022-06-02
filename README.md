== Readme File for Circular Barplot in R ==
Contributors: Dhruv Prasad

Requires: R 1.1.452 or later.
Tested up to: R 1.1.456


== Description ==

This plot was designed as a minimalist way to visualize data in a pleasing
manner. This plot consists of bars formed around a circular path and each bar is 
labeled according to the lab it refers. Underneath each bar there is a label
that documents the VG/Vp ratio and the Standard Error encased in a set of parentheses.

== Prerequisites ==

In order to utilize the code, you must install the following packages: "ggplot2, "dplyr",
and "tidyverse." Enter these as "install.packages("package_name")." Do not forget to load by using "library(package_name)", otherwise
the code will not compile!

== Instructional ==
----------------------------------------------------------------------------------------------------------------------------------------
The number of data must be sequenced into a variable and must be used under "as.factor(#data-variable)" for the x variable when creating a ggplot

EX: If there are 36 data, you must store this number as follows: var_num = seq(1,36)
----------------------------------------------------------------------------------------------------------------------------------------

The number of bars will be used to determine the value of the angle for the labels. The following code allows you to calculate these angles. 
Keep in mind that the "data" is the Excel Document/Text Document with the data.

 `label_data = data`                                          
 `number_of_bars=nrow(label_data)`                            
 `angle = 90 - 360 * (num_data-0.5)/number_of_bars`          
 `label_data$hjust <- ifelse(angle < -90, 1, 0)`               
 `label_data$angle <- ifelse(angle < -90, angle+180, angle)`   
 `label_data$hjust2 <- ifelse(angle > 90, 2, 0)`               
 `label_data$angle2 <- ifelse(angle < -90, angle+180, angle)`  



We add geom_hline 3 times to create the cocentric circles around the graph, where the labels for the value will be placed.
The labels are just annotations with the x value set to 0, and the y value set to the corresponding text value. All must be added to the ggplot.
For this to work, you must add "coord_polar(start=0)" to the ggplot!
 ___________________________________________________________________________________
|  geom_hline(yintercept = seq(0,0.1,by=.1), color="black", size=0.2, alpha=.2) +   |                                  
|  geom_hline(yintercept = seq(0.5,1,by=.5), color="black", size=0.2, alpha=0.2) +  |                                    
|  geom_hline(yintercept = 0)                                                       |
|  coord_polar(start=0)+                                                            |
|  annotate("text", label="0.5", x=0, y=.5)+                                        |
|  annotate("text", label="1.0", x=0, y=1)+                                         |
|  annotate("text", label="0.1", x=0, y=.1)                                         |
|___________________________________________________________________________________|


The following piece of code adds the labels to each individual bar. The "angle=label_data$angle" is very important for the angle as it dictates the legibility:

geom_text(data=label_data, aes(x=num_data, y=blood$VG.Vp.ratio.var+.02, label=blood$lab.name, hjust=hjust), color="black", fontface="bold",alpha=0.6, size=3, angle= label_data$angle, inherit.aes = FALSE )+



Circular Bar Plot v. 1.5
