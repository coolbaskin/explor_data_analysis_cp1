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
png('plot3.png')

# Define colors for the lines
plot_colors <- c('black', 'red', 'blue');

# Add additional conditions on all 3 sub-meterings not to be '?' (missing)
ind_valid_submeterings = (d$Sub_metering_1 != '?') & (d$Sub_metering_2 != '?') & (d$Sub_metering_3 != '?');

# Convert the values from factors to numeric for plotting
sub1 <- as.numeric( as.character( d$Sub_metering_1[ind_valid_submeterings] ) );
sub2 <- as.numeric( as.character( d$Sub_metering_2[ind_valid_submeterings] ) );
sub3 <- as.numeric( as.character( d$Sub_metering_3[ind_valid_submeterings] ) );

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

# Add legend
legend(
    "topright"
    ,col = plot_colors
    ,lty = 1
    ,legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3')
);

dev.off()
