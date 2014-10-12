# Read the data
filename <- '..\\data\\household_power_consumption.txt';

if(!file.exists(filename)) {
    stop(paste0('Cannot find file <', filename, '> in \'data\' directory <', getwd(), '>'));
}

data <- read.csv2(filename);

# Data transformations
d <- data;

# 1. Make Date a Date class
d$Date <- as.Date(d$Date, '%d/%m/%Y');

# 2. Subset the data to period [2007-02-01, 2007-02-02]
d <- d[d$Date >= '2007-02-01' & d$Date <= '2007-02-02', ];

# 3. Create a DateTime member for plotting
d$DateTime <- as.POSIXct(paste(d$Date, d$Time))

# Plot
png('plot1.png');

# When plotting, skip missing values (coded as ?) and convert the factor to numeric 
ind_valid_power = (d$Global_active_power != '?');
glob_power <- as.numeric( as.character( d$Global_active_power[ind_valid_power] ) );

hist(
    glob_power
    ,col = 'red'
    #,breaks = 12
    ,main = 'Global Active Power'
    ,xlab = 'Global Active Power (kilowatts)'
    ,ylab = 'Frequency'
);

# dev.copy(png, 'plot1.png');
dev.off()
