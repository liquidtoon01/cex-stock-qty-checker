# cex-stock-qty-checker
PowerShell script to check if the available quantity for an item at CEX has changed and can send a notification to your device using Pushover
https://pushover.net/

This script is meant for items that are always in stock due to it's poor quality, but there is a lack of notifications if a new one comes in stock. An example is Choplifter 3, Boxed on the SNES. There is one copy of this in stock in the CEX database but is known that this one copy is of poor quality. This script will notify you if a second copy comes into stock.

![Screenshot of notifications](IMG_0195.PNG)

And to get a summary of what the current stock quantity is;

![summary of what is currently in stock](image-2.png)

This script uses three .txt files as a "database" for reviewing what items you want reviewed, what stores to check and when to notify as stock is available or removed. There is an optional fourth file to sending summary notifications of all your wanted items that are in stock.

It is advised to use this script on a schedule to be automatically alerted when stock is changed for your chosen item. Windows Task Scheduler is a perfect example of this. An WTS XML file has been provided as an example in this repo.

The Powershell script has seven parameters;

|  Parameter | Mandatory  |  Example | Notes  |   
|---|---|---|---|
|  ItemsToCheckFilePath |  Y |  ./items-to-check.txt |   |   
|  PushoverToken | N  | aab2nv99jg36mgtrgju29gdmji768o3  | https://pushover.net  |   
|  PushoverUser |  N |  uzdp9r5qsg5uwla1ua5gviyy17j2so |  https://pushover.net |   


## ItemsToCheckFilePath
You need to input the ID's of the items you want to check. This is found in the URL of the item

![example of where to get the ID of the product](image.png) 

an example file is provided in this repo.

## PushoverToken & PushoverUser
If you want to be alerted when stock is changed, this script uses Pushover. Set this up and input your token and user IDs. The script will only notify on changes in stock and not every time the script is run.

# Example run
Example run in Powershell

```pwsh
. '.\cex-stock-qty-checker.ps1' -ItemsToCheckFilePath .\items-to-check.txt  -PushoverToken "aab2nv99jguojhgfhj29gdmjiyx5o3" -PushoverUser "uzdp3zaqsg5uxfpoiuytviyyq4j2so" 
```
