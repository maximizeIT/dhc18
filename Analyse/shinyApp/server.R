



function(input, output) {
  output$plot <- renderPlotly({
    p1 <- ggplot(data = zeitdat, aes(x = Station, y = wartezeit)) + geom_boxplot() +
      labs(x = "Station", y = "Waiting time in hours") + ggtitle("Distribution waiting time per department") +
      theme(plot.margin=unit(c(1.5,1.5,1.5,1.5),"cm")) +
      theme(axis.text=element_text(size=18), axis.title=element_text(size=22), plot.title = element_text(size = 24, face = "bold"),
            axis.title.x = element_text(margin = margin(t = 20, r = 0, b = 0, l = 0)),
            axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)))
    #ppl <- ggplotly(p1, dynamicTicks = FALSE)
    print(p1)
  })
}


