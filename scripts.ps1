# write-output Apigee Artifacts
$token = $env:TOKEN
$org = $env:ORG
$baseURL = "https://apigee.googleapis.com/v1/organizations/"
$headers = @{Authorization = "Bearer $token"}

# --------------------Apigee All Artifacts-------------------------------------------

# ----------------------create apigee organisation level artifacts folder------------
# if(!(test-path -PathType container fl-apigee-org)){
#       mkdir "fl-apigee-org"
#       cd apigee
#       Write-Host "inside if"
# }
# else {
#       cd fl-apigee-org
#       Write-Host "else"
# }

# # create apigee artifacts non prod folder
# if(!(test-path -PathType container artifacts-nonprod)){
#       mkdir "artifacts-nonprod"
#       cd artifacts-nonprod
#       Write-Host "inside 2nd if"
# }
# else {
#       cd artifacts-nonprod
#       Write-Host "2nd else"
# }

# --------------------------------Proxies-------------------------------------------
    if(!(test-path -PathType container proxies)){
        mkdir "proxies"
        cd proxies
    }
    else {
        cd proxies
    }

    $path = $baseURL+$org+"/apis"
    $proxies = Invoke-RestMethod -Uri "https://apigee.googleapis.com/v1/organizations/$org/apis" -Method 'GET' -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$org-proxies.json"

    foreach ($proxy in $($proxies.proxies)) {
        $path1 = $baseURL+$org+"/apis/"+$($proxy.name)+"/revisions"
        $proxyRevs = Invoke-RestMethod -Uri $path1 -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60

        # Get the latest deployed revision number
        $latestRevision = $proxyRevs | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum

        if(!(test-path -PathType container $($proxy.name))){
            mkdir -p "$($proxy.name)"
            cd $($proxy.name)
        }
        else {
            cd $($proxy.name)
        }

        $path2 = $baseURL+$org+"/apis/"+$($proxy.name)+"/revisions/"+$($latestRevision)+"?format=bundle"
        $zipFile = $org+"-proxy-"+$($proxy.name)+"-rev"+$($latestRevision)+".zip"
        
        $response = Invoke-RestMethod -Uri $path2 -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile $zipFile

        Expand-Archive -Path $zipFile -Force
        Remove-Item -Path $zipFile -Force
        cd..
    }
    cd..

# --------------------------------SharedFlows-------------------------------------------
    if(!(test-path -PathType container SharedFlows)){
        mkdir "SharedFlows"
        cd SharedFlows
    }
    else {
        cd SharedFlows
    }

    $sharedflowpath = $baseURL+$org+"/sharedflows"
    $sharedflows = Invoke-RestMethod -Uri $sharedflowpath -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$org-sharedflow.json"

    foreach ($sharedflow in $($sharedflows.sharedflows)) {
        $flowDetailRev = $baseURL+$org+"/sharedflows/"+$($sharedflow.name)+"/revisions"
        $FlowRevs = Invoke-RestMethod -Uri $flowDetailRev -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60

        if(!(test-path -PathType container $($sharedflow.name))){
            mkdir -p "$($sharedflow.name)"
            cd $($sharedflow.name)
        }
        else {
            cd $($sharedflow.name)
        }

        # Get the latest deployed revision number
        $latestFlowRevision = $($FlowRevs) | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
        $flowDetailRev2 = $baseURL+$org+"/sharedflows/"+$($sharedflow.name)+"/revisions/"+$($latestFlowRevision)+"?format=bundle"
        $SharedFlowZipFile = $org+"-sharedflow-"+$($sharedflow.name)+"-rev"+$($latestFlowRevision)+".zip"
        
        $response = Invoke-RestMethod -Uri $flowDetailRev2 -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile $SharedFlowZipFile

        Expand-Archive -Path $SharedFlowZipFile -Force
        Remove-Item -Path $SharedFlowZipFile -Force
        cd ..
    }
    cd ..

# ----------------------------------Org KVMs---------------------------------------
    if(!(test-path -PathType container org-kvms))
    {
        mkdir "org-kvms"
        cd org-kvms
    }
    else {
        cd org-kvms
    }

    $kvmpath = $baseURL+$org+"/keyvaluemaps"
    $orgkvms = Invoke-RestMethod -Uri $kvmpath -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60

    foreach ($orgkvm in $($orgkvms)) {
        $kvmpath2 = $kvmpath+"/"+$($orgkvm)+"/entries"
        $kvm = Invoke-RestMethod -Uri $kvmpath2 -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$org-($($orgkvm)).json"
    }
    cd ..

# ----------------------------API Products------------------------------------------
    if(!(test-path -PathType container apiproducts))
    {
        mkdir "apiproducts"
        cd apiproducts
    }
    else {
        cd apiproducts
    }

    $productpath = $baseURL+$org+"/apiproducts"
    $apiproducts = Invoke-RestMethod -Uri $productpath -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$org-apiproducts.json"
    cd ..

    $productpath = $baseURL+$org+"/apiproducts"
    $apiproducts = Invoke-RestMethod -Uri $productpath -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$org-apiproducts.json"

# -----------------------------Developers------------------------------------------
    if(!(test-path -PathType container developers))
    {
        mkdir "developers"
        cd developers
    }
    else {
        cd developers
    }

    $developerpath = $baseURL+$org+"/developers"
    $developers = Invoke-RestMethod -Uri $developerpath -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$org-developers.json"
    cd ..

    $developerpath = $baseURL+$org+"/developers"
    $developers = Invoke-RestMethod -Uri $developerpath -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$org-developers.json"

# ------------------------------Apps-------------------------------------------------
    if(!(test-path -PathType container apps))
    {
        mkdir "apps"
        cd apps
    }
    else {
        cd apps
    }

    $Apps = $baseURL+$org+"/apps?expand=true"
    $Appdetails = Invoke-RestMethod -Uri $Apps -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$org-apps.json"
    cd ..

    $Apps = $baseURL+$org+"/apps?expand=true"
    $Appdetails = Invoke-RestMethod -Uri $Apps -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$org-apps.json"

# ------------------------------master-deployments-proxies----------------------------
    $masterDeploymentPath = $baseURL+$org+"/deployments"
    $masterDeployments = Invoke-RestMethod -Uri $masterDeploymentPath -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$org-master-proxy-deployments.json"

# -----------------------------Environments Start-------------------------------------
    if(!(test-path -PathType container env))
    {
        mkdir "environments"
        cd environments
    }
    else {
        cd environments
    }

    $envpath = $baseURL+$org+"/environments"
    $environments = Invoke-RestMethod -Uri $envpath -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$org-env.json"
    
    
    # -----------------------------Environments - KVMs -------------------------------------
    if(!(test-path -PathType container env-kvms))
    {
        mkdir "env-kvms"
        cd env-kvms
    }
    else {
        cd env-kvms
    }
    Write-Host "entered into environments..."
    
    foreach ($env in $($environments)) {
        Write-Host "entered into each env..."
        mkdir -p "$($env)"
        cd $($env)

        $kvmpathenv = $baseURL+$org+"/environments/"+$($env)+"/keyvaluemaps"
        $envkvms = Invoke-RestMethod -Uri $kvmpathenv -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$env-kvms.json"

        foreach ($envkvm in $($envkvms)) {
            $kvmpathenv2 = $kvmpathenv+"/"+$($envkvm)+"/entries"
            $envkvm = Invoke-RestMethod -Uri $kvmpath2 -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$env-($($envkvm)).json"
        }
        cd ..
        cd ..
    # -------------------------------Environments - Targetservers-----------------------------
        if(!(test-path -PathType container env-Targetservers))
        {
            mkdir "env-Targetservers"
            cd env-Targetservers
        }
        else {
            cd env-Targetservers
        }
        mkdir -p "$($env)"
        cd $($env)

        $targetserverpathenv = $baseURL+$org+"/environments/"+$($env)+"/targetservers"
        $envtargetserver = Invoke-RestMethod -Uri $targetserverpathenv -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$env-targetservers.json"

        foreach ($envtargetserver in $($envtargetservers)) {
            $targetserverpathenv2 = $envtargetserver+"/"+$($envtargetserver)
            $envtargetserver = Invoke-RestMethod -Uri $targetserverpathenv2 -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$env-($($envtargetserver)).json"
        }
        cd ..
        cd ..
    # --------------------------------Environment - Proxies--------------------------------------

        if(!(test-path -PathType container env-proxies))
        {
            mkdir "env-proxies"
            cd env-proxies
        }
        else {
            cd env-proxies
        }
        mkdir -p "$($env)"
        cd $($env)

        $proxypathenv = $baseURL+$org+"/environments/"+$($env)+"/deployments"
        $envproxy = Invoke-RestMethod -Uri $proxypathenv -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$env-proxies.json"
        
        cd ..
        cd ..
    }
    cd ..

    # $envpath = $baseURL+$org+"/environments"
    # $environments = Invoke-RestMethod -Uri $envpath -Method:Get -Headers $headers -ContentType "application/json" -ErrorAction:Stop -TimeoutSec 60 -OutFile "$org-env.json"
    # cd ..


# -----------------------------Environments Closing-------------------------------------
cd ..

