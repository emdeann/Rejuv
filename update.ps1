Function UploadSave {
    # Assumes a correct pipenv environment
    cd "C:\Users\Dean\Saved Games\Rejuv"
    pipenv run python upload_save.py

}

Function Watch {    
    $global:FileChanged = $false
    $folder = "C:/Users/Dean/Saved Games/Rejuv"
    $filter = "Game.rxdata"
    $watcher = New-Object IO.FileSystemWatcher $folder, $filter -Property @{ 
        IncludeSubdirectories = $false 
        EnableRaisingEvents = $true
    }

    Register-ObjectEvent $Watcher -EventName Changed -Action {$global:FileChanged = $true} > $null

    while ($true){
        while ($global:FileChanged -eq $false){
            # We need this to block the IO thread until there is something to run 
            # so the script doesn't finish. If we call the action directly from 
            # the event it won't be able to write to the console
            Start-Sleep -Milliseconds 100
        }

        # a file has changed, run our stuff on the I/O thread so we can see the output
        UploadSave

        # reset and go again
        $global:FileChanged = $false
    }
}

Watch