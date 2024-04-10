Set-ExecutionPolicy Bypass -Scope Process -Force

$strRepoPath = 'C:\Users\flesniak\GitHub\AutoCategorizerPS'
Set-Location $strRepoPath

$strWorkingFolderName = 'C:\Users\flesniak\Downloads\Demo-2024-04-09'
$strMicrosoftFormsExportFileName = '2024 PowerShell + DevOps Global Summit Zero-Shot Data Classification Survey(1-17).xlsx'
$arrQuestions = @( `
    'What impact do you think AI/LLMs (ChatGPT, GROK, etc..) will have on the Technology industry?', `
    'What do you think the top use case is for AI/LLMs (ChatGPT, GROK, etc..) in PowerShell scripts?', `
    'Why are you attending the PowerShell + DevOps Global Summit?', `
    'What are you most excited to learn at the PowerShell + DevOps Global Summit?' `
    )

# Convert the Microsoft Forms export to a format that can be used for question response analysis
$strConvertedSurveyFileName = 'SurveyResults.csv'
& '.\Convert-MicrosoftFormsExcelExportToQuestionResponseFormat.ps1' -InputExcelFilePath (Join-Path $strWorkingFolderName $strMicrosoftFormsExportFileName) -ArrayOfQuestions $arrQuestions -OutputCSVPath (Join-Path $strWorkingFolderName $strConvertedSurveyFileName) -DoNotCheckForModuleUpdates

# We are going to skip the "Add-ContextToDataset" step because combining the question and answer sometimes confuses the embeddings
# In our case, more complicated answers might not need the context added.

# We are also going to skip anonymization and de-jagonization because, well, we want to!

# Get the embeddings from OpenAI
$strEmbeddingsFileName = 'SurveyResults-with-Embeddings.csv'
& '.\Get-TextEmbeddingsUsingOpenAI.ps1' -InputCSVPath (Join-Path $strWorkingFolderName $strConvertedSurveyFileName) -DataFieldNameToEmbed 'Response' -OutputCSVPath (Join-Path $strWorkingFolderName $strEmbeddingsFileName) -DoNotCheckForModuleUpdates -EntraIdTenantId 'eee62d27-231e-413c-800e-945907a4953a' -AzureSubscriptionId 'a4a3f08d-8351-478d-a598-e60c4969f8f3' -AzureKeyVaultName 'powershell-conf-2024' -SecretName 'FranksOpenAIKey'

# Cluster the responses
$strClusterMetadataIndicesFileName = 'SurveyResults-ClusterItemIndices.csv'
& '.\Invoke-KMeansClustering.ps1' -InputCSVPath (Join-Path $strWorkingFolderName $strEmbeddingsFileName) -OutputCSVPath (Join-Path $strWorkingFolderName $strClusterMetadataIndicesFileName)

# Get the topic for each cluster and output the results
$strClusterMetadataWithCommentsFileName = 'SurveyResults-Topics-with-RepresentativeComments.csv'
& '.\Get-TopicForEachCluster.ps1' -ClusterMetadataInputCSVPath (Join-Path $strWorkingFolderName $strClusterMetadataIndicesFileName) -UnstructuredTextDataInputCSVPath (Join-Path $strWorkingFolderName $strEmbeddingsFileName) -UnstructuredTextDataFieldNameContainingTextData 'Response' -OutputCSVPath (Join-Path $strWorkingFolderName $strClusterMetadataWithCommentsFileName) -DoNotCheckForModuleUpdates -EntraIdTenantId 'eee62d27-231e-413c-800e-945907a4953a' -AzureSubscriptionId 'a4a3f08d-8351-478d-a598-e60c4969f8f3' -AzureKeyVaultName 'powershell-conf-2024' -SecretName 'FranksOpenAIKey'

# We observed evidence in the result that there may be too many clusters in the default of 9;
# a re-run with fewer specified clusters might be better!
