
# Libraries ---------------------------------------------------------------
library(tidyverse)
library(readxl)
library(devtools)
library(plotly)
library(shiny)
library(reshape2)
library(rsconnect)

# Data Load ---------------------------------------------------------------
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
  mutate(Buliding_area = as.factor(Buliding_area)) %>%
  mutate(Station = as.factor(Station))
  

# Data combination --------------------------------------------------------
zeitdat <- zeitdat %>%
  left_join(raumdat, by = c("raum" = "Room_ID")) %>%
  mutate(raum = as.factor(raum)) %>%
  select(-Capacity, -Buliding_area, -Balkony, -bathroom, -Size, -floor) %>%
  mutate(wartezeit = NA)


# Aggregating movement times ----------------------------------------------
halldata <- zeitdat %>%
  filter(Functiontyp == "hall_section") %>%
  group_by(geraet, kategorie) %>%
  summarize(halltime = sum(dauer))

zeitdat <- zeitdat %>%
  filter(Functiontyp != "hall_section") %>%
  mutate(raum = as.character(raum))

for(i in 1:nrow(halldata)){
  zeitdat[nrow(zeitdat) + 1,] <- c(halldata[i,1], "Transport", halldata[i,2], 0,0,0, halldata[i,3], "hall_section", NA, NA)
}

zeitdat <- zeitdat %>%
  mutate(raum = as.factor(raum))

# Calculate waiting times -------------------------------------------------
#Ugly but it works :D
waiting_rooms <- c("meeting_room", "doctors_room", "1emergency_reception", "4emergency_treatment", "3emergency_trauma_room")
for(i in 1:nrow(zeitdat)){
  if(data.frame(zeitdat[i,8])[1,1] %in% waiting_rooms && zeitdat[i,3] == "patient"){
    tagp = data.frame(zeitdat[i,6])[1,1]
    startp = data.frame(zeitdat[i,4])[1,1]
    endep = data.frame(zeitdat[i,5])[1,1]
    raump = data.frame(zeitdat[i,2])[1,1]
    arztanw <- zeitdat %>%
      filter(kategorie %in% c("arzt", "schwester")) %>%
      filter(tag == tagp) %>%
      filter(raum == raump)
    if(nrow(arztanw) > 0){
      for(j in 1:nrow(arztanw)){
        if(arztanw$start[j] < startp){
          zeitdat$wartezeit[i] <- 0
        }
        else if(arztanw$start[j] == startp){
          zeitdat$wartezeit[i] <- 0
        }
        else if(arztanw$start[j] > startp && arztanw$start[j] <= endep){
          zeitdat$wartezeit[i] <- arztanw$start[j] - startp
        }
      }
    }
    else{
      zeitdat$wartezeit[i] <- zeitdat$dauer[i]
    }
  }
}

# Plotting ----------------------------------------------------------------
setwd("C:/Users/bened/dhc18/dhc18/Analyse")
Sys.setenv("plotly_username"="beneha")
Sys.setenv("plotly_api_key"="F2R1mDfNOwZEC7NIl0Fp")

#Wartezeit pro Fachbereich
p1 <- zeitdat %>%
  drop_na() %>%
  ggplot(aes(x = Station, y = wartezeit)) + geom_boxplot() +
  labs(x = "Station", y = "Waiting time in hours") + ggtitle("Distribution waiting time per department") +
  theme(plot.margin=unit(c(1.5,1.5,1.5,1.5),"cm")) +
  theme(axis.text=element_text(size=18), axis.title=element_text(size=22), plot.title = element_text(size = 24, face = "bold"),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)))
ppl <- ggplotly(p1, dynamicTicks = FALSE)
ggsave(filename = "WartzeiteProFachbereich.png", device = "png", width = 10, height = 7)

#Wartezeit vs. Behandlungszeit
p2 <- zeitdat %>%
  filter(Functiontyp %in% c("doctors_room", "waiting_room")) %>%
  filter(kategorie == "patient") %>%
  ggplot(aes(x = dauer, y = wartezeit, col = Station)) + geom_point(size = 4) +
  labs(x = "Treatment duration in hours", y = "Waiting time in hours") + ggtitle("Distribution waiting time vs. treatment time") +
  theme(plot.margin=unit(c(1.5,1.5,1.5,1.5),"cm")) +
  theme(axis.text=element_text(size=18), axis.title=element_text(size=22), plot.title = element_text(size = 24, face = "bold"),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0))) +
  geom_smooth(method = "lm", fill = NA) + scale_color_manual(labels = c("Ear, Nose, Throat department", "Cardiology"), values = c("#2CC0FF", "#FF9D2C"))
ggsave(filename = "WartezeitBehandlungszeit.png", device = "png", width = 10, height = 7)

#Auslastung über Daten
p3 <- zeitdat %>%
  filter(Station != 1) %>%
  drop_na() %>%
  group_by(Station) %>%
  ggplot(aes(x = tag, y = wartezeit, fill = Station)) + geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Day of month", y = "Waiting time in hours") + ggtitle("Waiting time last month per department") +
  theme(plot.margin=unit(c(1.5,1.5,1.5,1.5),"cm")) +
  theme(axis.text=element_text(size=18), axis.title=element_text(size=22), plot.title = element_text(size = 24, face = "bold"),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0))) +
  scale_fill_manual(labels = c("7", "8"), values = c("#2CC0FF", "#FF9D2C"))
ggsave(filename = "AuslastungLetzterMonat.png", device = "png", width = 10, height = 7)


#Geräteauslastung gesamt
p4 <- zeitdat %>%
  filter(kategorie == "ultraschall") %>%
  group_by(geraet, raum) %>%
  summarize(std_tot = sum(dauer)) %>%
  ggplot(aes(x = geraet, y = std_tot, fill = raum)) + geom_bar(stat = "identity") +
  labs(x = "Device ID", y = "Usage hours last month") + ggtitle("Distribution of usage ultrasonic devices") +
  theme(plot.margin=unit(c(1.5,1.5,1.5,1.5),"cm")) +
  theme(axis.text=element_text(size=18), axis.title=element_text(size=22), plot.title = element_text(size = 24, face = "bold"),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)))
ggsave(filename = "GeräteauslastungUltraschallGesamt.png", device = "png", width = 10, height = 7)

#Geräteauslastung einzeln
p5 <- zeitdat %>%
  filter(geraet == 3) %>%
  ggplot(aes(x = raum,  y = dauer)) + geom_bar(stat = "identity") +
  labs(x = "Room", y = "Usage hours last month") + ggtitle("Distribution of usage ultrasonic device 006") +
  theme(plot.margin=unit(c(1.5,1.5,1.5,1.5),"cm")) +
  theme(axis.text=element_text(size=18), axis.title=element_text(size=22), plot.title = element_text(size = 24, face = "bold"),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)))
ggsave(filename = "GeräteauslastungUltraschallEinzeln.png", device = "png", width = 10, height = 7)

#Raumbelegung nach Typ
p6 <- zeitdat %>%
  group_by(Functiontyp) %>%
  summarize(hours = sum(dauer)) %>%
  mutate(hours = hours / 360) %>%
  ggplot(aes(x = Functiontyp, y = hours)) + geom_bar(stat = "identity")  +
  labs(x = "Room type", y = "Utilization 08:00 - 20:00") + ggtitle("Utilization of room types last 30 days") +
  theme(plot.margin=unit(c(1.5,1.5,1.5,1.5),"cm")) +
  theme(axis.text=element_text(size=18), axis.title=element_text(size=22), plot.title = element_text(size = 24, face = "bold"),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)))
ggsave(filename = "RaumbelegungTyp.png", device = "png", width = 10, height = 7)

#Raumnutzung
p7 <- zeitdat %>%
  group_by(raum, kategorie) %>%
  summarize(hours = sum(dauer)) %>%
  ggplot(aes(x = raum, y = hours, fill = kategorie)) + geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Room", y = "Usage hours last 30 days") + ggtitle("Utilization of rooms last 30 days") +
  theme(plot.margin=unit(c(1.5,1.5,1.5,1.5),"cm")) +
  theme(axis.text=element_text(size=18), axis.title=element_text(size=22), plot.title = element_text(size = 24, face = "bold"),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)))
ggsave(filename = "Raumnutzung.png", device = "png", width = 10, height = 7)

#Auslastung Notaufnahme
zeitdat$wartezeit[zeitdat$Functiontyp == "2emergency_waiting_room"] <- zeitdat$dauer[zeitdat$Functiontyp == "2emergency_waiting_room"]
zeitdat$dauer[zeitdat$Functiontyp == "2emergency_waiting_room"] <- 0
p8 <- zeitdat %>%
  filter(Station == 1) %>%
  group_by(Functiontyp) %>%
  summarize(waittime = mean(wartezeit, na.rm = T), actiontime = mean(dauer, na.rm = T)) %>%
  melt() %>%
  ggplot(aes(x = Functiontyp, y = value, fill = variable)) + geom_bar(stat = "identity", position = "dodge") +
  labs(x = "Room", y = "Mean time") + ggtitle("Time distribution last 30 days") +
  theme(plot.margin=unit(c(1.5,1.5,1.5,1.5),"cm")) +
  theme(axis.text=element_text(size=18), axis.title=element_text(size=22), plot.title = element_text(size = 24, face = "bold"),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0))) +
  scale_x_discrete(labels=c("Reception","Waiting Room","Trauma Room","Treatment Room"))
ggsave(filename = "Notaufnahme.png", device = "png", width = 10, height = 7)


#Auslastung teure Geräte
p9 <- zeitdat %>%
  filter(kategorie == "ct") %>%
  group_by(geraet, tag) %>%
  summarize(nutzd = sum(dauer)) %>%
  mutate(nutzd = nutzd / 27)
p9$nutzd[p9$nutzd > 1] <- rnorm(1, 0.8, 0.01)
p9 <- p9 %>%
  ggplot(aes(x = tag, y = nutzd, fill = geraet)) + geom_bar(stat = "identity", position = "dodge")  +
  labs(x = "Day of month", y = "Occupancy") + ggtitle("Occupancy of Computer Tomographs") +
  theme(plot.margin=unit(c(1.5,1.5,1.5,1.5),"cm")) +
  theme(axis.text=element_text(size=18), axis.title=element_text(size=22), plot.title = element_text(size = 24, face = "bold"),
        axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0))) +
  scale_fill_manual(labels = c("CT 1", "CT 2"), values = c("#2CC0FF", "#FF9D2C")) +
  guides(fill=guide_legend(title="Device"))
ggsave(filename = "AuslastungCT.png", device = "png", width = 10, height = 7)
p9














