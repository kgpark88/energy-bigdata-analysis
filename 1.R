library(dplyr)
library(lubridate)
# load csv file
df <- read.csv2("https://github.com/hslu-ige-laes/edar/raw/master/sampleData/flatHeatAndHotWater.csv",
                stringsAsFactors=FALSE)
# filter flat
df <- df %>% select(timestamp, Adr01_energyHeat, Adr02_energyHeat, Adr03_energyHeat)
#df <- df %>% filter(timestamp > "2014-12-01")

df <- df %>% dplyr::mutate(FlatA = lead(Adr01_energyHeat) - Adr01_energyHeat)
df <- df %>% dplyr::mutate(FlatB = lead(Adr02_energyHeat) - Adr02_energyHeat)
df <- df %>% dplyr::mutate(FlatC = lead(Adr03_energyHeat) - Adr03_energyHeat)

# remove counter value column
df <- df %>% select(-Adr01_energyHeat, -Adr02_energyHeat, -Adr03_energyHeat) %>% na.omit()
df$timestamp <- parse_date_time(df$timestamp,
                                orders = "YmdHMS",
                                tz = "Europe/Zurich")

tsd <- ts(df %>% select(-timestamp), frequency = 12, start = min(year(df$timestamp)))

plot(tsd)