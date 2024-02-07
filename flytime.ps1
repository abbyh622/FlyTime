# this is a customizable timer for fly video tracking 
# the user inputs the number of ROIs and seconds per ROI
# for each ROI, a beep is played when its time starts and the ROI # is displayed with a . added for every second
# the beep for each ROI is a higher pitch than the last, and resets to the starting pitch when the timer returns to the first ROI
# the spacebar controls starting/stopping so you can keep the program open for multiple recordings
# copyright trademark patent etc Abby Hawken 2024 (just kidding........)


$host.UI.RawUI.WindowTitle = "FlyTime"
$header1 = "----------------------------------------------`n              Fly Tracking Timer            `n----------------------------------------------"
$header3 = "         Press spacebar to start/stop"
$header4 = "----------------------------------------------"

write-host $header1 -foregroundcolor DarkCyan


# function to validate rois input as a number 1-8
function validate-rois {
    param([string]$prompt, [int]$min, [int]$max)
    do {
        $input = read-host -prompt $prompt 
        # check if input is 1 digit and 1-8
        if ($input -match '^\d$' -and $input -ge $min -and $input -le $max) {
            return $input
        } else {
            write-host "Number of ROIs must be between 1-8"
        }
    } while ($true)
}

# function to validate sec input as a number
function validate-sec {
    param([string]$prompt)
    do {
        $input = read-host -prompt $prompt
        # check if input is only digits
        if ($input -match '^\d+$') {
            return $input
        } else {
            write-host "Seconds must be a number."
        }
    } while ($true)
}

# get and validate inputs
$roisStr = validate-rois -prompt 'Number of ROIs' -min 1 -max 8
$secStr = validate-sec -prompt 'Seconds per ROI'

# Add 1 to make it easier to print in the loops
$rois = [int]$roisStr + 1
$sec = [int]$secStr + 1

# define this header after getting inputs
$header2 = "         ROIs: $roisStr           Seconds: $secStr"

clear-Host

# display headers
write-host $header1 -foregroundcolor DarkCyan
write-host $header2 -foregroundcolor Cyan
write-host $header3 -foregroundcolor Cyan
write-host $header4 -foregroundcolor DarkCyan

write-host ""
write-host ""

# get cursor position to use for main output
$cursorPos = $host.UI.RawUI.CursorPosition
$cursorX = $cursorPos.X 
$cursorY = $cursorPos.Y
$winWidth = $host.UI.RawUI.WindowSize.Width - 1

$running = $false 

while($true) {
    $key = [console]::readkey($true)
    if($key.key -eq "spacebar") {
        $running = -not $running
        if ($running) {
        }
    }

    while($running) {
        $i = 1

        # ROI outer loop
        while($i -lt $rois) {
            $pitch = 400 + ($i * 100)
            [console]::beep($pitch, 300)
            write-host $i -foregroundcolor Yellow -nonewline

            # seconds inner loop
            for($j = 1; $j -lt $sec; $j++) {
                start-sleep -seconds 1
                write-host " ." -foregroundcolor Yellow -nonewline                            
            }

            # move cursor to beginning of line
            $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $cursorX, $cursorY
            # overwrite line with whitespace
            $whitespace = " " * $winWidth
            write-host -nonewline $whitespace
            # move cursor back to beginning of line
            $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $cursorX, $cursorY
           
            $i++

            # toggle running state with spacebar
            if ([console]::keyavailable) {
                $key = [console]::readkey($true)
                if ($key.key -eq "spacebar") {
                    $running = -not $running
                    if (-not $running) {
                        break
                    }
                }
            }
        }
    }
}