//This include application deplooymnets
//inclding webapps and Functionapps infra level
//No Code deployments

targetScope = 'subscription'

@description('Environment Location')
param location string = 'australiaeast'

@description('Resource Group Name for the deployment')
param rgName string

@description('App Service Plan Name for the deployment')
param appServicePlanName string

@description('vault webapp name')
param webAppName string

@description('Object containing resource tags.')
param tags object = {}

@description('Identify if its a production environment')
param isProd bool = false

@description('Log analytics workspace ID')
param diagnosticLogAnalyticsId string = ''

@description('Log analytics workspace ID')
param diagnosticStorageAccountId string = ''

@description('App Service Plan Configuration')
param aspConfig object


var webAppPlanName = '${appServicePlanName}-win'


var diagSettings = {
  name: 'diag-log'
  workspaceId: diagnosticLogAnalyticsId
  storageAccountId: diagnosticStorageAccountId
  eventHubAuthorizationRuleId: ''
  eventHubName: ''
  enableLogs: true
  enableMetrics: true
  retentionPolicy: {
    days: 0
    enabled: true
  }
}

// Resource Group for networking
resource rg_webservices 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  tags: tags
  location: location
}

//App Service Plan deployment for Webapps Windows backend
module aspWeb '../modules/web/app-service-plan/app-service-plan.bicep' = {
  name: 'deployAppServicePlan'
  scope:resourceGroup(rg_webservices.name)
  params: {
    location: location
    appKind: 'windows'
    appPlanName: webAppPlanName
    skuCapacity:  aspConfig.skuCapacity
    skuName: aspConfig.skuName
    skutier: aspConfig.skutier
    diagSettings:  isProd ? diagSettings : {}
    tags: tags
  }
}

//Deploy Vault App
module app '../modules/web/app/app-windows.bicep' = {
  name: 'deployAdminApp'
  scope:resourceGroup(rg_webservices.name)
  params: {
    location: location
    appName: webAppName
    serverFarmId: aspWeb.outputs.appServiceId
    diagSettings:  isProd ? diagSettings : {}
    tags: tags
    ipSecurityRestrictions: []
  }
}
