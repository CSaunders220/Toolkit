
#Get a web page to scrape
$scraped_page = Invoke-WebRequest -TimeoutSec 10 http://10.0.17.25/ToBeScraped.html

#Get a cound of links on the web page
#$scraped_page.Links.Count

#Display links as HTML Element
#$scraped_page.Links

#Only select the outerText and href
#$scraped_page.Links | Select-Object outerText, href

#Get outer text of every element with the tag h2
#$h2s = $scraped_page.ParsedHtml.body.getElementsByTagName("h2") | Select-Object outerText

#$h2s

#Print innerText of every div element that has the class as div-1
$divs1 = $scraped_page.ParsedHtml.body.getElementsByTagName("div") | where {
$_.getAttributeNode("class").Value -ilike "div-1"} | select innerText

$divs1