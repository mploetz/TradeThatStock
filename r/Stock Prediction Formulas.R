source("C:\\Users\\vncel\\Desktop\\MBA\\business\\Stocks\\Calculating stock prices\\Industry.R")

#Functions for stock prices analysis
library(timeSeries)
library(fPortfolio)
library(quantmod)
library(caTools)
library(dplyr)
library(PerformanceAnalytics)
library(ggplot2)
library(viridis)

BETA <- function(stock.return, market.return){
  beta <- cov(stock.return, market.return)/var(market.return)
  return(beta)
}

Stock.Return <- function (x){
  x <- na.omit(x)
  stock.return <- diff(x)/x[-length(x)]
  stock.return <- na.omit(stock.return)
  return(stock.return)
}

RISK <- function(stock.return){
  risk <- sd(stock.return)
  return(risk)
}

get.symbol <- function(ticker) {  
  tryCatch(temp <- Cl(getSymbols(ticker, auto.assign=FALSE, 
                                 src = 'yahoo',
                                 periodicity = period,
                                 from = sDate, to = eDate, warning = FALSE)),
           error = function(e) {
             message("-ERROR-")
             message(paste("Error for ticker symbol  :", ticker, "\n"))
             message("Here's the original error message: ")
             message(e)
             message("")
             return(NULL)},
           finally = {
             message(paste("Data was processed for symbol:", "[", ticker, "]" ))
             message("\n","******************************************", "\n")  
           }) 
}

#Include time value of money
# p.covariance <- function()


  
