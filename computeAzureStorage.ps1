
#$filePath = 'C:\Temp\2023-11-Detail_BillingProfile_Azure.csv'

#$filePath = "C:\Users\a78984\OneDrive - Andersen Corporation\Documents\IAHUI\2023 - P12 - IAIHU\2023 - 11 Detail_BillingProfile_ZD4H-C56I-BG7-PGB_202312_en.csv"

$filePath = "C:\Temp\2023 - 01 Detail_BillingProfile_ZD4H-C56I-BG7-PGB_202302_en.csv"

$file = Import-Csv $filePath

$azSum,$diskSum,$GBmatch,$diskMatch,$i = 0

foreach ($line in $file) {

    $meterTest,$splitArray,$diskSize = $null

    if ($line.unitOfMeasure -like '*GB*') {
        
        $meterTest = $line.meterName.ToString()

        switch ($meterTest) { # if meterName matches any of these, get quantity and add to running total
            "Archive LRS Data Stored" {$azSum += $line.quantity; $GBmatch++; Break}
            "Backup RA-GRS Data Stored" {$azSum += $line.quantity; $GBmatch++; Break}
            "Cool LRS Data Stored" {$azSum += $line.quantity; $GBmatch++; Break}
            "Data Archive" {$azSum += $line.quantity; $GBmatch++; Break}
            "Data Stored" {$azSum += $line.quantity; $GBmatch++; Break}
            "General Purpose Data Stored" {$azSum += $line.quantity; $GBmatch++; Break}
            "Hot GRS Data Stored" {$azSum += $line.quantity; $GBmatch++; Break}
            "GRS Data Stored" {$azSum += $line.quantity; $GBmatch++; Break}
            "Hot LRS Data Stored" {$azSum += $line.quantity; $GBmatch++; Break}
            "Hot RA-GRS Data Stored" {$azSum += $line.quantity; $GBmatch++; Break}
            "LRS Data Stored" {$azSum += $line.quantity; $GBmatch++; Break}
            "LRS Snapshots" {$azSum += $line.quantity; $GBmatch++; Break}
            "RA-GRS Data Stored" {$azSum += $line.quantity; $GBmatch++; Break}
            "Standard Data Stored" {$azSum += $line.quantity; $GBmatch++; Break}
           # default {echo 'NO MATCH FOUND'}
        } 
    }

    if (($line.meterName -like '*Disk*') -and ($line.meterName -notlike '*Operations*')) {
        
        $meterTest = $line.meterName.ToString()
        $splitArray = $meterTest.Split(" ")
        $diskSize = $splitArray[0].Substring(1)

        switch ($diskSize) {

            4  {$diskSum += (32 * $line.quantity); $diskMatch++; Break}
            6  {$diskSum += (64 * $line.quantity); $diskMatch++; Break}
            10 {$diskSum += (128 * $line.quantity); $diskMatch++; Break}
            15 {$diskSum += (256 * $line.quantity); $diskMatch++; Break}
            20 {$diskSum += (512 * $line.quantity); $diskMatch++; Break}
            30 {$diskSum += (1024 * $line.quantity); $diskMatch++; Break}
            40 {$diskSum += (2048 * $line.quantity); $diskMatch++; Break}
            50 {$diskSum += (4096 * $line.quantity); $diskMatch++; Break}           

        } 
    }   

    #Write-Host "AzRunningSum is: $azSum"
    #Write-Host "DiskRunningSum is: $diskSum"

}


Write-Host "Found: $GBmatch lines with a GB Match"
Write-Host "AzSum is: $azSum"
Write-Host "Found: $diskMatch lines with a IaaS disk"
Write-Host "DiskSum is: $diskSum"