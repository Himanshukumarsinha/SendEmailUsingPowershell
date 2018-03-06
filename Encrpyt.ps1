
function EncrptPassword
{
Param([securestring]$password,[string]$Filelocation)

$password |ConvertFrom-SecureString| Out-File $Filelocation

}


$GetTheCreds = Get-Credential
EncrptPassword -password $GetTheCreds.Password -Filelocation 'C:\temp\password.dat'

