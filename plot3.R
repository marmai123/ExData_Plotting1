# Plot 3
llibrary(dplyr)

# Download data file and store it in "data" directory, unzip file
if(!file.exists("data")){
        dir.create("data")
}
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url,destfile = "./data/mydata.zip")
unzip("mydata.zip")

# Store data in table, remove "?" and set wanted variable classes
data <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?",
                   colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))

# Filter for wanted dates
data$Date <- as.Date(data$Date, "%d/%m/%Y")
fdata <- filter(data, Date == "2007-02-01" | Date == "2007-02-02")

# Combine date and time to one variable
dates <- fdata$Date
times <- fdata$Time
Date.Time <- paste(dates, times)

# Add new date-time variable to fdata
fdata <- cbind(Date.Time, fdata)

# Remove Date and Time variables from fdata
fdata <- select(fdata, -(Date:Time))

# Change format on Date.Time variable
fdata$Date.Time <- strptime(fdata$Date.Time, "%Y-%m-%d %H:%M:%S")


# Make the plot
with(fdata, {plot(Date.Time, Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(Date.Time, Sub_metering_2, col = "red")
lines(Date.Time, Sub_metering_3, col = "blue")})
legend("topright", lty = 1, col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


## Copy plot to a PNG file
dev.copy(png, file = "plot3.png", width = 480, height = 480)
dev.off()

