Function  SendEmail {
    Param([string]$EmailSmtpServer, [string]$EmailFrom, [string[]]$EmailTo, [string]$EmailSubject, [string]$EmailBody, [string]$Port, [string]$PathOfthePasswFile )


    $passwordEncrpyted = Get-Content $PathOfthePasswFile| ConvertTo-SecureString
    $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $EmailFrom, $passwordEncrpyted 
    Send-MailMessage `
        -To $EmailTo `
        -From $EmailFrom `
        -Subject $EmailSubject `
        -BodyAsHtml  $EmailBody `
        -SmtpServer $EmailSmtpServer `
        -Credential $Credentials `
        -UseSsl `
        -Port $Port `

}


function ConnectToSqlAndGenerateHtml {
    #Param([string]$ConnectionString, [string]$Sqlcommand, $CommandTimeout)

    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
 
    $SqlConnection.ConnectionString = "Server = 'DBserver' ; Database  ='master'; Integrated Security = true; "
    $Sqlcommand = New-Object System.Data.SqlClient.SqlCommand
    $SqlConnection.Open();
    $Sqlcommand.Connection = $SqlConnection

    $Sqlcommand.CommandText = 'SELECT name,id,xtype,uid FROM SYSOBJECTS 
    '
    $Sqlcommand.CommandTimeout = 300
    $reader = New-Object System.Data.DataTable
    $reader.Load($Sqlcommand.ExecuteReader() )
    Write-Host $reader.Rows.Count
    Write-Host $reader.Columns.Count
    $html = "<!DOCTYPE html><html><body>"
    $html += "<div style=""font-family:'Segoe UI', Calibri, Arial, Helvetica; font-size: 14px; max-width: 768px;"">"
    $html += "Some header text  <br />"
    $html += "Here is full data in table:<br /><br />"
    $html += "<table style='border-spacing: 0px; border-style: solid; border-color: #ccc; border-width: 0 0 1px 1px;'>"
    $html += "<td style='padding: 10px; border-style: solid; border-color: #ccc; border-width: 1px 1px 0 0;'>Name</td>"
    $html += "<td style='padding: 10px; border-style: solid; border-color: #ccc; border-width: 1px 1px 0 0;'>Id</td>" 
    $html += "<td style='padding: 10px; border-style: solid; border-color: #ccc; border-width: 1px 1px 0 0;'>xtype</td>" 
    $html += "<td style='padding: 10px; border-style: solid; border-color: #ccc; border-width: 1px 1px 0 0;'>uid</td>"
  

    foreach ( $row in   $reader.rows) {
        $name = $row["name"].ToString()
        $id = $row["id"].ToString()
        $xtype = $row["xtype"].ToString()
        $uid = $row["uid"].ToString()      
        $html += "<tr>"
        $html += "<td style='padding: 10px; border-style: solid; border-color: #ccc; border-width: 1px 1px 0 0;'>{0}</td>" -f $name
        $html += "<td style='padding: 10px; border-style: solid; border-color: #ccc; border-width: 1px 1px 0 0;'>{0}</td>" -f $id
        $html += "<td style='padding: 10px; border-style: solid; border-color: #ccc; border-width: 1px 1px 0 0;'>{0}</td>" -f $xtype
        $html += "<td style='padding: 10px; border-style: solid; border-color: #ccc; border-width: 1px 1px 0 0;'>{0}</td>" -f $uid

        $html += "</tr>"
    }

    return $html
}

$GetBodyofTheEmail = ConnectToSqlAndGenerateHtml
$EmailTo = @('somebody1@something.com','somebody2@something.com')
SendEmail -EmailSmtpServer 'smtp-mail.outlook.com' -EmailFrom 'somebody1@something.com' -EmailTo $EmailTo -EmailSubject 'subject of the Email' -EmailBody $GetBodyofTheEmail -Port '587' -PathOfthePasswFile 'c:\Temp\password.dat'
$SqlConnection.Close()




