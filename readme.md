# Project details - classification

![alt text](https://think.kera.org/wp-content/uploads/2020/09/shutterstock_1681524226-800x500.jpg)

This project is my mid-term project for the Ironhack Data Analytics 2021 Part Time Bootcamp. I had to write some SQL queries, create a classification model and make some tableau visualizations.

In this project I have worked with the customers database of a commercial bank analysing the customer persona and creating a Logiatic Regression model so as to predict wether if a customer would accept a commercial offer of a product or not.

My **goal** has been to solve this project by creating functions that are generic enough so I can keep using them in the future for other projects.

This readme pretends to explain the workflow of the classification model, i.e. the ipnyb file.

Workflow:

### 1. Importing packages

No much needs to be said in this regard. The most used packages have been pandas, matplotlib, seaborn, sklearn and statsmodels.

### 2. Loading data

In this step I have loaded the db from the bank and cleaned the headers.

### 3. Exploring data

In this part of the project I analyse the data I will have for the model and perform some changes so as to improve it:

- I convert some numerical columns to categoricals as they have very few distinct values
- I remove outliers from numerical columns
- I normalise the numerical columns with boxcox transform

Moreover, I analyse the correlation across numerical variables and the multicollinearity of all columns. This makes me create two additional df, which are a variation of the original df. 

- df: original df
- df1: It doesn't contain the "average_balance" column
- df2: It doesn't contain the quarterly balances columns.

Afterwards we will apply the model to each df so we can see what's the best selection of features.

I also create a normalised version of all dfs, which will serve as the same purpose (comparing the model effectiveness across different data variations):

- df_norm: normalised df
- df1_norm: normalised df1
- df2_norm: normalised df2

I also perform a ChiSquare test, but I won't use it in this project as I had no time to analyse the results of this step.

#### 4. Buidling models

In this part of the project I write some functions that will facilitate my job of comparing the model scores for the 6 df I will work with.

Afterwards, I apply them and obtain 6 different results for 6 different dfs.

#### 5. Conclusions

- The best model for this business case is the one that has a better sensitivity score withou sacrificing too much specificity.

- We have been able to see that the df variation that performed better is the one that works with the original df normalized.

- Nevertheless, the results are volatile given that in each run, SMOTE provokes different results in the different metrics we are using to evaluate each model.
