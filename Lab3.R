# Librerias
library("ggpubr")
library("arulesViz")
library("dplyr")
library("cowplot")


# Se cargan los datos
#datos <- read.csv('C:/Users/Will/Desktop/U/Analisis/Lab 3/bank-additional.csv', sep = ";")
datos <- read.csv('C:/bank-additional.csv', sep = ";")


# Se borran registros con datos desconocidos del conjunto de prueba
datos.dis <- datos
datos.dis <- datos.dis[apply(datos.dis!="unknown", 1, all),] %>% droplevels()



##################################################################################################
# Graficos, para revisar clases en funci�n de sus caracter�sticas
##################################################################################################

#age#
boxplot.age =  ggboxplot(data = datos.dis, x = "y", y = "age", color = "y", add = "jitter") + border() 
ydens = axis_canvas(boxplot.age, axis = "y", coord_flip = TRUE) + geom_density(data = datos.dis, aes(x = age, fill = y), alpha = 0.7, size = 0.2) + coord_flip()
boxplot.age = insert_yaxis_grob(boxplot.age, ydens, grid::unit(.2, "null"), position = "right")
ggdraw(boxplot.age)

#duration#
boxplot.duration =  ggboxplot(data = datos.dis, x = "y", y = "duration", color = "y", add = "jitter") + border() 
ydens = axis_canvas(boxplot.duration, axis = "y", coord_flip = TRUE) + geom_density(data = datos.dis, aes(x = duration, fill = y), alpha = 0.7, size = 0.2) + coord_flip()
boxplot.duration = insert_yaxis_grob(boxplot.duration, ydens, grid::unit(.2, "null"), position = "right")
ggdraw(boxplot.duration)

#campaign#
boxplot.campaign =  ggboxplot(data = datos.dis, x = "y", y = "campaign", color = "y", add = "jitter") + border() 
ydens = axis_canvas(boxplot.campaign, axis = "y", coord_flip = TRUE) + geom_density(data = datos.dis, aes(x = campaign, fill = y), alpha = 0.7, size = 0.2) + coord_flip()
boxplot.campaign = insert_yaxis_grob(boxplot.campaign, ydens, grid::unit(.2, "null"), position = "right")
ggdraw(boxplot.campaign)

#nr.employed#
boxplot.nr.employed =  ggboxplot(data = datos.dis, x = "y", y = "nr.employed", color = "y", add = "jitter") + border() 
ydens = axis_canvas(boxplot.nr.employed, axis = "y", coord_flip = TRUE) + geom_density(data = datos.dis, aes(x = nr.employed, fill = y), alpha = 0.7, size = 0.2) + coord_flip()
boxplot.nr.employed = insert_yaxis_grob(boxplot.nr.employed, ydens, grid::unit(.2, "null"), position = "right")
ggdraw(boxplot.nr.employed)

#euribor3m#
boxplot.euribor3m =  ggboxplot(data = datos.dis, x = "y", y = "euribor3m", color = "y", add = "jitter") + border() 
ydens = axis_canvas(boxplot.euribor3m, axis = "y", coord_flip = TRUE) + geom_density(data = datos.dis, aes(x = euribor3m, fill = y), alpha = 0.7, size = 0.2) + coord_flip()
boxplot.euribor3m = insert_yaxis_grob(boxplot.euribor3m, ydens, grid::unit(.2, "null"), position = "right")
ggdraw(boxplot.euribor3m)

#previous#
boxplot.previous =  ggboxplot(data = datos.dis, x = "y", y = "previous", color = "y", add = "jitter") + border() 
ydens = axis_canvas(boxplot.previous, axis = "y", coord_flip = TRUE) + geom_density(data = datos.dis, aes(x = previous, fill = y), alpha = 0.7, size = 0.2) + coord_flip()
boxplot.previous = insert_yaxis_grob(boxplot.previous, ydens, grid::unit(.2, "null"), position = "right")
ggdraw(boxplot.previous)



##################################################################################################
# Se discretizan las variables cuantitativas
##################################################################################################

#Edad#
datos.dis[,"age"] <- cut(datos.dis$age, breaks = c(14, 26, 59, 100), 
                         labels = c("young", "adult", "elderly"))

#Duracion de la llamada#
datos.dis[,"duration"] <- cut(datos.dis$duration, breaks = c(-1, 60, 180, 480, 600, 4000), 
                              labels = c("very.short", "short", "average", "long", "very.long"))

#N�mero de contactos realizados durante la campa�a actual#
datos.dis[,"campaign"] <- cut(datos.dis$campaign, breaks = c(-1, 8, 16, 24, 32, 40), 
                              labels = c("less.than.eight", "nine.to.sixteen", "seventeen.to.twentyfour",
                                         "twentyfive.to.thrirtytwo", "more.than.thrirtythree"))

#N�mero de d�as desde el �ltimo contacto en una campa�a anterior#
datos.dis[,"pdays"] <- cut(datos.dis$pdays, breaks = c(-1, 7, 14, 21, 28, 999), 
                           labels = c("less.than.seven", "eight.to.fourteen", "fiveteen.to.twentyone", 
                                      "more.than.twentytwo", "never.contacted"))

#Tasa de variaci�n del empleo#
datos.dis[,"emp.var.rate"] <- cut(datos.dis$emp.var.rate, breaks = c(-4.00, -3.00, 0.00, 0.18, 1.30, 2.30), 
                                  labels = c("very.negative", "negative", "average", "positive", "very.positive"))

#IPC
datos.dis[,"cons.price.idx"] <- cut(datos.dis$cons.price.idx, breaks = c(0.00, 92.00, 94.00, 120.00), 
                                    labels = c("decrease", "remained", "increase"))

#ICC#
datos.dis[,"cons.conf.idx"] <- cut(datos.dis$cons.conf.idx, breaks = c(-50.00, -35.00, -30.00, -20.00, -15.00, 0.00), 
                                   labels = c("very.high", "high", "normal", "low", "very.low"))

#Euribor#
datos.dis[,"euribor3m"] <- cut(datos.dis$euribor3m, breaks = c(-1.00, 2.00, 3.5, 5), 
                               labels = c("low", "average", "high"))

#Tasa de empleo#
datos.dis[,"nr.employed"] <- cut(datos.dis$nr.employed, breaks = c(0, 5000, 5150, 100000), 
                                 labels = c("low", "average", "high"))

#N�mero de contactos realizados antes de esta campa�a#
datos.dis[,"previous"] <- cut(datos.dis$previous, breaks = c(-1, 1, 2, 3, 20), 
                              labels = c("never", "occasional", "normally", "moderately"))



##################################################################################################
# Se transforman las variables cualitativas a factor 
##################################################################################################

#job#
datos.dis$job <- as.factor(datos.dis$job)
#marital#
datos.dis$marital <- as.factor(datos.dis$marital)
#education#
datos.dis$education <- as.factor(datos.dis$education)
#default#
datos.dis$default <- as.factor(datos.dis$default)
#housing#
datos.dis$housing <- as.factor(datos.dis$housing)
#loan#
datos.dis$loan <- as.factor(datos.dis$loan)
#conctact#
datos.dis$contact <- as.factor(datos.dis$contact)
#month#
datos.dis$month <- as.factor(datos.dis$month)
#day_of_week#
datos.dis$day_of_week <- as.factor(datos.dis$day_of_week)
#poutcome#
datos.dis$poutcome <- as.factor(datos.dis$poutcome)
#y#
datos.dis$y <- as.factor(datos.dis$y)



##################################################################################################
# Se obtienen las reglas de asociaci�n
##################################################################################################

# Obtenci�n de reglas "NO"
reglas.no <- apriori(
  data = datos.dis, 
  parameter = list(support = 0.2, minlen = 2, maxlen = 20, target = "rules"),
  appearance = list(rhs = c("y=no"))
)

# Obtenci�n de reglas "SI"
reglas.si <- apriori(
  data = datos.dis, 
  parameter=list(support = 0.01, confidence = 0.75, maxtime = 300, minlen = 2, maxlen = 20, target="rules"),
  appearance=list(rhs = c("y=yes"))
)



##################################################################################################
# Inspecci�n de reglas
##################################################################################################

# Inspecci�n de reglas "NO" 
inspect(sort(x = reglas.no, decreasing = TRUE, by = "lift")[1:15])

# Inspecci�n de reglas "SI"
inspect(sort(x = reglas.si, decreasing = TRUE, by = "lift")[1:15])



#Gr�ficos
plot(reglas.no[1:20], method = "graph")
plot(reglas.si[1:20], method = "graph")


















# Pevisando reglas########################
#Regla 1 No
nrow(
datos.dis[
  datos.dis$duration == "short" &
  datos.dis$euribor3m == "high" &
  datos.dis$previous=="never" &
  datos.dis$cons.conf.idx=="very.high" &
  datos.dis$nr.employed=="high" &
  datos.dis$y == "yes",
])

# Para reglas de clase SI###########
#Regla 1

nrow(
  datos.dis[
    datos.dis$default == "no" &
    datos.dis$housing == "no" &
      datos.dis$loan == "no" &
      datos.dis$campaign=="less.than.eight" &
      datos.dis$pdays=="less.than.seven" &
      datos.dis$y=="no",
    ])



nrow(
  datos.dis[
    datos.dis$default == "no" &
    datos.dis$duration == "average" &
      datos.dis$campaign=="less.than.eight" &
      datos.dis$pdays=="less.than.seven" &
      datos.dis$poutcome=="success" &
      datos.dis$emp.var.rate=="negative" &
      datos.dis$cons.conf.idx == "very.high" &
      datos.dis$euribor3m=="low" &
      datos.dis$y=="no",
    ])





