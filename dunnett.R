# Script assumes 3 groups under column 'strain': wt, ko, cre
# We want to compare wt X ko and cre X ko
# We have a list of measurements (column names)
# Pairwise comparisons will be made on each measurement in the list

library (DescTools)


dir_in <- "C:/Users/...."
dir_out <-  "C:/Users/..."
sub_dir <- "dunnett"
setwd(dir_in)

# Import raw data into a dataframe, pre-processed in calc.py
df_data <- read.csv("data.csv")

# Names of measurements you want to analyze (column names in all_attempted.csv)
measure <- list('cc', 'cc','cc_nmda','cc_nmda', 'cc_change', 'cc_change','cc_pchange', 'cc_pchange',
                'gj','gj', 'gj_nmda','gj_nmda', 'gj_change','gj_change', 'gj_pchange','gj_pchange', 
                'rin1','rin1', 'rin1_nmda','rin1_nmda', 'rin_change','rin_change', 'rin_pchange','rin_pchange',  
                'vm1','vm1', 'vm_change','vm_change')

# Dunnett Pairwise comparisons compared to KO (wt-ko, cre-ko)
# new_df <- DunnettTest(column of data ~ independent factor, data = df, control = 'ko')
cc <- DunnettTest(cc ~ strain, data = df_data, control = 'ko')
cc_nmda <- DunnettTest(cc_nmda ~ strain, data = df_data, control = 'ko')
cc_change <- DunnettTest(cc_change ~ strain, data = df_data, control = 'ko')
cc_pchange <- DunnettTest(cc_pchange ~ strain, data = df_data, control = 'ko')
gj <- DunnettTest(gj ~ strain, data = df_data, control = 'ko')
gj_nmda <- DunnettTest(gj_nmda ~ strain, data = df_data, control = 'ko')
gj_change <- DunnettTest(gj_change ~ strain, data = df_data, control = 'ko')
gj_pchange <- DunnettTest(gj_pchange ~ strain, data = df_data, control = 'ko')
rin1 <- DunnettTest(rin1 ~ strain, data = df_data, control = 'ko')
rin1_nmda <- DunnettTest(rin1_nmda ~ strain, data = df_data, control = 'ko')
rin_change <- DunnettTest(rin_change ~ strain, data = df_data, control = 'ko')
rin_pchange <- DunnettTest(rin_pchange ~ strain, data = df_data, control = 'ko')
vm1 <- DunnettTest(vm1 ~ strain, data = df_data, control = 'ko')
vm_change <- DunnettTest(vm_change ~ strain, data = df_data, control = 'ko')

# Make a list from the posthoc results 
# $ko extracts the important properties from the results table
# i.e. diffs, ci, p-value and puts them into a normal dataframe
row_data <- list(cc_nmda$ko, cc_change$ko, cc_pchange$ko, 
                 gj$ko, gj_nmda$ko, gj_change$ko, gj_pchange$ko, 
                 rin1$ko, rin1_nmda$ko, rin_change$ko, rin_pchange$ko,  
                 vm1$ko, vm_change$ko)

# Start the new dataframe by copying the first posthoc result
df_out <- cc$ko

# Add the posthoc data for each relevant measurement as a new row
for (i in row_data){
  df_out = rbind(df_out, i)
}

# Add a column to indicate which wt-ko and cre-ko result corresponds to which measurement  
df_out <- cbind(measure, df_out)

# Take the row names (strain) and make them into a proper column with the heading "strain"
df_out = cbind(strain=rownames(df_out), df_out)

# Check your work 
print (df_out)

# Create the output folder if it doesn't exist
if (file.exists(sub_dir)){
  setwd(file.path(dir_in, sub_dir))
} else {
  dir.create(file.path(dir_in, sub_dir))
  setwd(file.path(dir_in, sub_dir))
}

# Write the posthoc data to file, exluding row names since you make them a proper column
write.csv(df_out, file = "camk_dunnett.csv", row.names = FALSE)
setwd(dir_in)