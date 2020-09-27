library(plotrix)
setwd("C:/glucagon_robert")
TotalScores<-read.delim2("insulin.txt")
group <-read.delim2('parent4class.dat')

library(matrixStats)
GSRS<-c(2,1,NA,2,NA,2,2,NA,1,1,NA,1,2,2,1,2,2,1,NA,NA,2,2,NA,2,2,2,NA,2,1,1,2,1,2,NA,2,2,2,3,2,2,2,1,3,3,1,2,1,1,NA,2,NA,NA,NA,1,3,2,NA,NA,NA,NA,2,NA,2,2,3,1,2,3,NA,2,NA,2,1,2,2,1,1,2,1,2,NA,NA,NA,3,2,2,1,2,3,NA,2,2,3,2,2,2,NA,2,1,1,2,2,3,3,2,2,2,1,NA,1,NA,3,1,3,2,1,1,3,2,3,NA,3,1,2,1,1,3,2,2,1,2,1,3,2,1,1,1,2,2,2,NA,2,1,2,2,NA,NA,3,NA,NA,1,2,3,NA,1,1,3,NA,1,2,2,NA,1,3,2,NA,2,2,1,2,NA,2,1,2,2,1,2,1,3,NA,1,1,NA,2,2,2,1,2,1,NA,2,NA,2,NA,1,1,2,3,NA,3,2,2,2,2,1,NA,2,2,2,NA,NA,NA,2,2,NA,3,2,NA,NA,2,1,3,2,1,NA,3,3,1,1,2,3,1,2,2,NA,2,2,NA,2,3,NA,NA,2,NA,1,3,2,2,2,NA,2,3,2,2,2,3,NA,2,3,2,NA,2,2,2,NA,2,3,2,2,2,2,NA,2,2,2,1)
plot(NULL,xlim=c(-0.2,6),ylim=c(0.6,7),xlab="",ylab="",bty="n",xaxt="n",yaxt="n",main="\n\n  GI symptom severity")
for(a in 1:6)
{
  lines(c(a,a),c(1,7),lty=3,col=rgb(0.8,0.8,0.8))
  text(a-0.5,0.6,paste0("Year ",0:5)[a],cex=0.9)
}
for(a in 1:7)
{
  lines(c(0,6),c(a,a),lty=3,col=rgb(0.8,0.8,0.8))
  text(-0.18,a,a,cex=0.9)
}
lines(c(0,0),c(1,7),col="darkgrey")
lines(c(0,6),c(1,1),col="darkgrey")
for(a in 3:1)
{
  Temp<-TotalScores[GSRS==a&!is.na(GSRS),13:18]
  points(seq(0,6,0.1),sapply(seq(-0.5,5.5,.1),function(b){(c(44.289,61.602,73.133)[a])/19+(c(-6.259,-2.734,2.364)[a])/19*b+(c(0.946,0.115,-0.34)[a])/19*b^2}),type="l",lwd=2,lty=3)
  for(b in 1:6)
  {
    IQRs<-quantile(Temp[,b],probs=c(0.25,0.5,0.75),na.rm=T)/19
    lines(c(b-0.3-0.1*a,b-0.3-0.1*a),c(IQRs[3],max(Temp[,b],na.rm=T)/19))
    lines(c(b-0.3-0.1*a,b-0.3-0.1*a),c(IQRs[1],min(Temp[,b],na.rm=T)/19))
    polygon(c(b-0.5-0.1*a,b-0.1-0.1*a,b-0.1-0.1*a,b-0.15-0.1*a,b-0.1-0.1*a,b-0.1-0.1*a,b-0.5-0.1*a,b-0.5-0.1*a,b-0.45-0.1*a,b-0.5-0.1*a),c(IQRs[1],IQRs[1],IQRs[2]-0.2*(IQRs[2]-IQRs[1]),IQRs[2],IQRs[2]+0.2*(IQRs[3]-IQRs[2]),IQRs[3],IQRs[3],IQRs[2]+0.2*(IQRs[3]-IQRs[2]),IQRs[2],IQRs[2]-0.2*(IQRs[2]-IQRs[1])),col=rgb(1.4-0.4*a,1.4-0.4*a,1.4-0.4*a))
    lines(c(b-0.45-0.1*a,b-0.15-0.1*a),c(IQRs[2],IQRs[2]))
  }
}
boxed.labels(x=3,y=7,"Latent growth classes",font=3,cex=0.9,border=FALSE,bg=rgb(1,1,1,1))
