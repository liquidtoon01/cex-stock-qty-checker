# cex-stock-qty-checker
PowerShell script to check specific items for changes in quantity available and can send a notification to your device using Pushover
https://pushover.net/

[What is Pushover and how do I use it?](https://support.pushover.net/i7-what-is-pushover-and-how-do-i-use-it)

![Screenshot of notifications](repo-images/image-4.PNG)

And to get a summary.

![summary of what is currently in stock](repo-images/image-2.png)

This script is meant for the rare items that are always in stock due to their poor quality, but where new copies become available. An example of this is Choplifter 3, Boxed, where there is one copy in stock, however it is known that this is of poor quality. This script will inform you if a second copy becomes available.

## Example setups
It is advised to use this script on a schedule to be automatically alerted when stock is changed for your chosen item. Three examples are provided in this repo;

- [Kubernetes CronJob](kubernetes-deployments/cex-stock-qty-checker.yml)
- [Windows Task Scheduler](windows-task-scheduler-example/cex-stock-qty-checker.xml)
- [Github Action](.github/workflows/stockcheck.yml)

The Powershell script has three parameters;

|  Parameter | Mandatory  |  Example | Notes  |   
|---|---|---|---|
|  ItemsToCheckFilePath |  Y |  ./items-to-check.txt |   |   
|  PushoverToken | N  | aab2nv99jg36mgtrgju29gdmji768o3  | https://pushover.net  |   
|  PushoverUser |  N |  uzdp9r5qsg5uwla1ua5gviyy17j2so |  https://pushover.net |   


## ItemsToCheckFilePath
You need to input the ID's of the items you want to check. This is found in the URL of the item

![example of where to get the ID of the product](repo-images/image.png) 

an example file is provided in this repo.

## PushoverToken & PushoverUser
If you want to be alerted when stock is changed, this script uses Pushover. Set this up and input your token and user IDs. The script will only notify on changes in stock and not every time the script is run.

# Example run
Example run in Powershell

```pwsh
. '.\cex-stock-qty-checker.ps1' -ItemsToCheckFilePath .\items-to-check.txt -PushoverToken "aab2nv99jguojhgfhj29gdmjiyx5o3" -PushoverUser "uzdp3zaqsg5uxfpoiuytviyyq4j2so"
```
