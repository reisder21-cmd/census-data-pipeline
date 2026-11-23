# Findings from exploring the Census ACS 5-Year API before building ingestion, 11-23-2027.

## The latest year available for Census data for this particular subject is 2024. So data will be 2020-2024
## Variables needed:
    a. B19013_001E -> Median Household Income for last 12 months(annual income), inflation adjusted for 2024
    b. B19013_001M -> Margin of Error for median income for 12 months
    c. B15003 = Educational attainment for 25 years and older
        022E = Bachelors
        023E = Master's Degree
        024E = Professional Degree
        025E = Doctorate
        * Will need 001E to get total population aged 25 and over. Then a percentage can be calculated(add all 25+ population with  degrees(bachelors and higher) and divide by total 25+ population)
## Income will have to account for inflation. $55,000 in 2020 would be different than $55,000 in 2024, "each vintage is in its own year's dollars". 
    * Avoid comparing overlapping time periods(2019-2023 and 2020-2024), there won't be much difference. Better to do 2015-2019 vs 2020-2024
## Header comes back with all string values, FIPS codes for state and county will be combined to get GEOID, which is  "natural" key
## 3,223 is how many rows come back which is greater than the amount of actual counties in US. The reason is because it is including Puerto Rico. I will include Puerto Rico with a flag so it can be filtered out or included downstream.
## Will have to account for margin of error and how to deal with it. Flag estimates with CV > 30% as low reliablity. So this calculation will have to be done CV = (MOE / 1.645)/ estimate

* The lesson to note: a field can be fine in one table or year and full of annotation codes in another, so the code must check every value
## API example -> curl -s https://api.census.gov/data/2024/acs/acs5\?get=NAME,B19013_001E,B19013_001M\&for=county:\005\&in=state:\15\&key=$CENSUS_API_KEY 