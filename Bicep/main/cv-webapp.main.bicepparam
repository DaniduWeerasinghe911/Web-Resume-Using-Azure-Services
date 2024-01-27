using './cv-webapp.main.bicep'

param location = 'australiaeast'
param rgName = 'danidu-resume-cv-rg'
param appServicePlanName = 'danidu-resume-cv-asp'
param webAppName = 'danidu-resume-cv-web'
param tags = {}
param isProd = false
param aspConfig = {
  skuCapacity: 1
  sku: 'S1'
  kind: 'windows'
}


