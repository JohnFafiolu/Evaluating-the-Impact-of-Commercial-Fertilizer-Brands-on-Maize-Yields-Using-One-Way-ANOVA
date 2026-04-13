#entering the dataset
fertilizer = c(rep("A",3), rep("B",4), 
               rep("C",3), rep("D",4), rep("E",2))
maize_yield = c(4.2,3.5,4.6,3.8,3.7,4.0,3.7,3.7,3.2,5.1,7.2,5.8,4.6,6.5,3.7,4.5)
dataset = data.frame(fertilizer,maize_yield)
print(dataset)

#performing the anova test
anova_test = aov(maize_yield~fertilizer, data = dataset)
summary(anova_test)

# 1. Kolmogorov-Smirnov technique
# Extracting the residuals from ANOVA model
residuals = residuals(anova_test)
ks_test = ks.test(residuals, "pnorm", mean(residuals), sd(residuals))
print("Kolmogorov-Smirnov Test")
print(ks_test)

# Shapiro wilk Test

shapiro_test = shapiro.test(residuals)
print("Shapiro wilk Test")
print(shapiro_test)

# Lilliefors Test

install.packages("nortest")
library(nortest)
lilliefors_test= lillie.test(residuals)
print("Lilliefors Test")
print(lilliefors_test)

# 4. Anderson-Darling Test

anderson_test = ad.test(residuals)
print("Anderson-Darling Test")
print(anderson_test)

# 5. Crammer Von Misses test

cvm_test = cvm.test(residuals)
print("Crammer Von Misses test")
print(cvm_test)

# Pearson Test 
pearson_test = pearson.test(residuals)
print("Pearson Test")
print(pearson_test)

# Load necessary package
install.packages("moments")
library(moments)

# Perform D’Agostino Test
dagostino_test = agostino.test(residuals)

# Print test result
print(dagostino_test)


# standardizing residuals
standardized_residuals = scale(residuals)

#Histogram of Standardized Residuals

hist(standardized_residuals, breaks = 10, col = "lightblue", main = "Histogram of Standardized Residuals",
     xlab = "Standardized Residuals", border = "black")

#adding a normal curve
x = seq(min(standardized_residuals), max(standardized_residuals), length = 100)
y = dnorm(x, mean = 0, sd = 1)
lines(x,y * length(standardized_residuals) * diff(hist(standardized_residuals, plot = FALSE)$breaks)[1], color="red", lwd=2)

# QQ Plot
qqnorm(standardized_residuals, main = "Q-Q plot of Standardized Residuals")
qqline(standardized_residuals,col = "red", lwd =2)

# Kernel Density Plot
density_plot = density(standardized_residuals)
plot(
  density_plot,
  main = "Kernel Density Plot of Standardized Residuals",
  xlab = "Standardized Residuals",
  col = "blue",
  lwd = 2
)

# Add a Normal Density Curve
curve(dnorm(x, mean = 0, sd = 1), col = "red", lwd = 2, add = TRUE)
legend("topright", legend = c("Kernel Density", "Normal Density"), col = c("blue","red"), lwd = 2)

#Bartlett's Test
bartletts_test = bartlett.test(maize_yield~fertilizer, data = dataset)
print("Bartlett's Test")
print(bartletts_test)


# Fligner-Killeen test 
fligner_test = fligner.test(maize_yield~fertilizer, data = dataset)
print("Fligner-Killeen test")
print(fligner_test)


fitted_maize_yields = fitted(anova_test)

# Create residual plot
plot(fitted_maize_yields, residuals,
     main = "Residual Plot for Homogeneity of Variance",
     xlab = "Fitted maize_yields",
     ylab = "Residuals",
     pch = 19, col = "blue")
abline(h = 0, col = "red", lwd = 2) 

#Tukey Honestly Significant Difference Test
tukey_test = TukeyHSD(anova_test)
print(tukey_test)

install.packages("agricolae")
# Load necessary library
library(agricolae)

# Perform Least Significant Difference (LSD) test
lsd_test = LSD.test(anova_test, "fertilizer", group = TRUE)

# Print LSD results
print(lsd_test)
