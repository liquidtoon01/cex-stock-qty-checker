[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]
    [string]$ItemsToCheckFilePath,
    [string]$PushoverToken,
    [string]$PushoverUser
)
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
#Items to check
[array] $items = Get-Content -Path $ItemsToCheckFilePath
$ErrorActionPreference = 'SilentlyContinue'
foreach ($i in $items) { ($items[$items.IndexOf($i)] = $i.SubString(0, $i.IndexOf('#'))).trim() } 
foreach ($i in $items) { ($items[$items.IndexOf($i)] = $i.SubString(0, $i.IndexOf(' '))).trim() }
Clear-Host 
$ErrorActionPreference = 'Break'

$wantedinstockpath = "wanted-games-stock-qty.txt"
if(Test-Path $wantedinstockpath){}
else {New-Item -Name $wantedinstockpath }
$wantedinstock = Get-Content -Path $wantedinstockpath
[array] $summary = ""


function Send-PushoverNotification {
    Param(
      [Parameter(Mandatory=$true)]
      [string]$message,
      [string]$item
    )
    if($PushoverToken.Length -gt 1){
        $uri = "https://api.pushover.net/1/messages.json"
        $parameters = @{
            token = $PushoverToken
            user = $PushoverUser
            message = $message
            url = "https://uk.webuy.com/product-detail/?id=$item"
        }
        Write-Host "Sending Pushover Notification: $message"
        $parameters | Invoke-RestMethod -Uri $uri -Method Post
    }
}

foreach ($item in $items){
    $detail = ConvertFrom-Json (Invoke-WebRequest https://wss2.cex.uk.webuy.io/v3/boxes/$item/detail)
    $boxname = $detail.response.data.boxDetails.boxName
    $qty = $detail.response.data.boxDetails.ecomQuantityOnHand
    Write-Host "----------------------------------------------------------"
    Write-Host "Checking quantity for $boxname"
    $check = "$boxname; $qty"
        
    if (Select-String -Pattern $boxname -Path $wantedinstockpath) {
        foreach ($line in $wantedinstock){
            if ($line -match $boxname){
                if ($line -notmatch $check){
                    $oldqty = $line.split(";")
                    $oldqty = $oldqty[1]
                    $writeoutput = "$boxname has changed quantity from$oldqty to $qty."
                    (Get-Content $wantedinstockpath) -replace $line, $check | Set-Content $wantedinstockpath
                    Send-PushoverNotification -message $writeoutput -item $item #send pushover
                }
                else{
                    $writeoutput = "No change for $boxname. Still has $qty in stock."
                    Write-Host $writeoutput
                }
            }
        }
    }
    else {
        Write-Host "Updating stock file with '$check'"
        $writeoutput = "$boxname currently has a quantity of $qty in stock."
        Add-Content -Path $wantedinstockpath -Value $check
    }

    $summary += $writeoutput      
    
}
Write-Host "------------------------Full Summary-----------------------" -ForegroundColor Yellow
for ($i = 1; $i -lt $summary.Count; $i++) {
    if ($summary[$i].Contains("currently")) {
        Write-Host $summary[$i] -ForegroundColor Green
    }
    else {
        Write-Host $summary[$i] -ForegroundColor Red
    }
}
$summary = ""