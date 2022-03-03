rm(list=ls())
require('neonUtilities')
dat <- loadByProduct(
  dpID = 'DP1.10072.001',
  check.size = F, 
  site = "SCBI",
  startdate = '2019-01',
  enddate = '2019-12',
  package = 'basic',
  release = 'RELEASE-2022',
  token = Sys.getenv('NEON_PAT') # API token from the My Account page for the registered user at data.neonscience.org - highly recommended as it will speed up your downloads and help NEON measure data use.
)

list2env(dat, envir=.GlobalEnv)

PlotSiteYear<-mam_perplotnight

PlotSiteYear$bout<-cumsum(ifelse(difftime(PlotSiteYear$endDate,
                       shift(PlotSiteYear$endDate, fill = PlotSiteYear$endDate[1]), 
                       units = "days") >= 10 
              ,1, 0)) + 1


#What it's doing:
#the difftime finds the difference between each consecutive date and returns a number
#ifelse says if the number is >=10 give it a value of 1, otherwise give it a value of 0
#end up with a long vector of 0's punctuated by a few 1's
#cumsum sums up all the values before it in the vector.  End up with a bunch of 0's, then 1's then 2's
#every time it hits a new cut point where there is a 1 the bout number shifts up by 1.
#This creates a bout grouping variable that upon limited checking appears quite accurate.

#Next Steps:
#need to ensure the dataset is in order by site, date first.
#loop through site years or group by those somehow
#need to translate the bout number into an eventID, maybe take the minimum date in that bout number
#convert it to week and paste together the site, week and year.
