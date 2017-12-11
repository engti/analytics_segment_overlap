# Adobe Analytics: Calculating overlapping segments
Small piece of code to look at overlap of segments within Adobe Analytics.

## Setup
The library assumes you have the following packages installed:
 * [**RSiteCatalyst**](https://github.com/randyzwitch/RSiteCatalyst)
 * [**tidyverse**](https://www.tidyverse.org/)
 * [**jsonlite**](https://cran.r-project.org/web/packages/jsonlite/index.html)

## Authentication
To prevent leaking of keys, the auth function is in the _auth.R_ file. But it looks something like this:
> _SCAuth("your api name","your api passphrase")_

If you have admin access to Adobe Analytics, it'll be available in your user profile page. Otherwise, ask your account admin to add you to the [**Web Services API group**](https://marketing.adobe.com/resources/help/en_US/reference/web_services_admin.html).

## Define Metadata
This is a simple showcase, and as such only 2 things are defined here:
* Date Range
	* in YYYY-MM-DD format
* Report Suite ID
	* simplest would be from the page call
	* or use the RSiteCatalyst's _GetReportSuites_ function

## Get Segment Building Blocks
I have access to an account which stores some key product identifiers in *eVar7*, so I am going to use the top entries from that report to see how many of them are being viewed together in the same visit. For example, did the user see product 1 and product 2 within the same visit.

  models <- QueueRanked(
    reportsuite.id = rsid,
    date.from = date_range$start,
    date.to = date_range$end,
    metrics = "visits",
    elements = "evar7",
    top = 10
  )  

## Calculate Overlap







