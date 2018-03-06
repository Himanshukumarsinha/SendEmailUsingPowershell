
function EncrptPassword
{
Param([securestring]$password,[string]$Filelocation)

$password |ConvertFrom-SecureString| Out-File $Filelocation
#$password |ConvertFrom-SecureString| Out-File $Filelocation
#$GetTheCredsBacl = Get-Content("C:\temp\dump.test.log") | ConvertTo-SecureString
#Write-Host @GretTheCredsBacl

}


$GetTheCreds = Get-Credential
EncrptPassword -password $GetTheCreds.Password -Filelocation 'C:\temp\password.dat'

