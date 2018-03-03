library(tidyverse)
library(readxl)

setwd("C:/Users/bened/dhc18/dhc18/Analyse")


zeitdat <- read_excel("testdaten.xlsx") %>%
  mutate(raum = as.factor(raum)) %>%
  mutate(geraet = as.factor(geraet)) %>%
  mutate(kategorie = as.factor(kategorie))

#Geräteauslastung gesamt
geraet_raum <- zeitdat %>%
  group_by(geraet, raum) %>%
  summarize(std_tot = sum(stunden)) %>%
  ggplot(aes(x = geraet, y = std_tot, fill = raum)) + geom_bar(stat = "identity")
geraet_raum

#Geräteauslastung einzeln
geraet_einzeln <- zeitdat %>%
  filter(geraet == 3) %>%
  ggplot(aes(x = raum,  y = stunden)) + geom_bar(stat = "identity")
geraet_einzeln

#Raumnutzung
raum_nutz <- zeitdat %>%
  group_by(raum, kategorie) %>%
  summarize(hours = sum(stunden)) %>%
  ggplot(aes(x = raum, y = hours, fill = kategorie)) + geom_bar(stat = "identity")
raum_nutz



















