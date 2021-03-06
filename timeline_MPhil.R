#out.extra='angle=90
## working from: https://stats.andrewheiss.com/misc/gantt.html
library(tidyverse)
library(lubridate)
library(scales)
text_size <- 16

tasks <- tribble(
  ~Start,       ~End,         ~Project,     ~Task,
  "2018-04-01", "2019-06-01", "1) 2D UCS",  "1) 2D UCS",
  "2018-04-01", "2019-02-01", "1) 2D UCS",  "1) code",
  "2018-12-01", "2019-06-01", "1) 2D UCS",  "1) paper (The R journal)",
  "2019-01-01", "2019-03-01", "Milestones", "Candidature confirmation",

  "2019-04-01", "2019-12-01", "2) 2D UCS vs alts",  "2) UCS vs alternatives",
  "2019-04-01", "2019-07-01", "2) 2D UCS vs alts",  "2) code",
  "2019-06-01", "2019-12-01", "2) 2D UCS vs alts",  "2) paper (VAST)",
  #"2020-01-01", "2020-03-01", "Milestones", "Mid candidature review",

  "2019-11-01", "2020-03-01", "Milestones", "pre-submission presentation",
  "2019-09-01", "2020-04-01", "Milestones", "thesis composition"
)

# Convert data to long for ggplot
tasks.long <- tasks %>%
  mutate(Start = ymd(Start),
         End = ymd(End)) %>%
  gather(date.type, task.date, -c(Project, Task)) %>%
  #arrange(date.type, task.date) %>%
  mutate(Task = factor(Task, levels=rev(unique(Task)), ordered=T))
# Custom theme for making a clean Gantt chart
theme_gantt <- function(base_size=11) {
  ret <- theme_bw(base_size) %+replace%
    theme(panel.background = element_rect(fill="#ffffff", colour=NA),
          axis.title.x=element_text(vjust=-0.2), axis.title.y=element_text(vjust=1.5),
          title=element_text(vjust=1.2),
          panel.border = element_blank(), axis.line=element_blank(),
          panel.grid.minor=element_blank(),
          panel.grid.major.y = element_blank(),
          panel.grid.major.x = element_line(size=0.5, colour="grey80"),
          axis.ticks=element_blank(),
          legend.position="bottom",
          axis.title=element_text(size=rel(0.8)),
          strip.text=element_text(size=rel(1)),
          strip.background=element_rect(fill="#ffffff", colour=NA),
          panel.spacing.y=unit(1.5, "lines"),
          legend.key = element_blank())

  ret
}

# Calculate where to put the dotted lines that show up every three entries
x.breaks <- seq(length(tasks$Task) + 0.5 - 3, 0, by=-3)

# Build plot
timeline <- ggplot(tasks.long, aes(x=Task, y=task.date, colour=Project)) +
  geom_line(size=6) +
  geom_vline(xintercept=x.breaks, colour="grey80", linetype="dotted") +
  guides(colour=guide_legend(title=NULL)) +
  labs(x=NULL, y=NULL) + coord_flip() +
  scale_y_date(date_breaks="2 months", labels=date_format("%b ‘%y")) +
  theme_gantt() + theme(axis.text.x=element_text(angle=45, hjust=1)) +
  scale_color_brewer(palette = "Dark2") +
  theme(axis.text.x = element_text(size = text_size),
        axis.text.y = element_text(size = text_size),
        legend.text = element_text(size = text_size))

timeline

