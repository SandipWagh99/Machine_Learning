#source("http://bioconductor.org/biocLite.R")
#biocLite("EBImage")
library(EBImage)
library(keras)

setwd("C:/Users/sandip wagh/Desktop/Images")
pics <- c('p1.jpg','p2.jpg','p3.jpg','p4.jpg','p5.jpg','p6.jpg','c1.jpg',
          'c1.jpg','c1.jpg','c1.jpg','c1.jpg','c1.jpg')

mypic <-list()
for (i in 1:12 ) {mypic[[i]] <- readImage(pics[i])}
print(mypic[[1]])
display(mypic[[1]])

display(mypic[[8]])
summary(mypic[[1]])
#hist(mypic[[12]])
str(mypic)

#resize
for (i in 1:12){mypic[[i]] <- resize(mypic[[i]],28,28)}
str(mypic)

#reshape
for (i in 1:12){mypic[[i]] <- array_reshape(mypic[[i]],c(28,28,3))}
str(mypic)
trainx <- NULL

for (i in 1:5) {trainx <-rbind(trainx,mypic[[i]])}
str(trainx)
for (i in 7:11) {trainx <-rbind(trainx,mypic[[i]])}
str(trainx)

testx <- rbind(mypic[[6]],mypic[[12]])
trainy <- c(0,0,0,0,0,1,1,1,1,1)
testy <- c(0,1)

#one hot encoding
trainLabels <- to_categorical(trainy)
trainLabels
testLabels <- to_categorical(testy)
testLabels

#Model create
#tensorflow::tf_config()
model <- keras_model_sequential()
model %>%
  layer_dense(units = 256,activation = 'relu',input_shape = c(2352)) %>%
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dense(units = 2, activation = 'softmax')
summary(model)

#compile
model %>%
  compile(loss='binary_crossentropy',
          optimizer = optimizer_rmsprop(),
          metrics = c('accuracy'))

#fit model
history <- model %>%
  fit( trainx ,
      trainLabels,
      epochs =30,
      batch_size=32,
      validation_split = 0.2  )
plot(history)

#Evaluation and Prediction
model %>% evaluate(trainx,trainLabels)
pred <- model %>%predict_classes(trainx)
pred
table(Predicted =pred, Actual=trainy)

prob <- model %>% predict_proba(trainx)
prob

cbind(prob, predicted= pred,Actual=trainy)
display(mypic[[11]])
          
model %>% evaluate(testx,testLabels)          
pred <- model %>%predict_classes(testx)
pred         

table(Predicted =pred, Actual=testy)
display(mypic[[6]])
display(mypic[[12]])

