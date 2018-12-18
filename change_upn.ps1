############################################################################################################################
###                                                                                                                      ###
###  	Script by Simon Brunner -                                                                                        ###
###                                                                                                                      ###
###     Version 1.0 - 25.09.2018                                                                                         ### 
###     Write existing UPN to extensionAttribute2                                                                        ###
###     set new UPN to givenname.surname                                                                                 ###
############################################################################################################################
Function Replace-Umlaut {

    param (
       [string]$Text 
    )
 
    # create HashTable with replace map
    $characterMap = @{}
    $characterMap.([Int][Char]'�') = "ae"
    $characterMap.([Int][Char]'�') = "oe"
    $characterMap.([Int][Char]'�') = "ue"
    $characterMap.([Int][Char]'�') = "ss"
    $characterMap.([Int][Char]'�') = "Ae"
    $characterMap.([Int][Char]'�') = "Ue"
    $characterMap.([Int][Char]'�') = "Oe"
    
    # Replace chars
    ForEach ($key in $characterMap.Keys) {
        $Text = $Text -creplace ([Char]$key),$characterMap[$key] 
    }
 
     # return result
     $Text
}
 

Import-Module ActiveDirectory

$OU= "OU=test,OU=Client Admins,OU=Admins,OU=xyz,DC=xyz,DC=local"
write-host $OU


foreach ($user in (Get-ADUser -Filter * -SearchBase $OU)) {
set-aduser -identity $user -add @{extensionAttribute2=$user.userprincipalname}

$updatedupn = $user.GivenName + "." + $user.Surname + "@rega.ch"
$updatedupn1 = Replace-Umlaut $updatedupn
Set-ADUser -identity $user -UserPrincipalName $updatedupn1
}