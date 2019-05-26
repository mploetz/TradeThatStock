source("C:\\Users\\vncel\\Desktop\\MBA\\business\\Stocks\\Calculating stock prices\\Stock Prediction Formulas.R")




#######################Enter Your inputs ######################################
stocks <- c(	"AXP",	"NFLX",	"WFC",	"AMZN",	"FB", "TSLA", "LNC", "PRFT", "NVDA")
ticker_symbol <- c(stocks, index)
rm(index)
sDate <- "2018-4-17" #Start Date
eDate <- "2019-5-24" #End Date
period <- "daily" #daily, weekly or monthly 


##############################################################################

#For Market analysis
Stock.Price <- do.call(cbind,lapply(ticker_symbol,get.symbol))
Stock.Price<- na.omit(Stock.Price)
names(Stock.Price) <- gsub("\\..+","",names(Stock.Price)) 

#For the Efficient Frontier
Portfolio.Price <- do.call(cbind,lapply(stocks,get.symbol))
Portfolio.Price<- na.omit(Portfolio.Price)
names(Portfolio.Price) <- gsub("\\..+","",names(Portfolio.Price)) 





##########################Basic Graphs##########################################
#Very Basic Plot of Stock Prices With Market
plot.xts(Stock.Price,
         type = "l",
         legend.loc = "topleft"
)

#Very Basic Plot of Stock Prices With Market
plot.xts(Portfolio.Price,
         type = "l",
         legend.loc = "topleft"
)




#############################Analysis Metrics######################################
#Calculating Beta and Average Returns for the Stocks
return <- rep(NA, nrow(Stock.Price))
cummulative.return <- rep(NA, nrow(Stock.Price)) #Generate the formula for cumulative return
average.return <- rep(NA, length(ticker_symbol))
market.return <- rep(NA, length(ticker_symbol))
risk <- rep(NA, length(ticker_symbol))
beta <- rep(NA, length(ticker_symbol))

market.return <- Stock.Return(Stock.Price[,length(ticker_symbol)])
write.csv(market.return, "temp.csv")
for (i in 1:(length(ticker_symbol))) {
  return <- Stock.Return(Stock.Price[,i])
  risk[i] <- RISK(return)
  beta[i] <- BETA(return, market.return)
  average.return[i] <- mean(return)
}

Metrics <- data.frame("Stock" = ticker_symbol, 
                     Average.Return = average.return*100,
                     Risk = risk*100,
                     Beta= beta)
rm(market.return)

#Calculating and Plotting the Frontier and Efficient Portfolios
portfolioReturns <- na.omit(ROC(Portfolio.Price, type= 'discrete'))
portfolioReturns <- as.timeSeries(portfolioReturns)
effFrontier <- portfolioFrontier(portfolioReturns, constraints = "LongOnly")

plot(effFrontier, c(1,2,3,4 ,5))

#Plot Frontier Weights
frontierWeights <- getWeights(effFrontier)
colnames(frontierWeights) <- stocks
risk_return <- frontierPoints(effFrontier)

#Output Correlation
cor_matrix <- data.frame(cor(portfolioReturns))
cov_matrix <- data.frame(cov(portfolioReturns))



######################ANNUAL SHARPE RATIO FROM DAILEY RETURNS############################
#Annualize Data (useful for daily prices)
riskReturnPoints <- frontierPoints(effFrontier) 
annualizedPoints <- data.frame(targetRisk=riskReturnPoints[, "targetRisk"] * sqrt(252),
                               targetReturn=riskReturnPoints[,"targetReturn"] * 252)
plot(annualizedPoints, 
     main= "Annual Efficient Frontier")

###################COMPUTING SHARPE RATIO FROM MONTHLY RETURNS###########################

riskReturnPoints <- frontierPoints(effFrontier) 
annualizedPoints <- data.frame(targetRisk=riskReturnPoints[, "targetRisk"] * sqrt(12),
                               targetReturn=riskReturnPoints[,"targetReturn"] * 12)

plot(annualizedPoints, 
     main= "Annual Efficient Frontier")


#Ploting the Sharpe Ratio for each individual point along the graph
#Sharpe Ratio- How well the return of an asset compensates the investor for the risk taken
riskFreeRate <- 0 #Incorporate this by including Acharya's code
plot((annualizedPoints[,"targetReturn"]-riskFreeRate) / annualizedPoints[,"targetRisk"], 
     xlab="point on efficient frontier",
     ylab="Sharpe ratio",
     main= "Sharpe ratio for each point \non the Efficient Frontier" )


#Plotting the Frontier Weights
barplot(t(frontierWeights), main="Frontier Weights", col=viridis(ncol(frontierWeights)+2), 
        legend=colnames(frontierWeights),
        xlab= "Point on the Efficient Frontier")
box()

#Generating the Minimum Variance
mvp <- minvariancePortfolio(portfolioReturns, spec=portfolioSpec(), constraints="LongOnly")
summary(mvp)
tangencyPort <- tangencyPortfolio(portfolioReturns, spec=portfolioSpec(), constraints="LongOnly")
summary(tangencyPort)

#Extract the Weights of the portfolio
mvpweights <- getWeights(mvp)
tangencyweights <- getWeights(tangencyPort)

#Extract value at risk
covRisk(portfolioReturns, mvpweights)
varRisk(portfolioReturns, mvpweights, alpha = 0.05)
cvarRisk(portfolioReturns, mvpweights, alpha = 0.05)

######################PLOT THE OUTPUTS#############################
#ggplot MVP Weights
df <- data.frame(mvpweights)
assets <- colnames(frontierWeights)
ggplot(data=df, aes(x=assets, y=mvpweights, fill=assets)) +
  geom_bar(stat="identity", position=position_dodge(),colour="black") +
  geom_text(aes(label=sprintf("%.02f %%",mvpweights*100)),
            position=position_dodge(width=0.9), vjust=-0.25, check_overlap = TRUE) +
  ggtitle("Minimum Variance Portfolio Optimal Weights")+ theme(plot.title = element_text(hjust = 0.5)) +
  labs(x= "Assets", y = "Weight (%)")

dft <- data.frame(tangencyweights)
assets <- colnames(frontierWeights)
ggplot(data=dft, aes(x=assets, y=tangencyweights, fill=assets)) +
  geom_bar(stat="identity", position=position_dodge(),colour="black") +
  geom_text(aes(label=sprintf("%.02f %%",tangencyweights*100)),
            position=position_dodge(width=0.9), vjust=-0.25, check_overlap = TRUE) +
  ggtitle("Tangency Portfolio Weights")+ theme(plot.title = element_text(hjust = 0.5)) +
  labs(x= "Assets", y = "Weight (%)")

#ggplot Pie
bar <- ggplot(df, aes(x = "", y = mvpweights, fill=assets)) + geom_bar(width= 1, stat="identity") + ggtitle("Minimum Variance Portfolio Weights")+ theme(plot.title = element_text(hjust = 0.5)) 
pie <- bar + coord_polar("y", start=0)
pie + scale_fill_brewer(palette="Blues")+
  theme_minimal()

bar <- ggplot(dft, aes(x = "", y = tangencyweights, fill=assets)) + geom_bar(width= 1, stat="identity") + ggtitle("Tangency Portfolio Weights")+ theme(plot.title = element_text(hjust = 0.5)) 
pie <- bar + coord_polar("y", start=0)
pie + scale_fill_brewer(palette="Blues")+
  theme_minimal()

#Set Specs to different level of risk 
Spec = portfolioSpec()
setSolver(Spec) = "solveRshortExact"
setTargetRisk(Spec) = .12
constraints <- c("minW[1:length(tickers)]=-1","maxW[1:length(tickers)]=.60", "Short")

effFrontierShort <- portfolioFrontier(portfolioReturns, Spec, constraints = constraints)
weights <- getWeights(effFrontierShort)
write.csv(weights, "weightsShort.csv")
colnames(weights) <- stocks

plot(effFrontierShort, c(1, 2, 3))

#Plot out the weights
barplot(t(weights), main="Frontier Weights", col=cm.colors(ncol(weights)+2), legend=colnames(weights))

effPortShort <- minvariancePortfolio(portfolioReturns, Spec, constraints=constraints)
optWeights <- getWeights(effPortShort)
tanPortShort <- tangencyPortfolio(portfolioReturns, Spec, constraints=constraints)
tanWeights <- getWeights(tanPortShort)
maxR <- maxreturnPortfolio(portfolioReturns , Spec, constraints=constraints)
maxWeights <- getWeights(maxR)

#ggplot MVP Weights
df <- data.frame(tanWeights)
assets <- colnames(frontierWeights)
ggplot(data=df, aes(x=assets, y=tanWeights, fill=assets)) +
  geom_bar(stat="identity", position=position_dodge(),colour="black") +
  geom_text(aes(label=sprintf("%.02f %%",tanWeights*100)),
            position=position_dodge(width=0.9), vjust=-0.25, check_overlap = TRUE) +
  ggtitle("Tangency Portfolio With Shorts Allowed")+ theme(plot.title = element_text(hjust = 0.5)) +
  labs(x= "Assets", y = "Weight (%)")