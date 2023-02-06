#install.packages("ggalluvial")
#install.packages("plyr")
require(ggalluvial)
require(RColorBrewer)
require(plyr)

setwd("/Users/joeri/VKGL-releases")
vch <- read.table("dataframe.tsv",header=TRUE,sep='\t',quote="",comment.char="")
vch$Release <- factor(vch$Release, levels = c("may2018", "oct2018", "june2019", "oct2019", "dec2019", "mar2020", "jun2020", "sep2020", "apr2021", "jun2021", "sep2021", "dec2021", "sep2022"))
vch$Release <- revalue(vch$Release, c("may2018"="May 2018", "oct2018"="Oct 2018", "june2019"="June 2019", "oct2019"="Oct 2019", "dec2019"="Dec 2019", "mar2020"="Mar 2020", "jun2020"="June 2020", "sep2020"="Sept 2020", "apr2021"="Apr 2021", "jun2021"="June 2021", "sep2021"="Sept 2021", "dec2021"="Dec 2021", "sep2022"="Sept 2022"))
vch$Consensus <- factor(vch$Consensus)
vch$Consensus <- revalue(vch$Consensus, c("VUS"="VUS", "LB"="LB/B", "LP"="LP/P", "CF"="No consensus", "Absent"="Absent from release"))

palette <- c( "VUS" = "#8DA0CB",
              "LB/B" =  "#A6D854",
              "LP/P" =  "#FC8D62",
              "No consensus" =  "#FFD92F",
              "Absent from release" = "#B3B3B3")

ggplot(vch, aes(x = Release, stratum = Consensus, alluvium = Id, fill = Consensus, label = Consensus)) +
  scale_fill_manual(values = palette) +
  geom_flow() +
  geom_stratum() +
  theme_bw() +
  theme(legend.title = element_blank(), panel.grid = element_blank(), panel.border = element_rect(colour = "black"), axis.ticks = element_line(colour = "black"), axis.text = element_text(color = "black")) +
  theme(legend.position = "bottom") +
  labs(x = "Release date of variant classification database", y = "Number of variants") +
  ggtitle("todo")

ggsave("said-all-tmp.png", width = 11, height = 6)

## special: variants can be followed
#geom_text(stat = "alluvium", discern = FALSE, size = 2, aes(label = after_stat(alluvium))) +
ggplot(vch, aes(x = Release, stratum = Consensus, alluvium = Id, fill = Consensus, label = Consensus)) +
  scale_fill_manual(values = palette) +
  geom_stratum(colour=NA) +
  geom_flow(stat = "alluvium", size=0.1) +
  geom_text(stat = "alluvium", aes(label = Label), size = 1.5) +
  theme_bw() +
  theme(legend.title = element_blank(), panel.grid = element_blank(), panel.border = element_rect(colour = "black"), axis.ticks = element_line(colour = "black"), axis.text = element_text(color = "black")) +
  theme(legend.position = "bottom") +
  labs(x = "Release date of VKGL variant classification database export (public consensus)", y = "Number of variants") +
  ggtitle("Variants in 55 SAID genes that received >1 different classifications in their public VKGL history (https://vkgl.molgeniscloud.org)")
ggsave("vkgl-said-diffclass-pervar.png", width = 11, height = 6)
