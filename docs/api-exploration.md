1. The latest year available for Census data for this particular subject is 2024. So data will be 2020-2024
2. Variables needed:
    a. B19013_001E -> Median Income for last 12 months(annual income)
    b. B19013_001M -> Margin of Error for median income for 12 months
    c. B15003 = Educational attaintment for 25 years and older
        022E = Bachelors
        023E = Master's Degree
        024E = Professional Degree
        025E = Doctorate
        * Will need 001E to get total population. Then a percentage can be calculated(add all degrees and divide by total)
3. Income will have to account for inflation. $55,000 in 2020 would be different than $55,000 in 2024. 
4. Header comes back with FIPS codes for state and county, we can use these as our "natural" key
5. 3,223 is how many rows come back which is greater than the amount of actual counties in US. The reason is because it is including Puerto Rico. Decide whether to include or not.
6. Will have to account for margin of error and how to deal with it. If margin of error is half or more of income for example, that is a problem. So this calcuation will have to be done .CV = (MOE / 1.645)/ estimate

* The lesson to note: a field can be fine in one table or year and full of annotation codes in another, so the code must check every value