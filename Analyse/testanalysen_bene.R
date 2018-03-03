library(tidyverse)
library(readxl)

setwd("C:/Users/bened/dhc18/dhc18/Analyse")
zeitdat <- read_excel("testdaten.xlsx") %>%
  mutate(raum = as.factor(raum)) %>%
  mutate(geraet = as.factor(geraet)) %>%
  mutate(kategorie = as.factor(kategorie)) %>%
  mutate(dauer = ende - start)

setwd("C:/Users/bened/dhc18/dhc18/data")
raumdat <- read.csv("rooms.csv", sep = ";") %>%
  as.tibble() %>%
  mutate(Room_ID = as.factor(Room_ID)) %>%
  mutate(Functiontyp = as.factor(Functiontyp)) %>%
  mutate(Buliding_area = as.factor(Buliding_area))
  

zeitdat <- zeitdat %>%
  left_join(raumdat, by = c("raum" = "Room_ID")) %>%
  mutate(raum = as.factor(raum)) %>%
  select(-Capacity, -Buliding_area, -Balkony, -bathroom, -Size, -station, -floor) %>%
  mutate(wartezeit = NA)


for(i in 1:nrow(zeitdat)){
  if(data.frame(zeitdat[i,8])[1,1] %in% c("meeting_room", "doctors_room") && zeitdat[i,3] == "patient"){
    tagp = data.frame(zeitdat[i,6])[1,1]
    startp = data.frame(zeitdat[i,4])[1,1]
    endep = data.frame(zeitdat[i,5])[1,1]
    raump = data.frame(zeitdat[i,2])[1,1]
    arztanw <- zeitdat %>%
      filter(kategorie %in% c("arzt", "schwester")) %>%
      filter(tag == tagp) %>%
      filter(raum == raump)
    print(nrow(arztanw))
    if(nrow(arztanw) > 0){
      for(j in 1:nrow(arztanw)){
        if(arztanw$start[j] < startp && arztanw$end[j] > startp){
          zeitdat$wartezeit[i] <- 0
        }
        else if(arztanw$start[j] == startp){
          zeitdat$wartezeit[i] <- 0
        }
        else if(arztanw$start[j] > startp && arztanw$start[j] <= endep){
          zeitdat$wartezeit[i] <- arztanw$start[j] - startp
        }
        else{
          zeitdat$wartezeit[i] <- zeitdat$dauer[i]
        }
      }
    }
  }
}

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


















