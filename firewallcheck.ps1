# Computer names
$computernames = @("anoncomp", "workcomp1", "workcomp2")

# Result array
$compresult = @()

# For each computer
ForEach ($computername in $computernames) {

	# New remote session based on computername
	$sesh = New-PSSession -Computername $computername
  
  # Invoke session and run script
	$check = Invoke-Command -Session $sesh -Scriptblock {
		$[String]firewallstate = netsh advfirewall show currentprofile state
		if($firewallstate -like '*ON*'){return 'true'}
		else{return 'false'}
	}

	Remove-PSession $sesh

  # Add result to array
	$compresult+=$check
}

# For each result if they return false, print machine with firewall off
ForEach ($result in $compresult) {
	if($result -like '*false*'){
		print $result
	}

}
