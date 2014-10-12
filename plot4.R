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
png('plot4.png')

# When plotting, skip missing values (coded as ?)
ind_valid_power = (d$Global_active_power != '?');
ind_valid_submeterings = (d$Sub_metering_1 != '?') & (d$Sub_metering_2 != '?') & (d$Sub_metering_3 != '?');
ind_valid_voltage = (d$Voltage != '?'); 
ind_valid_reactive_power = (d$Global_reactive_power != '?'); 

# ...and convert the factors to numeric values
glob_power <- as.numeric( as.character( d$Global_active_power[ind_valid_power] ) );
sub1 <- as.numeric( as.character( d$Sub_metering_1[ind_valid_submeterings] ) );
sub2 <- as.numeric( as.character( d$Sub_metering_2[ind_valid_submeterings] ) );
sub3 <- as.numeric( as.character( d$Sub_metering_3[ind_valid_submeterings] ) );
voltage <- as.numeric( as.character( d$Voltage[ind_valid_voltage] ) );
reactive_power <- as.numeric( as.character( d$Global_reactive_power[ind_valid_reactive_power] ) );

# Set up the device for 2x2 plots on one plot
old.par <- par(mfrow = c(2,2));

plot(
    d$DateTime[ind_valid_power]
    ,glob_power
    ,type = 'l'
    ,main = ''
    ,xlab = ''
    ,ylab = 'Global Active Power'
);

plot(
    d$DateTime[ind_valid_voltage]
    ,voltage
    ,type = 'l'
    ,main = ''
    ,xlab = 'datetime'
    ,ylab = 'Voltage'
);

plot(
    d$DateTime[ind_valid_submeterings]
    ,sub1
    ,col = plot_colors[1]
    ,type = 'l'
    ,main = ''
    ,xlab = ''
    ,ylab = 'Energy sub metering'
);

lines(d$DateTime[ind_valid_submeterings], sub2, col = plot_colors[2])
lines(d$DateTime[ind_valid_submeterings], sub3, col = plot_colors[3])

legend(
    "topright"
    ,col = plot_colors
    ,lty = 1
    ,legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')
    ,bty = 'n' # no box around legend
);

plot(
    d$DateTime[ind_valid_reactive_power]
    ,reactive_power
    ,type = 'l'
    ,main = ''
    ,xlab = 'datetime'
    ,ylab = 'Global_reactive_power'
);

dev.off()

par(old.par);
